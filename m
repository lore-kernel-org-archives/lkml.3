Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaIWQaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:30:21 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:63948 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbaIWQaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:30:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 23 Sep 2014 18:29:48 +0200
Message-ID: <9401592.hUYDkriFVO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <542195B0.6080706@gmail.com>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com> <4014272.rJbSfrLcuB@wuerfel> <542195B0.6080706@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:a7SF0cdT94VlJseGrCSqJEPPvwrh85vX9PMn4QSzvKa
 GacfdSyx4O8B2hKGXJx/4wMI7JuQHjQ+0zSPX90JwLjoYCy4ae
 0MJUOieGNAEiw+ljFAJVZSL9+mn6pFmxKEyPwRneXo8OS3GqW9
 dvCvNXrYXJWP66guiOKRP8SY4qDrlAQMy/ZF+kje2W4cwtpsIg
 e034UBtLH6mSFthP8cT7izu3WxzPJkFUCyt/iB0/eJLuX33kjo
 23p4qx/pvnBjeJ2icXjN7Q94Zeypl5lCNVImjFx5CptXohNvQX
 WXXynrlk7kQVZkyhUj2D2lkpSJGsqmvcnKQgF7CUky/lkJsZpu
 CONcJgQrNYVJEtxrz7rk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 17:45:52 Sebastian Hesselbarth wrote:
> For reference, this is what we have for MVEBU SoCs with multiple ports
> per controller:
> 
> eth: ethernet-ctrl@72000 {
>         compatible = "marvell,orion-eth";
>         #address-cells = <1>;
>         #size-cells = <0>;
>         reg = <0x72000 0x4000>;
>         clocks = <&gate_clk 2>;
>         marvell,tx-checksum-limit = <1600>;
>         status = "disabled";
> 
>         ethernet-port@0 {
>                 compatible = "marvell,orion-eth-port";
>                 reg = <0>;
>                 interrupts = <29>;
>                 /* overwrite MAC address in bootloader */
>                 local-mac-address = [00 00 00 00 00 00];
>                 phy-handle = <&ethphy>;
>         };
> };
> 
> mdio: mdio-bus@72004 {
>         compatible = "marvell,orion-mdio";
>         #address-cells = <1>;
>         #size-cells = <0>;
>         reg = <0x72004 0x84>;
>         interrupts = <30>;
>         clocks = <&gate_clk 2>;
>         status = "disabled";
>         ethphy: ethernet-phy {
>                 /* set phy address in board file */
>         };
> };
> 

But in this example, you have the same registers and the same
clocks in two nodes, which are even used by the same device driver
at the moment. It's not a big issue, but my feeling is that Antoine's
approach was actually better because it more closely reflects
the way that the hardware is built.

	Arnd
