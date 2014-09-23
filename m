Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbaIWSSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:18:30 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52930 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbaIWSS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:18:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 23 Sep 2014 20:18:19 +0200
Message-ID: <3847496.NqfTxpsf9X@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5421AE7C.30504@gmail.com>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com> <5150779.ibmzDh88cj@wuerfel> <5421AE7C.30504@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+BpoMsuCXvqM9o1dfme5aH/akyyUKnGZezxnBn+tlEB
 nHGXrI3XZpbLRcvkH6dMAtxGUA68tC4Gai8Cwi7O/EIsEqx5V1
 oody+foenVqFf0mp9yYmvu9KsPR5SBysH0ECJd31ZF0dugImn5
 13G14oFsv4Cs2qwiyL+BrfLR3dw1Fw+e2MwlBllG6/EP7nWnk8
 5Dhcx/DbhXy6MDMJs/Gu8n6t+rWDmAP+AMSCBE4oUga82FzlXz
 4S/oIIHSLDOdOd/wHU5X2DsQ7njypqr6u8NLYNX0+Fb3qJwiAD
 M+83pcFVEyDCJ3n1TyOYB9xESey4cFYKn/veeyZ97HZSqp5idy
 yyEhEMhN/qf1Fxf/jtVg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 19:31:40 Sebastian Hesselbarth wrote:
> It has been a while I looked it up in the pxa168 datasheet, but IIRC
> there is only one port per controller. FWIW, there actually is also
> just one port per controller for Orion SoCs. The multiple ports per
> controller comes from the PPC system controllers, i.e. mv643xx hence
> the name. We just made the binding look like it is more ports available
> to make it backwards compatible.. although I doubt anyone is still using
> mv643xx anywhere.

Ok, I see.

> > If there is only one port and we just have to know which one that is,
> > I don't think we need the child nodes, but if one can have multiple
> > ports operate independently then the driver will need a rework
> > to actually be usable with that configuration.
> 
> I doubt pxa168 needs port nodes at all, i.e. we have the phy-handle
> directly as property of the controller node.

Ah, good.

> The HEC PHY node itself will be a sub-node of some future CEC node,
> while the (internal) MII PHY node can stay as a sub-node of the
> controller, e.g.
> 
> (one final example to make sure we agree on the same)
> 
> eth0: ethernet@f7b90000 {
>         compatible = "marvell,pxa168-eth";
>         reg = <...>;
>         #address-cells = <1>;
>         #size-cells = <0>;
>         phy-handle = <&ethphy0>;
> 
>         ethphy0: ethernet-phy@0 {
>                 reg = <0>;
>         };
> };
> 
> cec0: cec@f7f00baa {
>         compatible = "marvell,berlin-cec";
>         reg = <...>;
>         #address-cells = <1>;
>         #size-cells = <0>;
>         
>         hecphy0: hdmi-ethernet-phy@0 {
>                 reg = <0>;
>         };
> };
> 
> With berlin2cd-google-chromecast.dts overwriting
> 
> &eth0 { phy-handle = <&hecphy0>; };

Ok, now I also understood how the cec fits into this. Yes, I think this
looks very good.

	Arnd
