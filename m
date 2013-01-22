Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3AVPjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:39:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54525 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3AVPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:39:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Date: Tue, 22 Jan 2013 15:38:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Manjunath Goudar <manjunath.goudar@linaro.org>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
References: <Pine.LNX.4.44L0.1301221011190.1510-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301221011190.1510-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221538.55975.arnd@arndb.de>
X-Provags-ID: V02:K0:jiKTpi7jQ23Y30Dev74QwWh4BLgJMebiSUc/j/ASSXV
 3W6KKsS8hjFmcQClKU+AYXvuDXwK8jsjqSa0htkxiEPSrQ0//y
 y81mp18SsW5C7NmWqgd/rYmJ70xdTESkMnfNPmz3IkpuaunoaL
 fIZkivQocgW+qhnpmohWVQoz7ChOta69sZce7eNqw+gWoqLzl0
 uuZ99GlTmgMCZ9cpkQCYvXPsS3x9RfmpL32T8jSD9u1rIJPOyh
 jUl2zokLQ6SwRSL/EUvqedbBhm6M9fo9cz3H/ViRrrlNBS70oA
 OHjQfYiqoInnHpiscqiHyZsYGVCwk8T6fVaNLp1WTj8f3zbD6+
 /z14p9jKoVzqxwy8g6Q8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Alan Stern wrote:
> In order to prevent this, you have to make sure that each glue driver
> depends on USB_ARCH_HAS_EHCI.  A simple way to do this is to surround
> the Kconfig entries for those drivers with "if USB && 
> USB_ARCH_HAS_EHCI" ... "endif".

I was actually thinking we could remove the use of USB_ARCH_HAS_EHCI
as well once we have inverted the logic for selecting USB_EHCI_HCD,
but there is another problem with that, because then we still need
something to select USB_ARCH_HAS_HCD, or kill that symbol as well.

	Arnd
