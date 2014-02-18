Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaBRHkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:40:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:43003 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753976AbaBRHkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:40:04 -0500
Date: Tue, 18 Feb 2014 08:37:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] spi: core: Fix Oops in spi_pump_messages error path
Message-ID: <20140218073712.GA3142@lukather>
References: <1392657637-5297-1-git-send-email-maxime.ripard@free-electrons.com>
 <CAMuHMdXc5zyd1aBigrisvx43VVjStCMgtCcHmefdK-n5shTTmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXc5zyd1aBigrisvx43VVjStCMgtCcHmefdK-n5shTTmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Mon, Feb 17, 2014 at 07:02:09PM +0100, Geert Uytterhoeven wrote:
> On Mon, Feb 17, 2014 at 6:20 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > When the generic implementation of the transfer_one_message callback wa=
s called
> > by the spi_pump_messages function, if that transfer was to fail, the
> > spi_finalize_current_message was called twice, once in
> > spi_transfer_one_message, and one in spi_pump_messages.
> >
> > This was causing a null pointer dereference in the second call, because=
 the
> > first one set the ->cur_msg field to NULL.
> >
> > Since the SPI framework expect the transfer_one_message callback to call
> > spi_finalize_current_message, we can remove it from spi_pump_messages, =
together
> > with any dereference of the ->cur_msg pointer.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Cc: stable@vger.kernel.org
>=20
> Already fixed in v3.14-rc3 in 1f802f8249a0da536877842c43c7204064c4de8b
> ("spi: Fix crash with double message finalisation on error handling").
>=20
> There's no need to inform stable, as the problem was introduced in v3.14-=
rc1.

Oops, totally missed that. Thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTAw2oAAoJEBx+YmzsjxAgqnEP/0MA+WMXdo6HdFZ60Ee18VlV
SQN7h1/UJkHm6c1lZ89AJcvHbrP3w/kLepBQ+/fqqZjkjzsT18rJgXHt4QxxU7B0
Pi4T1knNQZ9/P3yUF5Q/cAvqOBBbJu6P5ox0yS79VSEppq4bGkw9h108V778pFIP
J947jBp+zvmQPcjbpeiKr2Wkji9XrBmLC2D3Y2cQJqLCZNOaGkwez9C4sIuAK906
ksVOysPYOufkNL3P8DZ6kGAHmIPcVJjYOoITGQ9aIRwkkdiQRpwt6YXtAvgnGz3B
dWGwdExWGopp5vwxEnf/9McGAK408krH2Z5Jowj/Do2XuOq13uPrJcsObKFyH7on
9hCl4mnr+Ah9xLj6KI3tlESHD+HvzAkNrrzCCO5ev6naIrSulNJ8XDTIx9b8eBjc
2XBEWAdlIcJK3Ued3Cs+U8+X6+SlkKxlLYmbnvTEMcOjga0MAKOEVlaVfHl7eDDf
paLhrda1fVCe5ToqxTwZFx8R0vlYtN3yiEkLdfv1EiyHGWjBsXZXQ/GcbaadwDRY
EbBcEY8p+hocvjySdtpi579mtcRewHRdSt6+z4sK5pafuPYuzfBpao/UJFJi3Meq
G3VtHd9MQ+j0JZL9A2yuZfrwMfyX4zCLY1gLM1SY6W9hAuACzY4z9gilVN2IQpys
d0ZIRrwpnCGawT1h+ntT
=5Aey
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
