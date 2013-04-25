Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab3DYPUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:20:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39178 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757867Ab3DYPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:20:39 -0400
Date: Thu, 25 Apr 2013 11:20:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
cc: gregkh@linuxfoundation.org, <sarah.a.sharp@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, <Julia.Lawall@lip6.fr>,
        USB list <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        ratbert <ratbert.chuang@gmail.com>,
        =?UTF-8?B?Sm9obiBGZW5nLUhzaW4gQ2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH v3] usb host: Faraday USB2.0 FUSBH200-HCD driver
In-Reply-To: <CADB-GoLz=oPcfUxY+epqHthrxHno4z-5qzHkOziDiPpsY4Hasw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304251118320.948-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Yuan-Hsin Chen wrote:

> Hi,
> 
> Are there any comments?

This is okay.  There's just one thing...

> On Tue, Apr 16, 2013 at 8:43 PM, Yuan-Hsin Chen <yuanlmm@gmail.com> wrote:
> 
> > FUSBH200-HCD is an USB2.0 hcd for Faraday FUSBH200.
> > FUSBH200 is an ehci-like controller with some differences.
> > First, register layout of FUSBH200 is incompatible with EHCI.
> > Furthermore, FUSBH200 is lack of siTDs which means iTDs
> > are used for both HS and FS ISO transfer.
> >
> > Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
> > ---
> >
> > v2:
> > use ehci-platform.c
> > use anonymous union and struct
> > add is_fusbh200 to struct ehci_hcd
> >
> > v3:
> > duplicate most of code from Linux-3.8 ehci hcd

> > --- a/drivers/usb/host/Kconfig
> > +++ b/drivers/usb/host/Kconfig
> > @@ -287,6 +287,14 @@ config USB_ISP1362_HCD
> >           To compile this driver as a module, choose M here: the
> >           module will be called isp1362-hcd.
> >
> > +config USB_FUSBH200_HCD
> > +       bool "Faraday FUSBH200 HCD support"

Shouldn't this be tristate?

> > +       depends on USB
> > +       default N
> > +       ---help---
> > +       The USB HCD Driver of Faraday FUSBH200 is designed to
> > +       meet USB2.0 EHCI specification with minor modification
> > +

Alan Stern

