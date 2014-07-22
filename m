Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbaGVTgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:36:21 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:16160 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaGVTgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:36:19 -0400
Message-ID: <53CEBD2F.2040705@hp.com>
Date: Tue, 22 Jul 2014 15:36:15 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <20140721211801.GA12149@gmail.com>
In-Reply-To: <20140721211801.GA12149@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 05:18 PM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long@hp.com>  wrote:
>
>> Testing done on a 4-socket Westmere-EX boxes with 40 cores (HT off)
>> showed the following performance data (average kops/s) with various
>> load factor (number of pause instructions) used in the critical
>> section using an userspace mutex microbenchmark.
>>
>>    Threads  Load	Waiting Futex	Spinning Futex 	  %Change
>>    -------  ----	-------------	--------------	  -------
>>      256	     1	     6894	    8883	    +29%
>>      256	    10	     3656	    4912	    +34%
>>      256	    50	     1332	    4358	   +227%
>>      256	   100	      792	    2753	   +248%
>>       10	     1	     6382	    4838	    -24%
>>       10	    10	     3614	    4748	    +31%
>>       10	    50	     1319	    3900	   +196%
>>       10	   100	      782	    2459	   +214%
>>        2	     1	     7905	    7194	   -9.0%
>>        2	    10	     4556	    4717	   +3.5%
>>        2	    50	     2191	    4167	    +90%
>>        2	   100	     1767	    2407	    +36%
> So the numbers look interesting - but it would be _really_ important
> to provide noise/sttdev figures in a sixth column as well (denoted in
> percentage units, not in benchmark units), so that we know how
> significant a particular speedup (or slowdown) is.
>
> Thanks,
>
> 	Ingo

The performance can varies quite a bit depending on what other processes 
are running at the test execution time. I will include stddev data in 
the next iteration of the patch.

-Longman
