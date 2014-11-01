Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaKAWrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:47:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12323 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753122AbaKAWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:47:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18IsDPazYVsZ+ti7SY87ZgXfclfnUU3JsQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan C06B260EF52
Date: Sat, 1 Nov 2014 18:46:47 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Add support for USB cluster(PHY muxer) on the
 Armada 375
Message-ID: <20141101224647.GD3698@titan.lakedaemon.net>
References: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory,

On Fri, Oct 24, 2014 at 05:24:08PM +0200, Gregory CLEMENT wrote:
> Hello,
> 
> this is the second version of a series I initially submitted in May:
> https://lkml.org/lkml/2014/5/16/743
> 
> This series adds support for the USB cluster which is on the Armada
> 375 SoC. We can mainly see this device as a PHY muxer.
> 
> I more or less forgotten this series until the talk of Kishon Vijay
> Abraham I about the phy framework.
> 
> Since this time, things have changed in the USB framework and I no
> longer have to add the generic phy support in the xhci driver since it
> was done at the usb core level.
> 
> While I ran coccicheck on my code I also found some possible
> improvement in the phy driver: it was done in the 1st patch.
> 
> The second patch was a patch initially submitted by Andrew. This patch
> added the mvebu-phy.txt but fell through a crack when adding the
> driver. I join this patch on my series in order to be able to add the
> new binding for the USB cluster of the Armada 375.
> 
> This was done in the third patch.
> 
> The forth patch was the addition of the phys driver itself.
> 
> The fifth and sixth patches are updating the device tree files related
> to the Armada 375 using the new biding.
> 
> Thanks,
> 
> Gregory
> 
> Changelog:
> 
> v1 -> v2:
> 
> - Add a patch fixing the use of PTR_ERR_OR_ZERO.
> 
> - Add the patch adding the DT binding documentation for Marvell MVEBU
> SATA phy from Andrew Lunn
> 
> - Move the DT binding documentation of the Armada 375 USB cluster into
>   the phy-mvebu.txt file.
> 
> - Made the armada375_usb_phy_xlate more robust" if there is a phy_put
>   and then a phy_get".
> 
> Andrew Lunn (1):
>   Phy: DT binding documentation for Marvell MVEBU SATA phy.
> 
> Gregory CLEMENT (5):
>   phy: Use PTR_ERR_OR_ZERO to fix warning raised by coccinelle
>   Phy: DT binding documentation for the Armada 375 USB cluster binding
>   phy: add support for USB cluster on the Armada 375 SoC
>   ARM: mvebu: add Device Tree description of USB cluster controller on
>     Armada 375
>   ARM: mvebu: add PHY support to the dts for the USB controllers on
>     Armada 375

I assume Kishon is taking the phy portion of this series and we'll
handle the dts portion?  Before doing so, I'd like to see an Ack from
the DT maintainers and Kishon...

thx,

Jason.

