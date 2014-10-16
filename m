Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJPJ7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:59:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36920 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751001AbaJPJ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:59:49 -0400
Date: Thu, 16 Oct 2014 11:59:46 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ARM: berlin: Add AHCI and SATA PHY nodes to BG2
Message-ID: <20141016095946.GB1061@kwain>
References: <1413042073-14253-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1413042073-14253-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413042073-14253-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Sat, Oct 11, 2014 at 05:41:12PM +0200, Sebastian Hesselbarth wrote:
>  
> +		ahci: sata@e90000 {
> +			compatible = "marvell,berlin2-ahci", "generic-ahci";
> +			reg = <0xe90000 0x1000>;
> +			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&chip CLKID_SATA>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			status = "disabled";

The ahci generic driver actually returns -ENODEV if no port is
activated. There is no need to disable it from there.

> +
> +			sata0: sata-port@0 {
> +				reg = <0>;
> +				phys = <&sata_phy 0>;
> +				status = "disabled";
> +			};
> +
> +			sata1: sata-port@1 {
> +				reg = <1>;
> +				phys = <&sata_phy 1>;
> +				status = "disabled";
> +			};
> +		};

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
