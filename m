Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaCUX13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:27:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53258 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaCUX10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:27:26 -0400
Subject: Re: [PATCH] ARM: Use 64-bit DMA addresses for LPAE+VirtIO-MMIO
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <532C96B9.4090805@codeaurora.org>
Date: Fri, 21 Mar 2014 23:27:24 +0000
Cc: Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <90DB5198-051A-48EC-B577-5342BD706713@arm.com>
References: <1395250522-30031-1-git-send-email-cov@codeaurora.org> <20140321162750.GI13596@arm.com> <532C96B9.4090805@codeaurora.org>
To: Christopher Covington <cov@codeaurora.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Mar 2014, at 19:44, Christopher Covington <cov@codeaurora.org> wrote:
> On 03/21/2014 12:27 PM, Catalin Marinas wrote:
>> On Wed, Mar 19, 2014 at 05:35:19PM +0000, Christopher Covington wrote:
>>> On an LPAE system, the physical addresses used by VirtIO-MMIO may
>>> be larger than 32 bits, even if the header and configuration space
>>> addresses fit into 32 bits. For example with the Versatile Express
>>> memory map using 4G memory, the following error occured when trying
>>> to use a VirtIO-MMIO block device.
>>> 
>>> EXT2-fs (vda): error: ext2_check_page: bad entry in directory #2: :
>>> unaligned directory entry - offset=0, inode=3755990991, rec_len=57311,
>>> name_len=223
>>> 
>>> To fix this, select ARCH_DMA_ADDR_T_64BIT when both LPAE and
>>> VIRTIO_MMIO are selected.
>>> 
>>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>>> ---
>>> arch/arm/mm/Kconfig | 1 +
>>> 1 file changed, 1 insertion(+)
>>> 
>>> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
>>> index 1f8fed9..a62bcc9 100644
>>> --- a/arch/arm/mm/Kconfig
>>> +++ b/arch/arm/mm/Kconfig
>>> @@ -617,6 +617,7 @@ config ARM_LPAE
>>> 	bool "Support for the Large Physical Address Extension"
>>> 	depends on MMU && CPU_32v7 && !CPU_32v6 && !CPU_32v5 && \
>>> 		!CPU_32v4 && !CPU_32v3
>>> +	select ARCH_DMA_ADDR_T_64BIT if VIRTIO_MMIO
>> 
>> That's the wrong place to enable ARCH_DMA_ADDR_T_64BIT. Do you have a
>> platform with >32-bit physical address space? If yes, it should be
>> selected there.
> 
> The platforms I'm currently using are models like the Versatile Express
> RTSM/FVP. I can respin with changes to ARCH_VEXPRESS and ARCH_VIRT instead.

But do you use RAM beyond 32-bit on such models?

Catalin
