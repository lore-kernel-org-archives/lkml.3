Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365Ab3ICSu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:50:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34447 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab3ICSu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:50:57 -0400
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1378230767-54931-1-git-send-email-s-anna@ti.com>
Date: Tue, 3 Sep 2013 13:50:53 -0500
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <43798031-2D57-44F0-A19C-FD80DB9E9794@codeaurora.org>
References: <1378230767-54931-1-git-send-email-s-anna@ti.com>
To: Suman Anna <s-anna@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 3, 2013, at 12:52 PM, Suman Anna wrote:

> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
> which are all device-tree boot only. This patch adds the
> base support for parsing the DT nodes, and removes the code
> dealing with the traditional platform device instantiation.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
> .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 28 ++++++++++
> arch/arm/mach-omap2/Makefile                       |  3 --
> arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
> drivers/hwspinlock/omap_hwspinlock.c               | 21 ++++++--
> 4 files changed, 45 insertions(+), 67 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
> 
> diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> new file mode 100644
> index 0000000..adfb8ad
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> @@ -0,0 +1,28 @@
> +OMAP4+ HwSpinlock Driver
> +
> +Required properties:
> +- compatible:		Currently supports only "ti,omap4-hwspinlock" for
> +				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
> +- reg:			Contains the hwspinlock register address range (base
> +			address and length)
> +- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
> +
> +Optional properties:
> +- base_id:		Base Id for the locks for a particular hwspinlock
> +			device. If not mentioned, a default value of 0 is used.
> +			This property is mandatory ONLY if a SoC has several
> +			hwspinlock devices. There are currently no such OMAP
> +			SoCs.

Should this be ti,base_id ? [ I know its kinda generic in its intent for any SoC w/multiple blocks ]

> +
> +			See documentation on struct hwspinlock_pdata in
> +			linux/hwspinlock.h for more details.
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

[ snip ]

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

