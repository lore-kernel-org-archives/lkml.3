Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaLTAK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:10:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaLTAKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:10:54 -0500
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Reichel <sre@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Date: Sat, 20 Dec 2014 11:09:20 +1100
Subject: [PATCH 0/2] tty slave devices support - version 2
Cc: GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141219235827.13943.45713.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all the great feedback.  I have incorporated a lot of it,
though not all ... partly because there was not yet unanimity on some
issues.

Big changes:
 - children of a uart are no longer automatically managed.
   The driver for the child device must register with the tty
   after which it will be told when the tty is opened or closed.
   The driver can then do whatever it likes, which may involve
   powering the device on.

 - I am now only providing a single drivers: serial-power-manager.
   It can be used for devices which only want power management.
   Currently it can provide this using a regulator and/or a
   toggle GPIO.  This one driver supports both of my devices.

non-changes:
 - The interface functionality is still provided by the 'tty'
   layer, not the 'serial' layer.  I have no strong feelings on
   this and doubt that I would have until some other user
   appeared for this functionality.  That would help show
   if the current arrangement was helpful or inconvenient.

 - We still treat any child node of a tty device which has a
   'compatible' field gets allocated a device.  If there is no
   platform driver which supports that 'compatible' value, then
   the device will be inactive.  Specific action will only be
   taken if there is a child node with a 'compatible' field for which
   there is a supporting driver.

small changes:
 - proper 'compatible' names are used
 - switch to use 'gpiod' instead of 'gpio'
 - no longer misuse the 'tty_' prefix.


Comments and suggestions always welcome,
Thanks,
NeilBrown

---

NeilBrown (2):
      TTY: add support for "tty slave" devices.
      misc: add a driver to power on/off UART attached devices.


 .../devicetree/bindings/misc/wi2wi,w2cbw003.txt    |   19 +
 .../devicetree/bindings/misc/wi2wi,w2sg0004.txt    |   37 +
 .../devicetree/bindings/serial/of-serial.txt       |    4 
 .../devicetree/bindings/vendor-prefixes.txt        |    1 
 drivers/misc/Kconfig                               |   12 
 drivers/misc/Makefile                              |    1 
 drivers/misc/serial-power-manager.c                |  494 ++++++++++++++++++++
 drivers/tty/tty_io.c                               |   73 +++
 include/linux/tty.h                                |   16 +
 9 files changed, 654 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/wi2wi,w2cbw003.txt
 create mode 100644 Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
 create mode 100644 drivers/misc/serial-power-manager.c

--
Signature

