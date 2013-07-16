Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab3GPSgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:36:24 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:34951 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab3GPSgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:36:22 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Federico Vaga <federico.vaga@gmail.com>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: DWC2 and/or S3C-HSOTG for STA2X11 board
Thread-Topic: DWC2 and/or S3C-HSOTG for STA2X11 board
Thread-Index: AQHOghweXFesBEju+UWQjw6fLZJ6BplnnlVQ
Date: Tue, 16 Jul 2013 18:36:21 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DDC71C@US01WEMBX2.internal.synopsys.com>
References: <38175373.Cq6zxae9tO@harkonnen>
In-Reply-To: <38175373.Cq6zxae9tO@harkonnen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Federico Vaga [mailto:federico.vaga@gmail.com]
> Sent: Tuesday, July 16, 2013 5:02 AM
> 
> I have an x86 board made by STMicroelectronics (STA2X11) with the Synopsis
> USB-OTG DesignWare 2 on it and connected through the PCI-e bus.
> 
> I know that there are two drivers for the same controller:
> 
>    (host)   drivers/staging/dwc2/*
>    (device) drivers/usb/gadget/s3c-hsotg.{c|h}
> 
> So, at the moment I cannot have a board with both host/device working at the
> same time. I have to choose to use the block as device or host, right?
> 
> I know that the plan is to merge the s3c-hsotg in the dwc2 driver
> (https://lwn.net/Articles/540283/). Are still accepted patch to s3c-hsotg? Or
> it is work in progress right now (soon), so it is better to wait after the
> merge?
> 
> In order to use the s3c-hsotg I must implement a PCI wrapper that uses this
> driver. It will be accepted in the kernel even if it will be removed sooner or
> later because of the driver merge?

Hi Federico,

As part of the merge, we will need to develop a PCI wrapper for
s3c-hsotg anyway, so I think it would not be wasted effort.
Actually, as a POC I already did this as a quick hack, just to
make sure that the driver will work on our PCIe prototyping
platform (it does).

As Felipe says, currently s3c-hsotg does have too much knowledge
of Samsung platform. But it should be fairly easy to move that
knowledge from the core code to a platform-device wrapper,
similar to platform.c in the dwc2 driver. So if you would like
to work on that (creating a PCI wrapper and a platform wrapper)
I think it would be useful.

If you want, I can send you my hacked-up code for the PCI
version of the driver, to use as a starting point.

-- 
Paul

