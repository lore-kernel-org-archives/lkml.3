Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaATRjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:39:12 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17022 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750758AbaATRjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:39:10 -0500
Date: Mon, 20 Jan 2014 17:38:38 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] arm64: advertise availability of CRC and crypto
 instructions
Message-ID: <20140120173838.GD29971@arm.com>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 02:06:27PM +0000, Ard Biesheuvel wrote:
> This series is a followup to the patch that was recently merged by Catalin that
> allocates hwcaps bits for CRC and Crypto Extensions instructions so userland can
> discover whether the current CPU has any of those capabilities.
> 
> Patch #1 enables ARM support for the ELF_HWCAP2/AT_HWCAP2 ELF auxv entry that
> was recently added to the kernel and glibc (2.18). It extends the feature bit
> space to 64 bits (on 32-bit architectures)
> 
> Patch #2 adds generic support for ELF_HWCAP2/AT_HWCAP2 to the 32-bit ELF compat
> mode for 64-bit architectures.
> 
> Patch #3 adds support for ELF_HWCAP2/AT_HWCAP2 to arm64's 32-bit ELF compat mode
> 
> Patch #4 allocates the HWCAP2 bits in the arch/arm tree. This is necessary
> because 32-bit ARM binaries can execute both under ARM and under arm64 kernels,
> so there should be agreement about the meaning of feature bits, even if the ARM
> kernel has no support yet for ARMv8 32-bit only hardware (such as ARMv8-R).

It looks a bit strange to start filling HWCAP2 before HWCAP is full but
I guess we want to preserve some future extensions in HWCAP for older
glibc.

-- 
Catalin
