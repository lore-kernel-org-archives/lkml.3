Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3FCD0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:26:33 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33222 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3FCD00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:26:26 -0400
Message-ID: <51AC0CD4.9070302@linux.vnet.ibm.com>
Date: Mon, 03 Jun 2013 11:26:12 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51ABFF6A.60206@linux.vnet.ibm.com> <1370228941.5988.66.camel@marge.simpson.net>
In-Reply-To: <1370228941.5988.66.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060303-7014-0000-0000-0000031B89A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 11:09 AM, Mike Galbraith wrote:
> On Mon, 2013-06-03 at 10:28 +0800, Michael Wang wrote: 
>> On 05/28/2013 01:05 PM, Michael Wang wrote:
>>> wake-affine stuff is always trying to pull wakee close to waker, by theory,
>>> this will bring benefit if waker's cpu cached hot data for wakee, or the
>>> extreme ping-pong case.
>>>
>>> And testing show it could benefit hackbench 15% at most.
>>>
>>> However, the whole stuff is somewhat blindly and time-consuming, some
>>> workload therefore suffer.
>>>
>>> And testing show it could damage pgbench 50% at most.
>>>
>>> Thus, wake-affine stuff should be smarter, and realise when to stop
>>> it's thankless effort.
>>
>> Is there any comments?
> 
> (I haven't had time to test-drive yet, -rt munches time like popcorn)

I see ;-)

During my testing, this one works well on the box, solved the issues of
pgbench and won't harm hackbench any, I think we have caught some good
point here :)

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

