Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3CYV6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:58:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20094 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab3CYV6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:58:07 -0400
Message-ID: <5150C82B.9050006@oracle.com>
Date: Mon, 25 Mar 2013 17:56:59 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <5150B1C2.8090607@oracle.com> <20130325163844.042a45ba@annuminas.surriel.com> <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com> <CANN689G5dGv2Hn2epbG8Pi8=bH=Lmz0hHxCS405FbPBvwDJ=gg@mail.gmail.com>
In-Reply-To: <CANN689G5dGv2Hn2epbG8Pi8=bH=Lmz0hHxCS405FbPBvwDJ=gg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 05:51 PM, Michel Lespinasse wrote:
> On Mon, Mar 25, 2013 at 2:42 PM, Michel Lespinasse <walken@google.com> wrote:
>> I'll be surprised if it does, because we don't actually have single
>> depth nesting here...
>> Adding Peter & Ingo for advice about how to proceed
>> (the one solution I know would involve using arch_spin_lock() directly
>> to bypass the lockdep checks, but there's got to be a better way...)
> 
> Maybe spin_lock_nest_lock() can help too. I'm not sure, the feature is
> undocumented.
> 

I think we should name the locks properly (using 'key') and initialize their
lockdep_map using lockdep_init_map instead of letting spin_lock pass the
"&sma->sem_base[i].lock" as name.


Thanks,
Sasha
