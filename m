Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaHRO2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:28:53 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44057 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788AbaHRO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:28:51 -0400
Date: Mon, 18 Aug 2014 15:26:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9] arm64: Add architectural support for PCIe
Message-ID: <20140818142648.GQ20043@localhost>
References: <1407860760-25252-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860760-25252-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407860760-25252-2-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 05:26:00PM +0100, Liviu Dudau wrote:
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index e0ecdcf..dc34039 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -121,7 +121,8 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
>  /*
>   *  I/O port access primitives.
>   */
> -#define IO_SPACE_LIMIT		0xffff
> +#define arch_has_dev_port()	(1)
> +#define IO_SPACE_LIMIT		0x1ffffff

Minor thing, (SZ_32M - 1) may be easier in case we ever change this.

>  #define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_32M))

-- 
Catalin
