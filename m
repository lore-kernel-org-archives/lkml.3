Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbbAOOz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:55:28 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:56331 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbbAOOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:55:21 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] tty: serial: 8250_core: Check that port->line is >=0
Date: Thu, 15 Jan 2015 15:55:08 +0100
Message-Id: <d3a26f5ecd44e1415f213e6ee7f33005c1b23f4a.1421333585.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com>
References: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com>
In-Reply-To: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com>
References: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-24549-1421333716-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-24549-1421333716-0001

This patch should be the part of:
"tty: serial: 8250_core: use the ->line argument as a hint in
serial8250_find_match_or_unused()"
(sha1: 59b3e898ddfc81a65975043b5eb44103cc29ff6e)

port->line can be setup by DT driver to -1 which needs to
be also checked.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

I have similar patch to 59b3e898ddfc81a65975043b5eb44103cc29ff6e
in xilinx tree for a while and port->line can be -1.

The second part of this also should be (what other drivers do)
reading aliases via of_alias_get_id() in of_serial.c:of_platform_serial_probe()
which setup port.line.
---
 drivers/tty/serial/8250/8250_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 65e52c9109e2..aab765177763 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -3512,7 +3512,8 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *

 	/* try line number first if still available */
 	i = port->line;
-	if (i < nr_uarts && serial8250_ports[i].port.type == PORT_UNKNOWN &&
+	if (i >= 0 && i < nr_uarts &&
+	    serial8250_ports[i].port.type == PORT_UNKNOWN &&
 			serial8250_ports[i].port.iobase == 0)
 		return &serial8250_ports[i];
 	/*
--
1.8.2.3


--=_mimegpg-monstr-desktop-24549-1421333716-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS31NQACgkQykllyylKDCFXxQCdG9vb+NwOiAdTFVKvAb9b+MvK
JicAn3JnTLvyRKmNN1yX9i0NtGG5tOli
=nUY/
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-24549-1421333716-0001--
