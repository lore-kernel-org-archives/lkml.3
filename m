Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaDYUZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:25:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49835 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751866AbaDYUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:25:41 -0400
Date: Fri, 25 Apr 2014 22:25:36 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 03/18] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140425222536.430d5c4d@skate>
In-Reply-To: <5392399.GiPjM0CIZ0@wuerfel>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
	<1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
	<5392399.GiPjM0CIZ0@wuerfel>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Fri, 25 Apr 2014 22:01:51 +0200, Arnd Bergmann wrote:

> I think you're doing it the wrong way around: You have a specialized
> version of the generic xhci-plat driver. The normal way to handle this
> is to have a loadable module that contains all the Armada specific
> code and that registers a platform_driver. In the probe() function of
> that driver, you can do the platform specific setup and then call
> the generic xhci_plat_probe() function, which of course has to
> be provided using EXPORT_SYMBOL_GPL.

You should have a look at the v1 Gregory sent: it was implementing
exactly what you suggest here, but Felipe explicitly requested the
patches to be changed like is now proposed in v2.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
