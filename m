Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaFJLBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:01:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37514 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaFJLB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:01:29 -0400
Message-ID: <5396E561.4020805@ti.com>
Date: Tue, 10 Jun 2014 16:30:49 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org> <1400766819-22286-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1400766819-22286-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 22 May 2014 07:23 PM, Lee Jones wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.

I've asked others who wrote multi-phy PHY providers to model each individual
PHY as sub-node of the PHY provider. So It's only fair I ask you the same to
do. So in this case the dt node should look something like:

	miphy365x_phy: miphy365x@fe382000 {
		compatible = "st,miphy365x-phy";
		#phy-cells = <2>;
		st,syscfg = <&syscfg_rear>;
		channel@0 {
			reg =	<0xfe382000 0x100>, <0xfe394000 0x100>;
			reg-names = "sata", "pcie";
		}

		channel@1{
			reg =	<0xfe38a000 0x100>, <0xfe804000 0x100>;
			reg-names = "sata", "pcie";
		}

	};

Thanks
Kishon
