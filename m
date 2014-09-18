Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbaIRWqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:46:36 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33843 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757396AbaIRWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:46:35 -0400
Date: Thu, 18 Sep 2014 23:46:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp
	implementations
Message-ID: <20140918224625.GF5182@n2100.arm.linux.org.uk>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org> <1411076592-6157-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411076592-6157-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:43:11PM -0700, Stephen Boyd wrote:
> diff --git a/arch/arm/include/asm/vfp.h b/arch/arm/include/asm/vfp.h
> index f4ab34fd4f72..76d3f6907cce 100644
> --- a/arch/arm/include/asm/vfp.h
> +++ b/arch/arm/include/asm/vfp.h
> @@ -21,7 +21,7 @@
>  #define FPSID_FORMAT_MASK	(0x3  << FPSID_FORMAT_BIT)
>  #define FPSID_NODOUBLE		(1<<20)
>  #define FPSID_ARCH_BIT		(16)
> -#define FPSID_ARCH_MASK		(0xF  << FPSID_ARCH_BIT)
> +#define FPSID_ARCH_MASK		(0x7F  << FPSID_ARCH_BIT)

This is incorrect.  On VFPv2, the architecture field is four bits long.
As you can see from the above, bit 20 indicates that there are no
double operations provided, and the next two bits indicate the FSTMX/
FLDMX format.

I know that you're changing this to conform with the ARM ARM, but we
have to consider that before VFP was subsumed into the ARM ARM, this
register had the format described as per this file, and these other
bits may be set for an ARM part.  Including these bits in the mask
means that we will mis-identify these older parts as VFPv3.

Welcome to the lack of standardisation!

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
