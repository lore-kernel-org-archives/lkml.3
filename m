Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaCEJNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:13:46 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:38904 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaCEJNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:13:43 -0500
Date: Wed, 5 Mar 2014 10:12:29 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] pinctrl: mvebu: prepare for single PMU node
Message-ID: <20140305091229.GA26485@lunn.ch>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:03:07AM +0100, Sebastian Hesselbarth wrote:
> This is a small patch set preparing a discussion and rework for the
> Power Management Unit (PMU) found on Marvell Dove SoCs. We are planing
> to consolidate PMU into a single DT node instead of chopping it into
> tiny pieces [1].
> 
> As we just have taken in patches for pinctrl driver that grab another
> piece of PMU reg space, we rather drop the corresponding reg property
> and wait for v3.15 and proper PMU node rework.
> 
> Patch 1 drops the reg property added for pinctrl and is based on mvebu/dt.
> 
> Patch 2 drops the reg property added for pinctrl from the corresponding
> binding documentation and example. It is based on recently pulled
> mvebu/pinctrl-dove.
> 
> Patch 3 reduces a WARN on missing reg properties to dev_warn with FW_BUG,
> as we just enforced this situation. The driver will continue to work
> properly without the resource and derive it from other resources. As soon
> as PMU binding is worked out, we will update the driver to make use of it.
> 
> The last patch is optional and Linus Walleij can reject it, if he is already
> done for v3.15.

Hi Sebastian

Whole set of three:

Acked-by: Andrew Lunn <andrew@lunn.ch>

  Thanks
      Andrew
> 
> [1] https://lkml.org/lkml/2014/3/3/326
> 
> Sebastian Hesselbarth (3):
>   ARM: dove: drop pinctrl PMU reg property
>   devicetree: bindings: drop pinctrl PMU reg property
>   pinctrl: mvebu: silence WARN to dev_warn
> 
>  Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt  | 2 +-
>  Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt | 2 +-
>  arch/arm/boot/dts/dove.dtsi                                         | 3 +--
>  drivers/pinctrl/mvebu/pinctrl-dove.c                                | 3 ++-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> ---
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> -- 
> 1.8.5.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
