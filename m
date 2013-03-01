Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3CACbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:31:22 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59995 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3CACbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:31:21 -0500
Message-ID: <513012E0.1010904@linux.vnet.ibm.com>
Date: Fri, 01 Mar 2013 10:30:56 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: wakeup buddy
References: <512EFB4B.5040204@linux.vnet.ibm.com> <87hakwssc9.fsf@sejong.aot.lge.com> <1362046013.4460.195.camel@marge.simpson.net> <1362065465.1758.15.camel@leonhard>
In-Reply-To: <1362065465.1758.15.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030102-7014-0000-0000-000002A7A984
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 11:31 PM, Namhyung Kim wrote:
> 2013-02-28 (목), 11:06 +0100, Mike Galbraith:
>> On Thu, 2013-02-28 at 18:25 +0900, Namhyung Kim wrote:
>>
>>> Not sure if it should require bidirectional relationship.  Looks like
>>> just for benchmarks.  Isn't there a one-way relationship that could get
>>> a benefit from this?  I don't know ;-)
>>
>> ??  Meaningful relationships are bare minimum bidirectional, how can you
>> describe one connection and have it remain meaningful?  I love "her" is
>> unlikely to lead to anything meaningful if "she" doesn't know you exist.
> 
> Maybe I misunderstood something.  I was thinking about typical
> cooperation models like manager-worker, producer-consumer or pipeline
> and thought that they are usually one-way relationship in terms of the
> wakeup.

I agree with Mike's point here, relax the restriction usually benefit
one model but damage more.

The whole wake_affine() stuff is somewhat blindly, we image that the
cache will benefit the wakee but could not estimate how much it is, and
the formula contain too many elements, I'd prefer to gamble only when
I'm likely to win, that will win less money, but lose less too ;-)

Regards,
Michael Wang

> 
> Thanks,
> Namhyung
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

