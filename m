Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911Ab3DCCqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:46:52 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:32799 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3DCCqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:46:50 -0400
Message-ID: <515B97FF.2040409@linux.vnet.ibm.com>
Date: Wed, 03 Apr 2013 10:46:23 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com>
In-Reply-To: <515A9859.6000606@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040302-4790-0000-0000-000007AD5D36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:35 PM, Alex Shi wrote:
[snip]
>>
>> The reason may caused by wake_affine()'s higher overhead, and pgbench is
>> really sensitive to this stuff...
> 
> Thanks for testing. Could you like to remove the last patch and test it
> again? I want to know if the last patch has effect on pgbench.

Done, here the results of pgbench without the last patch on my box:

| db_size | clients |  tps  |   |  tps  |
+---------+---------+-------+   +-------+
| 22 MB   |       1 | 10662 |   | 10679 |
| 22 MB   |       2 | 21483 |   | 21471 |
| 22 MB   |       4 | 42046 |   | 41957 |
| 22 MB   |       8 | 55807 |   | 55684 |
| 22 MB   |      12 | 50768 |   | 52074 |
| 22 MB   |      16 | 49880 |   | 52879 |
| 22 MB   |      24 | 45904 |   | 53406 |
| 22 MB   |      32 | 43420 |   | 54088 |	+24.57%
| 7484 MB |       1 |  7965 |   |  7725 |
| 7484 MB |       2 | 19354 |   | 19405 |
| 7484 MB |       4 | 37552 |   | 37246 |
| 7484 MB |       8 | 48655 |   | 50613 |
| 7484 MB |      12 | 45778 |   | 47639 |
| 7484 MB |      16 | 45659 |   | 48707 |
| 7484 MB |      24 | 42192 |   | 46469 |
| 7484 MB |      32 | 36385 |   | 46346 |	+27.38%
| 15 GB   |       1 |  7677 |   |  7727 |
| 15 GB   |       2 | 19227 |   | 19199 |
| 15 GB   |       4 | 37335 |   | 37372 |
| 15 GB   |       8 | 48130 |   | 50333 |
| 15 GB   |      12 | 45393 |   | 47590 |
| 15 GB   |      16 | 45110 |   | 48091 |
| 15 GB   |      24 | 41415 |   | 47415 |
| 15 GB   |      32 | 35988 |   | 45749 |	+27.12%

Very nice improvement, I'd like to test it with the wake-affine throttle
patch later, let's see what will happen ;-)

Any idea on why the last one caused the regression?

Regards,
Michael Wang

> 

