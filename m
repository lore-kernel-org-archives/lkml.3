Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbbA1CA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:00:58 -0500
Received: from ozlabs.org ([103.22.144.67]:52081 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204AbbA1CAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:00:55 -0500
Date: Wed, 28 Jan 2015 13:00:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20150128130047.2311c637@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kx.AJGkjc9l5UT4eVH9FeYJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kx.AJGkjc9l5UT4eVH9FeYJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64 allmodc=
onfig)
failed like this:

sound/soc/codecs/arizona.c: In function 'arizona_out_ev':
sound/soc/codecs/arizona.c:738:57: error: 'struct snd_soc_dapm_widget' has =
no member named 'codec'
  struct arizona_priv *priv =3D snd_soc_codec_get_drvdata(w->codec);
                                                         ^

Caused by commit 054e1b489227 ("ASoC: arizona: Add delay for output
disable") interacting with commit 96da4e5b2e1d ("ASoC: Remove codec
field from snd_soc_dapm_widget").  It needed to be fixed up in merge
commit 7659e0ab1afa ("Merge remote-tracking branches
'asoc/topic/ad193x', 'asoc/topic/alc5632', 'asoc/topic/arizona' and
'asoc/topic/atmel' into asoc-next").

I have used the sound-asoc tree from next-20150127 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/kx.AJGkjc9l5UT4eVH9FeYJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyELUAAoJEMDTa8Ir7ZwVo0sP/3b/fQHKfHz96XtZ07/hS+Dg
kK41FWo0oJeOb2vCH9A85aP7JmXVWtF/kx8W0w0JlsEs60jZB9QmqfVMXOL1FYOy
IRrVRcKQnFdrV4soXFieD65sH56GhQuZFejQZp9E2ERPAy0dvr2tTimHVO8u9+XR
MC5s5Gvs6KLOFBrd0AnVgbddQwGnknfqhFrWLZM506pn6s13MxJqaGdLpd5F7/Ao
UaHh1DTwRGQY1i4f9GcEnnYLZZrkDubDx+7XV2bsfAi4O4TFF+JeEryaJBD5t58m
kEHGrYxQMSoh1mBceGV1iyPg2I4prUNDO71pRkxqysoDcLmDYWE5lmyeex3S/9Bj
uo22bBtrVBxj7OT40vY84kwot936ytLiguIllTDX546cWGPzG1uyQKWYXCsqiTwU
DEqFqdHIoK13U1XmFc3tXLrwjd6ge29slSL0cPorY4ECO3eJMa2LFsDEDLGhTbSz
wmXycTuS/gq+vzPxadX9b9BEQSdu8OmOtThglKqVDys3ewnM8xMKd0ZmlzmBRUh1
E6jIUCAftI1z8gHb3VNZ7ynaVGi73VCJsglZMlLlyHXXjWwy8E9sW3mASq3PMLqf
nCa6iQqk5+MrJbdJHgK+gfYaJcw5Ft6InZhG2zDQ/ZB+IkMweTIQgZQio9oTXAtC
zR0lseYbeHAVEavbKVAo
=usAh
-----END PGP SIGNATURE-----

--Sig_/kx.AJGkjc9l5UT4eVH9FeYJ--
