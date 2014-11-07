Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaKGXk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:40:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbaKGXkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:40:24 -0500
Date: Sat, 8 Nov 2014 10:40:15 +1100
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: [PATCH] Input: twl4030-pwrbutton: ensure a wakeup event is
 recorded.
Message-ID: <20141108104015.635a7388@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+tz=3THW/tmZZrmiOxZNXSe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+tz=3THW/tmZZrmiOxZNXSe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



This button is treated as a wakeup source, so we need to initialise it
correctly.

Without the device_init_wakeup() call, dev->power.wakeup will
be NULL, and pm_wakeup_event() will do nothing.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/tw=
l4030-pwrbutton.c
index fb3b63b2f85c..8400a1a34d87 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -85,6 +85,7 @@ static int twl4030_pwrbutton_probe(struct platform_device=
 *pdev)
 	}
=20
 	platform_set_drvdata(pdev, pwr);
+	device_init_wakeup(&pdev->dev, true);
=20
 	return 0;
 }

--Sig_/+tz=3THW/tmZZrmiOxZNXSe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1YXznsnt1WYoG5AQKtnw/+PR6ghZbzFGZ57RvvlDXmg9R9tN3IIP+g
+ofG/LmXONhdI4r7PejG53+rpRm8lSays2UGgloGo7OR/cdJne4Rxoylf/WbqunR
vUHSwaucSWfHCMpQm7K8qpquSAg2xuzUNcFJyEYx6LCrQfOkJQgSRCs8IwwxOF8Z
Dva9fAF4h0TGJLWvX5K3eySBu7tJfMVim6+VtYahRk8mPn7eqv14Nid3CWzJwjVW
ZnuQiX/BkFKYEZQGFjaRra9Fwdxqmrfdq4UoQA5c6/CEc+1NdtH42MEbnXpvC0Ab
Tu6OTBvNu1gbr9SbTOzDSzUfmFiuOZVkyv25yFZP9wjXkWd7aPkRfNl8OddArs4I
DD8Fz1uIWbS5fq02soREiidm3L9FLcAJgC8hxeQ/CeW8tCTba2aU/oJRXzkTqGK7
NLlPZRxzK8aT8LoEggr3BiAE+COLqk+S6LHF31xR8HOJvic3esOB2+fwu3xwctka
BeGF0AEUIu77U9M2C0vGJ6XgZaQDSc1zdGiJRMS8/YCijuwIr0dBPVfvM/KEKmdx
nChTRqN73f1N5V+TLaZwz7AYeDQ09Cwlf+7GcrsJcwJaRTJ9vOQIN7l4vQBSyrpt
hUDQ+IBfQJT41m6hqPL2nx4s8IPxsEvNVlhYB2iEkbiSbX0aQqscFmi5a354OiMs
/8ErbJkfR8A=
=URX5
-----END PGP SIGNATURE-----

--Sig_/+tz=3THW/tmZZrmiOxZNXSe--
