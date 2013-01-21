Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3AUVuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:50:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3AUVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:50:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Date: Mon, 21 Jan 2013 21:49:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
References: <Pine.LNX.4.44L0.1301211533580.24224-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301211533580.24224-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212149.15139.arnd@arndb.de>
X-Provags-ID: V02:K0:Fp4xo0/MBIqLFD1q8bm9x6HzEeJ1E045eC7rjCqPlu3
 d+6XILYZypa3Wo9zjgHFyj6xGYL/abjgqcpi72SFyKO/HJXmpT
 yAA0ENPkpUyI/o+M+/QsvP3payzKekG8iQZweM8OyQKqvH4LPa
 Qn3Y/TotYFd15WprxZ9PuV0mY+vCkdNgmhcFCuY6b3RNQEw9hw
 S5GWlhKKesP+A88rzlCsU+fd5bxU1Yl0SdXdxI4SExN5TwJCzR
 miyPsC7xVYx/8skQhYRD9hhMx3HtzP3NGYjNv1Vn3DefBdV/p1
 lnXq9hwZ77bQ6zEnVEkBw6kBndzsS015JnxGf6RxB+7auqIP4u
 BRBCg3rhmnsdI3v94QYM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Alan Stern wrote:
> Is Manjunath aware of the first patch attached to this email message?
> 
>         http://marc.info/?l=linux-usb&amp;m=135843902916416&amp;w=2
> 

I would not expect so. Manjunath is still learning about the open
source processes, but he has also done a similar patch in his tree,
and one for most of the other ARM based platforms.

Manjunath: following up on the discussions we've had, I would suggest
you take a look at that patch, and do a comparison with your version
(apply it on the same base, then use git-diff to show the differences
between the version) and thing about whether your they are significant
or not.  Since Alan posted his version on the mailing list first, that's
the one that should get merged, but there might be something in it that
you can learn from it and that I did not see.

Alan, one comment about your version: You keep maintaining the
'#if IS_ENABLED' list in the main driver, which I think can actually
get removed now. Since the base driver can be built independent of
the presence of platform glue drivers, there is no need to forbid
it any more, and the #if block will cause merge conflicts for each
patch that converts or adds another platform. I think we can actually
get the same results by turning the Kconfig logic around and making
the platform glue drivers 'select USB_EHCI_HCD' than depending on
it.

	Arnd
