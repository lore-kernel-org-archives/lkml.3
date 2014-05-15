Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaEOQfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:35:05 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49270 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEOQfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140515160735.GF7360@saruman.home>
References: <1400156926-11100-1-git-send-email-ricardo.ribalda@gmail.com>
 <1400156926-11100-2-git-send-email-ricardo.ribalda@gmail.com> <20140515160735.GF7360@saruman.home>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 15 May 2014 18:34:41 +0200
Message-ID: <CAPybu_1vs1cEfXHDS1N1nVrabfW3hH58Qzc1f8pDXTVe9jKmhA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] usb: gadget: net2280: Add support for PLX USB338X
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Amit Uttamchandani <auttamchandani@logicube.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2014 18:07, "Felipe Balbi" <balbi@ti.com> wrote:
>
> On Thu, May 15, 2014 at 02:28:46PM +0200, Ricardo Ribalda Delgado wrote:
> > This patch adds support for the PLX USB3380 and USB3382.
> >
> > This driver is based on the driver from the manufacturer.
> >
> > Since USB338X is register compatible with NET2280, I thought that it
> > would be better to include this hardware into net2280 driver.
> >
> > Manufacturer's driver only supported the USB33X, did not follow the
> > Kernel Style and contain some trivial errors. This patch has tried to
> > address this issues.
> >
> > This patch has only been tested on USB338x hardware, but the merge has
> > been done trying to not affect the behaviour of NET2280.
> >
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> anybody with net2280, please give me a Tested-by so I'm sure there are
> no regressions caused by this patch. One question though, is it worth to
> use the legacy mode just to get register compatibility ? What are the
> drawbacks of using legacy mode ? Is any feature missing when we use
> legacy mode ?
>
> cheers

This patch is a merge of the full driver from plx with the net2280
driver. It should support enhanced and legacy mode. The mode is
selected with a pull up/down on a pin.

I have tested it with a usb3880 EV board in USB 3.0 and 2.0

According to the doc. The chip in legacy mode should be a almost 100%
compatible with the old driver. But of course no superspeed is
available with the unmodified net2280 driver. Also there are some
erratas that needs to be addressed.

"
As the successor of the gold standard NET 2280, PCI to USB 2.0
Peripheral Controller, the USB 3380 can be used with existing NET 2280
software with no or minimal change."

On enhanced mode there are more endpoints and some other improvements.

Regards

PS sorry for the double post. The first one was in HTML thanks to gmail app :P

>
> --
> balbi
