Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3KTOuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:50:17 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:64256 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3KTOuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:50:11 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: input question: ambient light sensor button
Date: Wed, 20 Nov 2013 15:50:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
References: <201309151553.34000@pali> <201311141302.33384@pali> <20131119212736.GA25784@core.coreip.homeip.net>
In-Reply-To: <20131119212736.GA25784@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1694287.dlSEoh0hZL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311201550.05800@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1694287.dlSEoh0hZL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 19 November 2013 22:27:36 Dmitry Torokhov wrote:
> On Thu, Nov 14, 2013 at 01:02:31PM +0100, Pali Roh=C3=A1r wrote:
> > On Wednesday 13 November 2013 17:28:40 Dmitry Torokhov wrote:
> > > On Wed, Nov 13, 2013 at 11:47:18AM +0100, Jiri Kosina wrote:
> > > > On Sun, 15 Sep 2013, Pali Roh=C3=A1r wrote:
> > > > > I do not know where to ask this question, but I think
> > > > > that kernel developers could help me.
> > > > >=20
> > > > > I have notebook with one special button on keyboard
> > > > > which is designed for turning ambient light sensor on
> > > > > and off. By default pressing button do nothing (I can
> > > > > turn ambient light sensor on/off via sysfs platform
> > > > > wmi module). Button press is reported by kernel input
> > > > > device AT Translated Set 2 keyboard and reports it as
> > > > > button "touchpad off".
> > > > >=20
> > > > > Of course "touchpad off" is incorrect and I'd like to
> > > > > ask which kernel key or button from
> > > > > /usr/include/linux/input.h should be mapped for my
> > > > > ambient light sensor button? Is there already some?
> > > > > And what is strategy for allocating KEY_* and BTN_*
> > > > > numbers?
> > > >=20
> > > > This is maintained by Dmitry, so he's the one to answer
> > > > this. I am adding him to CC.
> > >=20
> > > I guess we need patch adding
> > >=20
> > > 	#define KEY_ALS_TOGGLE	0x230
> > >=20
> > > Thanks.
> >=20
> > So there is no good key for als yet?
>=20
> No, but if you send me a patch adding it I will gladly apply
> it.
>=20
> Thanks.

Ok, here is patch:

Add key code for ambient light sensor button

More notebooks have special button for enabling/disabling ambient
light sensor. This patch adding new als code to input.h header file.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>

diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index a372627..1562f10 100644
=2D-- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -719,6 +719,8 @@ struct input_keymap_entry {
 #define BTN_DPAD_LEFT		0x222
 #define BTN_DPAD_RIGHT		0x223
=20
+#define KEY_ALS_TOGGLE		0x230
+
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0
 #define BTN_TRIGGER_HAPPY2		0x2c1


=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1694287.dlSEoh0hZL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKMzB0ACgkQi/DJPQPkQ1KPTgCdGyK96O5jdocgzzrI83kCZ9XG
/uAAoMD55PfMO5PWZ4kZvvyBV7K0Hxak
=/Ajw
-----END PGP SIGNATURE-----

--nextPart1694287.dlSEoh0hZL--
