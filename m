Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3AUVir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:38:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3AUVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:38:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Date: Mon, 21 Jan 2013 21:37:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Felipe Balbi <balbi@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
References: <Pine.LNX.4.44L0.1301211459550.24224-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301211459550.24224-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212137.42611.arnd@arndb.de>
X-Provags-ID: V02:K0:4bHtVMBtei3WYeDsQaOOzxLKai+yearYNiyoWuxKWR2
 9XqHosk5t7sFgvE8t+c1VVmOg9drsfDTcQE3Kopj/7H9dqjPxU
 9zS+3Ehz5WvgSRaiAyCh1GmZOB1j8mDDBMhNhyDjOlp/4aufDw
 x9l6u+vUDo3imQr97oyCn08LQtEHCWG6LwzGbNCETddJeZSEvH
 wHvp4MASvA8s0/jyg38CjzklDdWRd0v4dajRn+KDROM7WHrIsz
 pPbbrY4suRJl9K7nNO4/VcEKPxuViPtIkb0dtrMUR1lxYn3DNa
 HJRUhdSASDghMS3XADB90rLSGoDeAOxzLZ4C03vsKC6Y+LDftw
 1bU2z7jGUAzZ+7RdiNXs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Alan Stern wrote:
> On Mon, 21 Jan 2013, Felipe Balbi wrote:
> 
> > On Mon, Jan 21, 2013 at 05:16:06PM +0000, Arnd Bergmann wrote:
> > > In linux-3.8-rc1 it became possible to build the imx and
> > > mvebu platforms together in a single kernel, which clashes
> > > in the ehci driver.
> > > 
> > > Manjunath Goudar is already working on a patch to convert
> > > both the imx and the mvebu glue drivers (along with all
> > > the other ARM specific ones) to the new probing method,
> > > but that will be too late to fix v3.8. This patch instead
> > > adds yet another hack like the existing ones to allow
> > > the ehci driver to load both back-ends.
> 
> Pardon me for being confused.  Is this about imx and mvebu (as 
> mentioned here) or about orion and mxc (as described in the patch 
> title, the error messages below, and the patch itself)?

mxc is the old name for imx: the platform got removed, but some
of the drivers still carry the old name. Similarly, orion was
used before as the name for the superset of various Marvell platforms,
and mvebu is the superset of that and some of the newer ones.

Sorry for the confusion.

> > > Without this patch, building allyesconfig results in:
> > > 
> > > drivers/usb/host/ehci-hcd.c:1285:0: error: "PLATFORM_DRIVER" redefined
> > > drivers/usb/host/ehci-hcd.c:1255:0: note: this is the location of the previous definition
> > > In file included from drivers/usb/host/ehci-hcd.c:1254:0:
> > > drivers/usb/host/ehci-mxc.c:280:31: warning: 'ehci_mxc_driver' defined but not used
> 
> Was the point here to fix the build error or to allow the two drivers
> to coexist?  The first would be eaiser than the second.

Fixing the build error is probably the more important part here, but
we also really want this to work, since people are migrating towards
multiplatform kernels now, and mvebu/orion and imx/mxc are two of the
more important ones.

> > NAK, should be converted to the new usage of ehci library driver. Alan
> > Stern already implemented for a few drivers, help is very welcome.
> 
> Arnd, please take a look at
> 
>         http://marc.info/?l=linux-usb&amp;m=135843716515529&amp;w=2
> 
> I can't test it easily, not being set up for cross compilation.  I'm 
> waiting to hear from anybody whether it works before submitting it.
> (There's also a report of memory corruption involving a similar patch 
> for ehci-omap; it hasn't been tracked down yet.)

Your patch looks good to me, but it also seems to do some other
changes that are not required to fix the problem but could wait
for 3.9 instead. You definitely have my Ack if you are willing
to take it for 3.8 though.

Shawn or Sascha should be able to test it.

	Arnd
