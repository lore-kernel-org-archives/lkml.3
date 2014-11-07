Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaKGXhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:37:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbaKGXhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:37:16 -0500
Date: Sat, 8 Nov 2014 10:37:07 +1100
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: [PATCH] Input: gpio_keys: Make sure wake-up buttons work.
Message-ID: <20141108103707.45bcc7e3@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/FGlCOKzFrFN6+74b4H00Z3S"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FGlCOKzFrFN6+74b4H00Z3S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



If a key is to be used for wake-up, we must not disable
the interrupt during suspend.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gp=
io_keys.c
index 8c98e97f8e41..0b5e54ae343e 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -526,6 +526,8 @@ static int gpio_keys_setup_key(struct platform_device *=
pdev,
 	 */
 	if (!button->can_disable)
 		irqflags |=3D IRQF_SHARED;
+	if (button->wakeup)
+		irqflags |=3D IRQF_NO_SUSPEND;
=20
 	error =3D devm_request_any_context_irq(&pdev->dev, bdata->irq,
 					     isr, irqflags, desc, bdata);

--Sig_/FGlCOKzFrFN6+74b4H00Z3S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1XpDnsnt1WYoG5AQKQ0w/+J+ODAuwM5fY6vUE3rywVFgZsvDAnL3aq
bcZWTY/h4n8D9QOl8uGRI5Wu1VjSayiyKti5UG9briX/CxkuGi3Pmphf8rb824+Y
sWtaXiRm0WRUR+7d/CFwk7bc98CPAibHyzOS2bU9fT3AyqdV4btqfUbp30ZzYaYZ
fNEH+QORGleK79nfJTc9LORlpNEOYw862Sr2fBJ1a2nlgyroIvKbJoPYtB2Fi7X3
bQg2IJ+yeTIcusv2GRulZ9SfYPOQHTQOj0KOl28ScvcpXxGJSZjmK75dpbYim3g6
S7hNn5u20vmGXCSIVrxhhqWUXrD3KArX5ETTKIWG98aunkjWjqjfmiJnY5WmljS/
WRAHnqPL8fPXwsz+IwiD4jQb4o53DnQLCq0x9pQdAOzNP2eA9BNCJ9xZ0e2PrYpX
GJeVxV1q8jTt/jPmEl2tSdJW/uIS14O8Y+JoZsf0Xoc+jJkRMvsmUV3lRmCtPWDn
Z99FI6whPRENOUvdow3JoVNIxFfB7vKsGD3iv9JeimgUpOe+w52yf470Lq+sGXS+
tJrZrnqLOstZmroCkPwJBnonWHFTk7BSel2SNMkO89XVS6c1gT593Gpfyjk7xdvX
XLvu7D7tHQ8/ftrM4cf/5XCN9bffGEtMgK6ObgypGRq+DHlzlOpKskppccDQhWKA
jYLV9SMxzL8=
=bVxd
-----END PGP SIGNATURE-----

--Sig_/FGlCOKzFrFN6+74b4H00Z3S--
