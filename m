Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaGKQYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:24:48 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23352 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754549AbaGKQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:24:47 -0400
Date: Fri, 11 Jul 2014 17:24:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <Will.Deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: Use include/asm-generic/io.h
Message-ID: <20140711162422.GF16321@arm.com>
References: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com>
 <1405092672-18549-2-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405092672-18549-2-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 04:31:11PM +0100, Thierry Reding wrote:
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index a78562f21aab..ef54f5c8a7ae 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
[...]
> -#define iowrite16be(v,p) ({ __iowmb(); __raw_writew((__force __u16)cpu_to_be16(v), p); })
> -#define iowrite32be(v,p) ({ __iowmb(); __raw_writel((__force __u32)cpu_to_be32(v), p); })

Aren't you losing the barrier semantics here? The generic iowrite*be()
functions call __raw_write*() directly which don't have a barrier
(write* accessors do).

-- 
Catalin
