Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaCCUvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:51:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbaCCUvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:51:54 -0500
Date: Mon, 3 Mar 2014 21:50:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/14] uprobes: Add uprobes support for ARM
Message-ID: <20140303205039.GA8949@redhat.com>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org> <20140301123026.GD21483@n2100.arm.linux.org.uk> <53131DBE.7020500@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53131DBE.7020500@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, David Long wrote:
>
> Oleg,
>
> I've been looking at arch/Kconfig and kernel/trace/Kconfig where they
> deal with uprobes.  The relevant items are CONFIG_UPROBES and
> CONFIG_UPROBE_EVENT.  It just doesn't look right to me.

Yes, this looks strange. I never understood these dependencies. In fact
I even never tried. And I do not really understand kbuild, unfortunately...

>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -87,7 +87,8 @@ config KPROBES_ON_FTRACE
>>
>>  config UPROBES
>>  	bool "Transparent user-space probes (EXPERIMENTAL)"
>> -	depends on UPROBE_EVENT && PERF_EVENTS
>> +	depends on ARCH_SUPPORTS_UPROBES
>> +	depends on PERF_EVENTS

And why CONFIG_UPROBES should depend on PERF_EVENTS? uprobes can be
used by (say) systemtap without UPROBE_EVENT/PERF_EVENTS.

But as Russell pointed out the events directory is only built if
CONFIG_PERF_EVENTS=y, so it should depend on it or select...


I dunno. Personally I vote for the patch from Srikar in

	http://article.gmane.org/gmane.linux.kernel/1017186

This is what we currently have, currently CONFIG_UPROBES is not
user-selectable anyway.

Oleg.

