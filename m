Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab3BSKoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:44:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3BSKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:44:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2 0/5] Generic PHY Framework
Date: Tue, 19 Feb 2013 10:44:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: rob@landley.net, tony@atomide.com, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org, balbi@ti.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        mchehab@redhat.com, cesarb@cesarb.net, davem@davemloft.net,
        santosh.shilimkar@ti.com, broonie@opensource.wolfsonmicro.com,
        swarren@nvidia.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <1361253198-7401-1-git-send-email-kishon@ti.com>
In-Reply-To: <1361253198-7401-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302191044.28653.arnd@arndb.de>
X-Provags-ID: V02:K0:S/hgvDCK5t8K7HVDVArrXk2U5pQGfL2oGlZdlx3JDyo
 FfpzESmBlm46uNODBr15wWjSZ2nU2L/ke1qsdCBTOXXLwjQMSo
 2yNWcwPEaR/cDF289waR21vkCtkGIpTAs6wa+0ZCcdW1DY0GEA
 osEBhGBVzXU/RXU1GaAkAs7mIHaeZOouOEwDvIEbkUh1jvxL9Q
 t4zFiuQ29SH0ADYA9Uycqlnk6qjquHDl01QiiA7p/xanViDW2B
 T49dl35iof0C22CPlUK4PdUArGA2DSAsTmFXFtH0up1JNWkp37
 xYAxzC9gQix6TqPP4NfDjF7ilregMQZUCPsVFkCW/AoDDsEiC0
 IaDxv/J/TNWtTGm9nyBQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013, Kishon Vijay Abraham I wrote:
> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> the PHY with or without using phandle. To obtain a reference to the PHY
> without using phandle, the platform specfic intialization code (say from board
> file) should have already called phy_bind with the binding information. The
> binding information consists of phy's device name, phy user device name and an
> index. The index is used when the same phy user binds to mulitple phys.
> 
> This framework will be of use only to devices that uses external PHY (PHY
> functionality is not embedded within the controller).
> 
> The intention of creating this framework is to bring the phy drivers spread
> all over the Linux kernel to drivers/phy to increase code re-use and to
> increase code maintainability.
> 
> Comments to make PHY as bus wasn't done because PHY devices can be part of
> other bus and making a same device attached to multiple bus leads to bad
> design.

How does this relate to the generic PHY interfaces in drivers/net/phy?

Do you expect that to get merged into drivers/phy in the long run, or
do you want to keep the generic phy only for everything but ethernet?

I think it would be problematic to have two alternative interfaces for
ethernet PHYs because then an ethernet driver still needs to decide
which subsystem to interface with.

	Arnd
