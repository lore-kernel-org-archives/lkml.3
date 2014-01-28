Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaA1V03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:26:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaA1V02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:26:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: Query: Phy: How to find consumer device on dt platform
Date: Tue, 28 Jan 2014 22:26:24 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        linux-kernel@vger.kernel.org
References: <20140128141356.GC3519@pratyush-vbox> <52E7BE91.8030209@ti.com>
In-Reply-To: <52E7BE91.8030209@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401282226.24197.arnd@arndb.de>
X-Provags-ID: V02:K0:RB97wwnFsyS+shI19SwYxgyIDOrcwonbxURy32ovMhp
 yXLoBKmFkVy1AtS39J/h57dDEBMKNwheGniLDGDYTZjAYFAj4y
 w2VqD/ZIhyAoO1ymYByboxoKUAyneRxT/oT4Asv98vSGCys54D
 1MzX/21xeCmSvRAen6ZVKBhq3OvusU2w2jcoRRCnluz7SxQogz
 6V5HFbeSy71h2w/7VO66PZ5SxkLmkyKyxb8SSnkF+HNSSpItCb
 5gYv1897mzDtNlO0NYHIv+dUQQj4Y8NdC7dNvrGBUo022rQ3rn
 jyX/Q4r45DxU+zBNagbCp217idhNbyplqZ+7Kxsxy0yEiLRucX
 2d/je4um4eE+AlfCX3kw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 January 2014, Kishon Vijay Abraham I wrote:
> > I have a common set of registers, which need to be programmed
> > differently for PCIe and SATA during phy init/exit.
> 
> One way is differentiate using different compatible strings fro pcie and sata
> and use of_device_is_compatible to select a particular path.

But if the IP block is the same, the compatible string should be
identical.

> > Therefore, in the init/exit routine of phy_ops, I need some way of
> > identifying that phy_init/exit has been called from PCIe driver or
> > SATA driver.
> 
> In this case you'll be actually registering two different PHYs (each for pcie
> and sata), so your phy_get should give you the only the appropriate phy.

I would instead recommend making the mode of the PHY device the
argument to the phy handle in DT, so that the sata node uses

	phys = <&phyA 0>;

and the PCIe node uses

	phys = <&phyB 1>;

Then the binding for the phy defines that an argument of '0' means sata mode,
while '1' means pcie mode, plus you should define all other valid modes.

	Arnd
