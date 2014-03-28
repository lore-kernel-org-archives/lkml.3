Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaC1Kdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:33:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18441 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaC1Kdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:33:45 -0400
Message-ID: <53354D68.6040800@huawei.com>
Date: Fri, 28 Mar 2014 18:22:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v3 2/4] kmemleak: allow freeing internal objects after
 kmemleak was disabled
References: <5335384A.2000000@huawei.com> <5335387E.2050005@huawei.com> <20140328101315.GB21330@arm.com>
In-Reply-To: <20140328101315.GB21330@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	if (!kmemleak_has_leaks)
>> +		__kmemleak_do_cleanup();
>> +	else
>> +		pr_info("Disable kmemleak without freeing internal objects, "
>> +			"so you may still check information on memory leaks. "
>> +			"You may reclaim memory by writing \"clear\" to "
>> +			"/sys/kernel/debug/kmemleak\n");
> 
> Alternative text:
> 
> 		pr_info("Kmemleak disabled without freeing internal data. "
> 			"Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\"\n");
> 
> (I'm wouldn't bother with long lines in printk strings)
> 
> Otherwise:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 

Thanks for the review!

