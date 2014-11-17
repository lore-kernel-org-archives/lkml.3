Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaKQMS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:18:56 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:51146 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKQMSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:18:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
Date: Mon, 17 Nov 2014 13:18:42 +0100
Message-ID: <1650523.IrjSXzxF5O@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5469E26B.2010905@huawei.com>
References: <5469E26B.2010905@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oLJabbziXdh9ZKCaPMlYeJfAzZ+vzrpaixSRNuLR12S
 Zs42isHc0XyybfJO2E9658bSL8fmYqXYbvL66+m8+Mxcpt5qpf
 UCdArU1zExiJUFCAJJyqQr9Qvj9pTpqvJLTkigc7386kuiJued
 Z41kV6C57s2jG+rR6hBVIZBCJc1TVPDgNbRgfp2NNP1fqwsP2p
 1rWD512HTBgE1tUhzpuYoRcx+pPgt/8ztMfbox/SQN5ZTJQwJq
 WPcJP0HJGYIWT9Z32c1yXLMBdZFNCaMlpbyMw5R0E0zNfD9I3L
 L/J3ZsRaaTtIbvV9jYCsOpQVuXuy1SienmXosvQu3RS4gTS3im
 hC8hX5zBc6P79dPft0UE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 19:56:27 Ding Tianhong wrote:
> Hi Catalin:
>         The commit 3690951fc6d42f3a0903987677d0e592c49dd8db(arm64: Use swiotlb late initialisation)
> switches the DMA mapping code to swiotlb_tlb_late_init_with_default_size(), this will occur a problem
> when I run the scsi stress tests, the message as below:
> 
>         sas_controller b1000000.sas: swiotlb buffer is full (sz: 65536 bytes)..
>         DMA: Out of SW-IOMMU space for 65536 bytes at device b1000000.sas
> 
> The reason is that the swiotlb_tlb_late_init_with_default_size() could only alloc 16M memory for DMA-mapping,
> and the param in cmdline "swiotlb=xxx" is useless because the get_free_pages() only use the buddy to assigned a
> maximum memory of 16M(The MAX_ORDER is 13 for 4k pages), obviously 16M is too small in many scenes, but
> the swiotlb_init() which could reserved a bigger memory as wished could work well for most drivers.
> 
> I could not get a better way to fix this problem except to revert this patch, so could you please give me some
> advise and help me, thanks very much.

In general, you should not need to use swiotlb for most devices, in
particular for high-performance devices like network or block.

Please make sure that you have set up the dma-ranges properties in
your DT properly to allow 64-bit DMA if the device supports it.

	Arnd
