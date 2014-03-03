Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaCCKIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:08:41 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33539 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaCCKI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:08:29 -0500
Message-ID: <53145486.8060009@linaro.org>
Date: Mon, 03 Mar 2014 05:08:06 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/14] uprobes: Add uprobes support for ARM
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org> <20140301123026.GD21483@n2100.arm.linux.org.uk> <53131DBE.7020500@linaro.org> <20140303062324.GB20583@linux.vnet.ibm.com>
In-Reply-To: <20140303062324.GB20583@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/14 01:23, Srikar Dronamraju wrote:

> It should be me who should take the blame for this and not Oleg.  This
> was discussed more than couple of times.  I can recollect couple of
> discussions here.
> http://article.gmane.org/gmane.linux.kernel/1017186
> http://article.gmane.org/gmane.linux.kernel/1001605

I wasn't trying to assign blame to anyone, I was just soliciting an 
opinion from the last uprobes maintainer I had a conversation with. 
Thanks for the links.

> I know there were more discussions on this, but I cant dig them out at
> this time.  Finally it was decided that
> 1. Users shouldnt have to select more than one config to select Uprobes.
> 2. There was no point in selecting Uprobes and not having Uprobe_event
> and vice versa.
>
>  From the above, If a user chose UPROBE_EVENT, (which is the interface
> for uprobes), we would automatically assume that he wants to use Uprobes
> framework.
>
>> like "select" is used in part maybe just to avoid the recursive
>> dependency error that would be generated if "depends on" were used
>> in both places.
>
> We did "Select Uprobes" not because of avoiding recursive dependency but
> as told above, to select the framework, given that user has chosen the
> framework. We dont want to give a choice to user to choose uprobe_event
> but not choose Uprobes or vice versa.

I suppose that's more to the point.

>> However I don't think UPROBES should be dependent on
>> UPROBE_EVENT, only the other way around.  As RK noted in previous
>
> Whats the point of having the framework(Uprobes) without an interface?
>

My comment was based only in the fact it built successfully that way on 
both x86 and ARM.  If there's no way to access the functionality without 
both selected then I suppose it does make sense to not allow that 
configuration.  Maybe it's time to remove one of these config symbols. 
I didn't see anything in the email history on this that says that would 
be a bad idea.  I'll try and come up with a patch.

-dl

