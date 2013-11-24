Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3KXDqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:46:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53387 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab3KXDqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:46:03 -0500
Message-ID: <52917661.6050005@ti.com>
Date: Sat, 23 Nov 2013 22:45:37 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] CMA: Fix the phys_addr_t print types
References: <1385264221-29952-1-git-send-email-santosh.shilimkar@ti.com> <20131124034426.GB3873@kroah.com>
In-Reply-To: <20131124034426.GB3873@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 November 2013 10:44 PM, Greg Kroah-Hartman wrote:
> On Sat, Nov 23, 2013 at 10:37:01PM -0500, Santosh Shilimkar wrote:
>> @@ -250,8 +249,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>>  	*res_cma = cma;
>>  	cma_area_count++;
>>  
>> -	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
>> -		(unsigned long)base);
>> +	pr_info("CMA: reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
>> +		&base);
> 
> Why is this pr_info() at all?  That's just noise, please move it to
> pr_debug().
> 
Marek can comment better but I think its useful print to know CMA
reserved memory size.

regards,
Santosh

