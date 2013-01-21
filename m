Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3AUUPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:15:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3AUUPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:15:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Date: Mon, 21 Jan 2013 20:14:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-14-git-send-email-arnd@arndb.de> <20130121184237.GC10106@arwen.pp.htv.fi>
In-Reply-To: <20130121184237.GC10106@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212014.20678.arnd@arndb.de>
X-Provags-ID: V02:K0:TkcA9kDtCC13l2oFwg+8abj+mnxElsQyXDeV2CcrkOx
 ry1fAOlHUJleCX+G4rxCEDV+Yl7f6ZW2fhl+MTf8NGoOKQHCK3
 YKYqXBuU8QBnlo3+lAl6TQxFOuFXiAfQJrffIEOOKVcsVaeQ7G
 dN9KGuZs46BVl+o8isIlgZlKsC+BoacJD46NKDKP3jD4nNB7cy
 brAZLlDmAsv7IxxoxNkq8trY380j2vTcFVlsRcsb/jE0uQ6pPG
 cSFodqfQ5sLTe7K694usY3PjuF0zlTcKMCEn407LUIx1N6vmyD
 3ivIAMOSsWKgpNAFjPxJ/2U29LJo2REQzQxi0nOafFrRFc2O+V
 LTj3v5jWJMfWmD9Wv8J8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Felipe Balbi wrote:
> On Mon, Jan 21, 2013 at 05:16:06PM +0000, Arnd Bergmann wrote:
> > Manjunath Goudar is already working on a patch to convert
> > both the imx and the mvebu glue drivers (along with all
> > the other ARM specific ones) to the new probing method,
> > but that will be too late to fix v3.8. This patch instead
> > adds yet another hack like the existing ones to allow
> > the ehci driver to load both back-ends.
> 
> NAK, should be converted to the new usage of ehci library driver. Alan
> Stern already implemented for a few drivers, help is very welcome.

As I explained above, Manjunath already has a patch [1] for that, but I
think it's too late to include that in v3.8 given the regression
potential and size of the patch. Once he submits that patch for 3.9,
my change would get taken out anyway, but it lets us build important
configurations (including allyesconfig build tests) on 3.8.

	Arnd

[1] http://git.linaro.org/gitweb?p=people/manjunathgoudar/usb-refactoring.git;a=commitdiff;h=d9f28dba727212d022605c955796a3a83b3978ae
