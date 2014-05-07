Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbaEGPPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:15:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60086 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946AbaEGPO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:14:59 -0400
Date: Wed, 7 May 2014 17:14:56 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: <balbi@ti.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140507171456.3124ec71@free-electrons.com>
In-Reply-To: <20140507151008.GD769@saruman.home>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
	<20140506153953.GF25849@saruman.home>
	<20140507122326.54f3febc@free-electrons.com>
	<20140507151008.GD769@saruman.home>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Felipe Balbi,

On Wed, 7 May 2014 10:10:08 -0500, Felipe Balbi wrote:

> > ifneq ($(CONFIG_USB_XHCI_MVEBU), )
> > 	xhci-hcd-y += xhci-mvebu.o
> > endif
> > 
> > Right?
> 
> correct :-)
> 
> > If so, then what about instead making CONFIG_USB_XHCI_MVEBU a bool
> > instead of a tristate? It's more an option for the xhci-platform
> > driver than an additional separate module, IMO. What do you think?
> 
> fine by me too. It simply adds a quirk callback to xhci-plat.

In the end, I settled on keeping the tristate, and used your
suggestion. Because since xhci-plat itself is a blind option, and
xhci-mvebu selects it, if xhci-mvebu is a bool, there would no longer
be a way to have xhci-plat as a module. At least that's my
understanding of the kconfig stuff :)

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
