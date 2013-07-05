Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3GEGQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:16:37 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47053 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEGQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:16:36 -0400
Message-ID: <51D664B9.7010407@linux.vnet.ibm.com>
Date: Fri, 05 Jul 2013 14:16:25 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <20130702085202.GA23916@twins.programming.kicks-ass.net> <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net> <51D5428D.7080805@linux.vnet.ibm.com> <1372934013.9046.16.camel@marge.simpson.net> <51D633DB.5010508@linux.vnet.ibm.com> <1372997318.7315.23.camel@marge.simpson.net> <51D64C84.5080100@linux.vnet.ibm.com> <1373002865.8318.11.camel@marge.simpson.net>
In-Reply-To: <1373002865.8318.11.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070506-8878-0000-0000-000007D38100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 01:41 PM, Mike Galbraith wrote:
[snip]
>>
>> Have you tried to use more loops and groups? will that show even bigger
>> regressions?
> 
> Nope, less on either side.
> 
> hackbench -g 100 -l 1000
>                                                                        avg
> 3.10.0-regress    21.895    21.564    21.777    21.958    22.093    21.857     1.000
> 3.10.0-regressx   22.844    23.268    23.056    23.231    22.375    22.954     1.050
> 
> hackbench -g 1 -l 100000
>                                                                        avg
> 3.10.0-regress    29.913    29.711    30.395    30.213    30.236    30.093     1.000
> 3.10.0-regressx   30.392    31.003    30.728    31.008    30.389    30.704     1.020

Hmm...I'm not expecting to reserve all of the 15%, but this still seems
a little bit more...

PeterZ has suggested some optimization which I sent out yesterday, I
suppose they haven't been included into this test yet, correct?

Since currently I could not reproduce the issue on my box with that
patch, I suppose it may solved that issue ;-)

Regards,
Michael Wang

> 
>> BTW, is this the results of 10 group and 40 sockets == 400 tasks?
> 
> Yeah, stock.
> 
> Off to do some body/mind tuning.  Bavarian mushrooms don't hide as well
> as memory access thingies.. and I can still out run 'em.
> 
> -Mike 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

