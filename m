Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742Ab3B0TNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:13:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55082 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3B0TN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:13:29 -0500
Date: Wed, 27 Feb 2013 21:13:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Luciano Coelho <coelho@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: container_of() doubt
Message-ID: <20130227191322.GA27264@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

hehe, you must've answered this over and over again, but I don't see the
need for __mptr in the container_of() macro. I tried googling it but
couldn't find much.

I get the macro, but not the need __mptr. Wouldn't this work the same
way ?

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 80d3687..bbce857 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -717,8 +717,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oo=
ps_dump_mode) { }
  *
  */
 #define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr =3D (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+	(type *)( (char *)(ptr) - offsetof(type,member) );})
=20
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)

why do we need this type * NULL ?

thanks

--=20
balbi

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRLlrSAAoJEIaOsuA1yqREDskP/iQ3HeIOLZ+B1E7buWjvr1rn
9WcxPBq5B10FDr6soQQDpOuCaxFgw94h55/tP+ZvXtnm9bWUxtRnKgiJL61VsATX
R3TG+g8jjRqNPMs2WGsaZyxsCxAO1w/E6105FIbV7f7bZclngIEX13BP7MZpW1ZT
RLktecTi7WJG6ZivyrBG72c2GfsYAltDfxnryIY6fIRmgC7LO6hictU09eRELKZu
8jWC70n0ZGvNRF/7kn81tdSBoeTKaKjMgFtoKdO+mKOTCbplYDJGO9M7/Di82H9C
BH7Iga5AcGFXYuPGZi6fvQWgx8EFVq2+wDM3Pya1l6DSrClic9Ivjz4w7QcC/Ftc
cEKGK1WOXqdGh98QGchjJRSnDPl7U0W3LwIlQEsdj4TZPI/Ix6K80G8h3zHjQ6iv
Gg9zeI5C/5SE5DGriJOnmj6XNwypuGdWRNz3zzYoNKo2aTxt03uZOqdxOKYPWTi8
hLVoKt0dlYeaf4fm/75qviYPxwF56rO6TqiNn6xj4qYf6oBLoLXuYtlHTwCpYUoN
Qvmws8LaiLIwAnBQixzWu4px7kfSyycdfNUM6bBGM+qjav2h9o4sTTtMLUuoRn9c
6yJERorhqqemjkNB5tCZAsWOR2txmRLN7UAxPpRDRE9SuGuCyIhXI1wPg3wmdG6V
Wv20IFSaybvEdHukcm9t
=4Mfk
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
