Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbbAWRQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:16:46 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42149 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbAWRQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:16:43 -0500
Date: Fri, 23 Jan 2015 17:16:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "leo.yan@linaro.org" <leo.yan@linaro.org>,
        "yexl@marvell.com" <yexl@marvell.com>,
        Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Hackmann <ghackmann@google.com>
Subject: Re: [PATCHv3 0/3] Handle SETEND for AArch32 tasks
Message-ID: <20150123171628.GG9557@e104818-lin.cambridge.arm.com>
References: <1421844191-9263-1-git-send-email-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421844191-9263-1-git-send-email-suzuki.poulose@arm.com>
Thread-Topic: [PATCHv3 0/3] Handle SETEND for AArch32 tasks
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:43:08PM +0000, Suzuki K. Poulose wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> 
> This series add support for controlling the 'setend' instruction,
> which is deprecated in ARMv8, using the legacy instruction emulation
> framework, introduced by Punit Agrawal.
> 
> Changes since V2:
>  - Move ID_AA64MMFR0_EL1 bit definitions to asm/cputype.h
>  - Use mask/value pair for the features in ID_AA64MMFR0_EL1
>  - Better documentation about the hardware support limitaion under
>    Documentation and the Kconfig help
>  - Restore the original 'set_hw_mode' API, with wrappers to invoke
>    the set_hw_mode for on_each_cpu() variants.
>  - Print a warning when we detect an incompatibility for a registered
>    insn_emulation hook on a hotplugged CPU.
> 
> Changes since V1:
>  - Added a patch to keep track of the mixed endian support and register
>    the setend emulation only if all the active CPUs supports mixed endian.
>  - Fail hotplug operation if the CPU doesn't support a feature
>    required by insn_emulation.
>  - Signal handler runs in native endian

I queued these patches for 3.20 (and included Punit's suggestion as
well). They should appear in linux-next later today.

Cc'ing Greg H @ Google since they are the main users of the emulation
code. If you see any problem, please let us know.

Thanks.

-- 
Catalin
