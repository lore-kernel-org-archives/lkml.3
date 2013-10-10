Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3JJTVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:21:39 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:63877 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JJTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:21:37 -0400
MIME-Version: 1.0
Date: Thu, 10 Oct 2013 21:21:36 +0200
Message-ID: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
Subject: When USB PHY framework should be used?
From: Arokux X <arokux@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, kishon@ti.com
Cc: linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

recently I have been working on mainlining a simple bus glue driver
for the USB EHCI for the Allwinner family of the ARM SoCs aka sunxi.
The patches are almost ready and can be found at [1] and will be
submitted once completely ready. The most interesting patch is [2]
which is a driver itself.

Currently everything works. Recently Maxime Ripard brought the reset
framework to my attention which I am going to use, since each of the
PHYs has a reset bit. Right now those bits are treated as clocks.

Later I am going to add the OHCI support. OHCI and EHCI will be
different drivers in different modules but they will share the same
PHY. I do not quite understand how can I correctly use reset framework
in the case of the common PHY. Imagine a situation if EHCI and OHCI
drivers got loaded and deassert the (same) reset bit. Then a user
decides to rmmod one of the drivers. This will cause it to assert the
reset bit, which will make the other driver to fail. So it is clear
there is a need for some central manager for the reset bit which is
going to be poked by both EHCI and OHCI.

Maxime Ripard also brought to my attention the new USB phy framework
which was merged into usb-next. However I'm not sure it should be used
in my driver since as far as I understand a PHY of a USB Host
Controller I'm dealing with is built into the controller itself. The
only parts of the driver that touche a PHY are reset bits (different
for each controller) and some initialization bits [3]. In addition the
in the doc file phy.txt I read

"This framework will be of use only to devices that use external PHY
(PHY functionality is not embedded within the controller)."

So can you please give me some hints about the possibilities to share
single reset bit? Should I use PHY framework, or create some kind of a
common module that is going to be used by EHCI and OHCI. In addition I
wanted to ask where I should normally put a common code like [4].

Thank you in advance,
Arokux




[1] https://github.com/arokux/linux/commits/sunxi-next-usb
[2] https://github.com/arokux/linux/commit/1f271d01b8138d5a593df18a80b4129a08eac1be
[3] https://github.com/arokux/linux/commit/1f271d01b8138d5a593df18a80b4129a08eac1be#diff-2fdea331a4331eca7c86f18cd2d87e72R89
[4] https://github.com/arokux/linux/commit/1f271d01b8138d5a593df18a80b4129a08eac1be#diff-2fdea331a4331eca7c86f18cd2d87e72R104
