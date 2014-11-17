Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaKQL4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:56:42 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:46852 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaKQL4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:56:41 -0500
Message-ID: <5469E26B.2010905@huawei.com>
Date: Mon, 17 Nov 2014 19:56:27 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: For the problem when using swiotlb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin:
	The commit 3690951fc6d42f3a0903987677d0e592c49dd8db(arm64: Use swiotlb late initialisation)
switches the DMA mapping code to swiotlb_tlb_late_init_with_default_size(), this will occur a problem
when I run the scsi stress tests, the message as below:

	sas_controller b1000000.sas: swiotlb buffer is full (sz: 65536 bytes)..
	DMA: Out of SW-IOMMU space for 65536 bytes at device b1000000.sas

The reason is that the swiotlb_tlb_late_init_with_default_size() could only alloc 16M memory for DMA-mapping,
and the param in cmdline "swiotlb=xxx" is useless because the get_free_pages() only use the buddy to assigned a
maximum memory of 16M(The MAX_ORDER is 13 for 4k pages), obviously 16M is too small in many scenes, but
the swiotlb_init() which could reserved a bigger memory as wished could work well for most drivers.

I could not get a better way to fix this problem except to revert this patch, so could you please give me some
advise and help me, thanks very much.

Regards
Ding

