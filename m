Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaL2QNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:13:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54347 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaL2QNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:13:32 -0500
Date: Mon, 29 Dec 2014 16:13:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: alsa-devel@alsa-project.org, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Message-ID: <20141229161303.GU17800@sirena.org.uk>
References: <1419325767-30602-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y7im8bf83ZGtWTRI"
Content-Disposition: inline
In-Reply-To: <1419325767-30602-1-git-send-email-qais.yousef@imgtec.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ALSA: ASoC: soc-compress.c: fix NULL dereference
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y7im8bf83ZGtWTRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2014 at 09:09:27AM +0000, Qais Yousef wrote:
> In soc_new_compress() when rtd->dai_link->daynmic is set, we create the p=
cm
> substreams with this call:
>=20
>    ret =3D snd_pcm_new_internal(rtd->card->snd_card, new_name, num,
>                                    1, 0, &be_pcm);
>=20
> which passes 0 as capture_count leading to
>=20
>    be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream
>=20
> being NULL, hence when trying to set rtd a few lines below we get an oops.
> Fix by removing this line of code since CAPTURE substream will always be =
NULL.

Why will the capture stream always be NULL?  There should be no
intrinsic reason why we can't have hardware support for capturing
compressed audio.

--y7im8bf83ZGtWTRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoX2OAAoJECTWi3JdVIfQgA8H/3fe7WH6f0ykKj4clB0cb2Fw
GS1gEyXayWD6QP1g3Q/prxIe1KoiPnNVzAclNcY7Sfy8lcpRt1LIwvYmUDj2EQDk
SUI/qjNp3AFGHYFn7yaQ7hIuqXHu0WE32wxZxEd9dcWqgfPIPQ1jcik1+75OLfGa
sC/yoAmoq3gZ8tLjAsOC4L7coHNzIBlGQ/YQ7LNSkxKtP2pVha7ekkcw6nxja4XI
14vmg1zsPn2rsbr2i50eXtLCY/CF9BalExQ3LFNTsyaKmEp3pksRFfZ1bbxeCQHh
llkf0mUA5nNTrvGAHNlPAytDK+vLVZ6ooCFjfKFvwu34IoLW+DrcQ0lCHkfRjKE=
=bErF
-----END PGP SIGNATURE-----

--y7im8bf83ZGtWTRI--
