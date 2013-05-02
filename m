Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3EBHg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:36:57 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50728 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3EBHgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:36:55 -0400
Message-ID: <5182178A.5020607@linux.vnet.ibm.com>
Date: Thu, 02 May 2013 15:36:42 +0800
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
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1366626208.2721.12.camel@laptop> <5181FE1B.6010508@linux.vnet.ibm.com> <1367478643.5808.71.camel@marge.simpson.net>
In-Reply-To: <1367478643.5808.71.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050207-1618-0000-0000-000003CE42BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 03:10 PM, Mike Galbraith wrote:
>>
>> I've done the test for several times, also compared with the throttle
>> approach, default 1ms interval still works very well, the regression on
>> hackbench start to exceed 2% when interval become 100ms on my box, but
>> please note the pgbench already gain a lot benefit at that time.
>>
>> I think now we could say that wake-affine is useful, and we could not
>> simply kill it.
> 
> Oh, it's definitely useful.  Communicating tasks deeply resent talking
> over interconnects (advanced tin cans and string).  My little Q6600 box
> can even be described as dinky-numa given enough imagination.. place
> communicating tasks on different core2 "nodes" if you will, throughput
> falls through the floor.  Shared L2 is quick like bunny, dram ain't.

Nice, so we got another proof to defend wake-affine now ;-)

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

