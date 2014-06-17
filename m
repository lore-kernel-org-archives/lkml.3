Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaFQLYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:24:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45026 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFQLX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:23:59 -0400
Date: Tue, 17 Jun 2014 12:23:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140617112353.GB4139@lee--X1>
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org>
 <1400766819-22286-2-git-send-email-lee.jones@linaro.org>
 <5396E561.4020805@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5396E561.4020805@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> > devices. It has 2 ports which it can use for either; both SATA, both
> > PCIe or one of each in any configuration.
> 
> I've asked others who wrote multi-phy PHY providers to model each individual
> PHY as sub-node of the PHY provider. So It's only fair I ask you the same to
> do. So in this case the dt node should look something like:
> 
> 	miphy365x_phy: miphy365x@fe382000 {
> 		compatible = "st,miphy365x-phy";
> 		#phy-cells = <2>;
> 		st,syscfg = <&syscfg_rear>;
> 		channel@0 {
> 			reg =	<0xfe382000 0x100>, <0xfe394000 0x100>;
> 			reg-names = "sata", "pcie";
> 		}
> 
> 		channel@1{
> 			reg =	<0xfe38a000 0x100>, <0xfe804000 0x100>;
> 			reg-names = "sata", "pcie";
> 		}
> 
> 	};

I'm interested to know why you've taken this approach, as it makes the
code much more complex.  The DT framework goes to the trouble of
converting all addresses to to resources so drivers can easily pull
them out using platform_get_resource() and friends.  Pushing the reg
properties down into a child node means that we have to now iterate
over the sub-nodes and pull them out manually.  This will lead to a
pretty messy implementation IMHO.

Can you point me in the direction of previous implementations where you
have stipulated the same set of constraints please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
