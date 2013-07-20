Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3GTNCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:02:32 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44842 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3GTNCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:02:30 -0400
Message-ID: <51EA8C23.5070408@linux.vnet.ibm.com>
Date: Sat, 20 Jul 2013 18:39:55 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: Raghavendra KT <raghavendra.kt.linux@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RESEND][PATCH] mm: vmstats: tlb flush counters
References: <20130716234438.C792C316@viggo.jf.intel.com> <CAC4Lta1mHixqfRSJKpydH3X9M_nQPCY3QSD86Tm=cnQ+KxpGYw@mail.gmail.com> <51E95932.5030902@sr71.net>
In-Reply-To: <51E95932.5030902@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072012-8878-0000-0000-0000080A0156
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 08:50 PM, Dave Hansen wrote:
> On 07/19/2013 04:38 AM, Raghavendra KT wrote:
>> While measuring non - PLE performance, one of the bottleneck, I am seeing is
>> flush tlbs.
>> perf had helped in alaysing a bit there, but this patch would help
>> in precise calculation. It will aslo help in tuning the PLE window
>> experiments (larger PLE window
>> would affect remote flush TLBs)
>
> Interesting.  What workload is that?  I've been having problems finding
> workloads that are too consumed with TLB flushes.
>

Dave,
ebizzy is the one. and dbench to some small extent.

[root@codeblue ~]# cat /proc/vmstat  |grep nr_tlb ; 
/root/data/script/do_ebizzy.sh;  cat /proc/vmstat  |grep nr_tlb
nr_tlb_remote_flush 721
nr_tlb_remote_flush_received 923
nr_tlb_local_flush_all 13992
nr_tlb_local_flush_one 0
nr_tlb_local_flush_one_kernel 0
7482 records/s
real 120.00 s
user 86.69 s
sys  3746.57 s
nr_tlb_remote_flush 912896
nr_tlb_remote_flush_received 28261974
nr_tlb_local_flush_all 926272
nr_tlb_local_flush_one 0
nr_tlb_local_flush_one_kernel 0

