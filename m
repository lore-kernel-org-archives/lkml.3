Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3BVDdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 22:33:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:22874 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab3BVDdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 22:33:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="290422605"
Message-ID: <5126E705.3040308@intel.com>
Date: Fri, 22 Feb 2013 11:33:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
References: <51079178.3070002@linux.vnet.ibm.com> <510791B2.6090506@linux.vnet.ibm.com> <1361366720.10155.25.camel@laptop> <5125A966.6040601@linux.vnet.ibm.com> <1361446661.26780.15.camel@laptop> <5126DD98.7030202@linux.vnet.ibm.com>
In-Reply-To: <5126DD98.7030202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 10:53 AM, Michael Wang wrote:
>> > 
>>> >> And the final cost is 3000 int and 1030000 pointer, and some padding,
>>> >> but won't bigger than 10M, not a big deal for a system with 1000 cpu
>>> >> too.
>> > 
>> > Maybe, but quadric stuff should be frowned upon at all times, these
>> > things tend to explode when you least expect it.
>> > 
>> > For instance, IIRC the biggest single image system SGI booted had 16k
>> > cpus in there, that ends up at something like 14+14+3=31 aka as 2G of
>> > storage just for your lookup -- that seems somewhat preposterous.
> Honestly, if I'm a admin who own 16k cpus system (I could not even image
> how many memory it could have...), I really prefer to exchange 2G memory
> to gain some performance.
> 
> I see your point here, the cost of space will grow exponentially, but
> the memory of system will also grow, and according to my understanding ,
> it's faster.

Why not seek other way to change O(n^2) to O(n)?

Access 2G memory is unbelievable performance cost.

There are too many jokes on the short-sight of compute scalability, like
Gates' 64K memory in 2000.

-- 
Thanks Alex
