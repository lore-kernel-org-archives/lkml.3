Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaK1PNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:13:21 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:60350 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaK1PNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:13:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: suravee.suthikulpanit@amd.com
Subject: Re: [PATCH V5] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Fri, 28 Nov 2014 16:13:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: olof@lixom.net, mark.rutland@arm.com, will.deacon@arm.com,
        marc.zyngier@arm.com, catalin.marinas@arm.com, robherring2@gmail.com,
        liviu.dudau@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
References: <1416977469-20232-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1416977469-20232-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411281613.11626.arnd@arndb.de>
X-Provags-ID: V02:K0:QZYqtIUh5wU/um6T3aMjX+eJESDQtvL2ZCSNkLPaqtU
 3Wx106bEVsJu2UXNhbFI8ZAQXI2lfEIekT2aDDxo7QCXhrxHqJ
 BDHiqta6obIrAXa7NZLPcn0ApT9526yHJKC1yqUuBq6p2kdEck
 Z/fgGqQTqOkrq1gqdtXPa/eYHZs7i2BSl/IqVQJbt5Z/n+MWZq
 QKZ0xFXNQbsAsvVf4SSQaCX1tkw+hlIbLBCkk7jfgzMM1ZqEbE
 0buoccYdfU2I3xGnT0DOL+cZQ7q1Xv0nUvR5euyq6d0GwkOBeM
 aKp58kjCS6hs+0oaHThbBBn/r0YbJhByPs5+4MM2xCK4T5iKnO
 wpwRYtJP+kY1w+ug/Vu3oKmig0qs/isyOU6jNCYlw
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Initial revision of device tree for AMD Seattle Development platform.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
> ---
> V5 Changes:
>   * Rebase to arm-soc for-next (per Olof)
>   * Restructure the DTS/DTSI into board and SoC configurations (per Olof)
>   * Add model property at the top level (per Olof)
>   * Move pcie0 under smb and change smb's ranges property to empty since pcie
>     is not in the same range. (per Olof)
>   * Change v2m0's ranges property (per Arnd)
>   * Change timer interrupt type to level-trigger (per Marc)

Applied to next/arm64, thanks!

Looking at this one more time, I had another question:

> +	smb0: smb {
> +		compatible = "simple-bus";
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges;
> +
> +		/* DDR range is 40-bit addressing */
> +		dma-ranges = <0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
> +

What is a DDR range?

Also, what is special about the last byte? Did you intentionally
leave it out? I think when we calculate the dma mask, we will
use 0x3fffffffff so we don't step on the last byte, which I assume
is not what you intended.

	Arnd
