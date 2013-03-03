Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3CCJKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:10:51 -0500
Received: from mail.gw90.de ([188.40.100.199]:58885 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3CCJKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:10:45 -0500
Message-ID: <1362301836.13011.8.camel@mattotaupa>
Subject: [PATCH v2] sp5100_tco: Set the AcpiMmioSel bitmask value to 1
 instead of 2
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>
Date: Sun, 03 Mar 2013 10:10:36 +0100
In-Reply-To: <1362289680-3527-1-git-send-email-mc74hc00@gmail.com>
References: <1362289680-3527-1-git-send-email-mc74hc00@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PtUMcUQU050YfMhrIxI7"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PtUMcUQU050YfMhrIxI7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Takahisa Tanaka <mc74hc00@gmail.com>
Date: Sun, 3 Mar 2013 14:48:00 +0900

The AcpiMmioSel bit is bit 1 in the AcpiMmioEn register, but the current
sp5100_tco driver is using bit 2.

See 2.3.3 Power Management (PM) Registers page 150 of the
AMD SB800-Series Southbridges Register Reference Guide [1].

        AcpiMmioEn - RW =E2=80=93 8/16/32 bits - [PM_Reg: 24h]
        Field Name        Bits  Default  Description
        AcpiMMioDecodeEn  0     0b       Set to 1 to enable AcpiMMio space.
        AcpiMMIoSel       1     0b       Set AcpiMMio registers to be memor=
y-mapped or IO-mapped space.
                                         0: Memory-mapped space
                                         1: I/O-mapped space

The sp5100_tco driver expects zero as a value of AcpiMmioSel (bit 1).

Fortunately, no problems were caused by this typo, because the default
value of the undocumented misused bit 2 seems to be zero.

However, the sp5100_tco driver should use the correct bitmask value.

[1] http://support.amd.com/us/Embedded_TechDocs/45482.pdf

Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
CC: stable@vger.kernel.org
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
v2: Hopefully improved the commit message.

 drivers/watchdog/sp5100_tco.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
index 71594a0..2b28c00 100644
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -57,7 +57,7 @@
 #define SB800_PM_WATCHDOG_DISABLE	(1 << 2)
 #define SB800_PM_WATCHDOG_SECOND_RES	(3 << 0)
 #define SB800_ACPI_MMIO_DECODE_EN	(1 << 0)
-#define SB800_ACPI_MMIO_SEL		(1 << 2)
+#define SB800_ACPI_MMIO_SEL		(1 << 1)
=20
=20
 #define SB800_PM_WDT_MMIO_OFFSET	0xB00
--=20
1.7.10.4

--=-PtUMcUQU050YfMhrIxI7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlEzE4wACgkQPX1aK2wOHVjvFQCfbi1opinblrKNI/T6LfmsoeEN
0ycAn1JIKC28rRyuLHT6QwP8kYW6KFjy
=roRs
-----END PGP SIGNATURE-----

--=-PtUMcUQU050YfMhrIxI7--

