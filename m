Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaGUTdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 15:33:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34658 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaGUTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 15:33:50 -0400
Message-ID: <53CD6B1C.2010801@codeaurora.org>
Date: Mon, 21 Jul 2014 12:33:48 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 3/5] common: dma-mapping: Introduce common remapping
 functions
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org> <1404324218-4743-4-git-send-email-lauraa@codeaurora.org> <20140718135349.GB4608@arm.com>
In-Reply-To: <20140718135349.GB4608@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/2014 6:53 AM, Catalin Marinas wrote:
> On Wed, Jul 02, 2014 at 07:03:36PM +0100, Laura Abbott wrote:
>> +void *dma_common_pages_remap(struct page **pages, size_t size,
>> +			unsigned long vm_flags, pgprot_t prot,
>> +			const void *caller)
>> +{
>> +	struct vm_struct *area;
>> +
>> +	area = get_vm_area_caller(size, vm_flags, caller);
>> +	if (!area)
>> +		return NULL;
>> +
>> +	if (map_vm_area(area, prot, &pages)) {
>> +		vunmap(area->addr);
>> +		return NULL;
>> +	}
>> +
>> +	return area->addr;
>> +}
> 
> Why not just replace this function with vmap()? It is nearly identical.
> 

With this version, the caller stored and printed via /proc/vmallocinfo
is the actual caller of the DMA API whereas if we just call vmap we
don't get any useful caller information. Going to vmap would change
the existing behavior on ARM so it seems unwise to switch. Another
option is to move this into vmalloc.c and add vmap_caller.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
