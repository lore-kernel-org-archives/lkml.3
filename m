Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764698Ab3DDTmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:42:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764578Ab3DDTmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:42:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH 1/5 v3] USB: regroup all depends on USB within an if USB block
Date: Thu, 4 Apr 2013 19:42:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Florian Fainelli <florian@openwrt.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, USB list <linux-usb@vger.kernel.org>
References: <20130404171429.GF5129@arwen.pp.htv.fi> <Pine.LNX.4.44L0.1304041339530.1324-100000@iolanthe.rowland.org> <20130404180229.GA5926@arwen.pp.htv.fi>
In-Reply-To: <20130404180229.GA5926@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304041942.23259.arnd@arndb.de>
X-Provags-ID: V02:K0:Vuf868cdkHuvfssHGcxP63OkElINxi8ylHyVNC9bDzQ
 ABcm/WiBGvCU3G7SAyUWwH1UhErg6XC3nJPn6zw/QtBsihFyzd
 uK3j7skaESiwTws97wCwgcObTBObZbzcbV42PImvPcX5/bJ4f+
 SwtlNWL+URFuRniACpFi6TJrkYwNqfPq3+mByPtKpxmOK5odkg
 Mz+cNzJ03d9FMawf8pLKffsQvQfjXjXIprnRzO2uziCVWxCyH+
 +EgLdqJyO9NexYnrTFfSLPpS2QYnMlYKA4ZUC/BoCVy/d0YNSa
 0KERqyEfVLl59vcU4KEmtddV0o0RTUm6heTyHC040gWMaHiiWM
 5OCRYwf1V5Na4pdq2JdE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 April 2013, Felipe Balbi wrote:
> On Thu, Apr 04, 2013 at 01:42:18PM -0400, Alan Stern wrote:
> > > > diff --git a/drivers/usb/misc/sisusbvga/Kconfig b/drivers/usb/misc/sisusbvga/Kconfig
> > > > index 30ea7ca..0d03a52 100644
> > > > --- a/drivers/usb/misc/sisusbvga/Kconfig
> > > > +++ b/drivers/usb/misc/sisusbvga/Kconfig
> > > > @@ -1,7 +1,7 @@
> > > >  
> > > >  config USB_SISUSBVGA
> > > >   tristate "USB 2.0 SVGA dongle support (Net2280/SiS315)"
> > > > - depends on USB && (USB_MUSB_HDRC || USB_EHCI_HCD)
> > > > + depends on (USB_MUSB_HDRC || USB_EHCI_HCD)
> > > 
> > > is it just me or would everybody agree that depending on MUSB or EHCI
> > > here is wrong ?
> > 
> > That line certainly looks like it could be removed entirely.  Perhaps 
> > the original author can enlighten us.
> > 
> > In any case, it's not relevant to the purpose of this patch set.
> 
> right :-)
> 

Originally it had just "depends on USB_EHCI_HCD" and the text mentions that
it requires USB 2.0, so it probably comes from a time where EHCI was the
only high speed capable USB HCD.

	Arnd
