Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3JKBzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:55:02 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:23279
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab3JKBy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:54:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1155h)
Date: Fri, 11 Oct 2013 09:42:40 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Arokux X <arokux@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: When USB PHY framework should be used?
Message-ID: <20131011014239.GC14116@shlinux1.ap.freescale.net>
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:21:36PM +0200, Arokux X wrote:
> Hi,
> 
> recently I have been working on mainlining a simple bus glue driver
> for the USB EHCI for the Allwinner family of the ARM SoCs aka sunxi.
> The patches are almost ready and can be found at [1] and will be
> submitted once completely ready. The most interesting patch is [2]
> which is a driver itself.
> 
> Currently everything works. Recently Maxime Ripard brought the reset
> framework to my attention which I am going to use, since each of the
> PHYs has a reset bit. Right now those bits are treated as clocks.
> 
> Later I am going to add the OHCI support. OHCI and EHCI will be
> different drivers in different modules but they will share the same
> PHY. I do not quite understand how can I correctly use reset framework
> in the case of the common PHY. Imagine a situation if EHCI and OHCI
> drivers got loaded and deassert the (same) reset bit. Then a user
> decides to rmmod one of the drivers. This will cause it to assert the
> reset bit, which will make the other driver to fail. So it is clear
> there is a need for some central manager for the reset bit which is
> going to be poked by both EHCI and OHCI.
> 
> Maxime Ripard also brought to my attention the new USB phy framework
> which was merged into usb-next. However I'm not sure it should be used
> in my driver since as far as I understand a PHY of a USB Host
> Controller I'm dealing with is built into the controller itself. The
> only parts of the driver that touche a PHY are reset bits (different
> for each controller) and some initialization bits [3]. In addition the
> in the doc file phy.txt I read
> 
> "This framework will be of use only to devices that use external PHY
> (PHY functionality is not embedded within the controller)."

More exactly, it your PHY is not the same register mapping with controller's
you can use it.

> 
> So can you please give me some hints about the possibilities to share
> single reset bit? Should I use PHY framework, or create some kind of a
> common module that is going to be used by EHCI and OHCI. In addition I
> wanted to ask where I should normally put a common code like [4].

For your situation, you may need to create a controller driver, and call
ehci, ohci, and phy init at this probe routine, in that way, your ohci
and ehci controller will need to be unloaded together.

-- 

Best Regards,
Peter Chen

