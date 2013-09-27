Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3I0QGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:06:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50112 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3I0QGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:06:36 -0400
Subject: Re: [PATCHv2 2/9] hwspinlock/omap: add support for dt nodes
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <0fd6a11880894260d627a50b1e35f363625e9b1d.1379445653.git.s-anna@ti.com>
Date: Fri, 27 Sep 2013 11:06:38 -0500
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <AE597DCC-83D7-4BCD-8990-3D63540F32EA@codeaurora.org>
References: <cover.1379445653.git.s-anna@ti.com> <0fd6a11880894260d627a50b1e35f363625e9b1d.1379445653.git.s-anna@ti.com>
To: Suman Anna <s-anna@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 17, 2013, at 2:30 PM, Suman Anna wrote:

> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
> which are all device-tree boot only. This patch adds the
> base support for parsing the DT nodes, and removes the code
> dealing with the traditional platform device instantiation.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
> .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 31 +++++++++++
> arch/arm/mach-omap2/Makefile                       |  3 --
> arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
> drivers/hwspinlock/omap_hwspinlock.c               | 23 +++++++--
> 4 files changed, 50 insertions(+), 67 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
> 
> diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> new file mode 100644
> index 0000000..235b7c5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> @@ -0,0 +1,31 @@
> +OMAP4+ HwSpinlock Driver
> +========================
> +
> +Required properties:
> +- compatible:		Currently supports only "ti,omap4-hwspinlock" for
> +				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
> +- reg:			Contains the hwspinlock register address range (base
> +			address and length)
> +- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
> +
> +Common hwlock properties:
> +The following describes the usage of the common hwlock properties (defined in
> +Documentation/devicetree/bindings/hwlock/hwlock.txt) on OMAP.
> +
> +- hwlock-base-id:	There are currently no OMAP SoCs with multiple
> +			hwspinlock devices. The OMAP driver uses a default
> +			base id value of 0 for the locks present within the
> +			single hwspinlock device on all SoCs.
> +- hwlock-num-locks:	This property is not required on OMAP SoCs, since the
> +			number of locks present within a device can be deduced
> +			from the SPINLOCK_SYSSTATUS device register.

If you are going to be explicit about this properties, you should probably be a bit more clear about them NOT being in the OMAP dts because of the reasons you specify.

> +
> +
> +Example:
> +
> +/* OMAP4 */
> +hwspinlock: spinlock@4a0f6000 {
> +	compatible = "ti,omap4-hwspinlock";
> +	reg = <0x4a0f6000 0x1000>;
> +	ti,hwmods = "spinlock";
> +};

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

