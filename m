Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3KKNaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:30:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33449 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab3KKN3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:29:54 -0500
Message-ID: <5280DBA6.50303@ti.com>
Date: Mon, 11 Nov 2013 15:29:10 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 0/3] omapdss: venc: Add support for bypass and acbias.
References: <1381784555-18344-1-git-send-email-marek@goldelico.com> <CAAfyv34j+YhEjtHyf7zg5oBoCV5ROEXow8VV0PQNHLTF5uDZJg@mail.gmail.com>
In-Reply-To: <CAAfyv34j+YhEjtHyf7zg5oBoCV5ROEXow8VV0PQNHLTF5uDZJg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="uT8p3dMaVFhkCoRJa5DBOdlfE1WFnvCgv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uT8p3dMaVFhkCoRJa5DBOdlfE1WFnvCgv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-11-05 09:24, Belisko Marek wrote:
> Hi,
>=20
> ping.
>=20
> On Mon, Oct 14, 2013 at 11:02 PM, Marek Belisko <marek@goldelico.com> w=
rote:
>> This patches is adding bypass and acbias functionality to omapdss venc=
 driver.
>> In first patch we export updatin bypass and acbias in devconf1 registe=
r. Next patch
>> add handling for updating in venc driver and last patch add driver for=
 opa362 which
>> is used on gta04 board and set bypass + acbias.
> Is there a chance to get this series to 3.13? Thanks.

Sorry, I haven't had time to do much reviewing.

The code in omap3-tvout.c should be included in the display.c file,
which already contains some things like muxing. Also, func(bool, bool)
style functions are rather confusing to read. Maybe an enum would be
better, so you'd instead have something like:

func(OMAP_VENC_TVOUTBYPASS | OMAP_VENC_TVACEN)

But the main issue is: while this series probably works well, I really
don't like it that the OPA driver needs to pass bypass and acbias. It
shouldn't know anything about such things. I'm just not certain how to
implement that with the current omapdss driver.

I'll try to find time to think about this more, but I don't think I can
merge this for 3.13.

 Tomi



--uT8p3dMaVFhkCoRJa5DBOdlfE1WFnvCgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSgNumAAoJEPo9qoy8lh71fkAQAKtYe/77ezfI7KXDURRdjqBW
xHV1k6+uzQ8WTCZlb8bGSRnmP2wEmfCQ9o5rQGPoNT0d7fYONfmms5UhM4LFGDHw
n7tcknLe0NjTQjlEicIQcdeYSOPmnlwTs4Ehl2xxcB6a6R5rNSTogoWIxwI+joyR
jRP6dOzK9Bd0SFBr7kcrUCuwSl6OUpB+9aPCP9btu4yZKdpDorsiHFaWlS5IhgMm
fHfLqvYYMSVZlJ0orAhRG6Q7YQ3jjPv21aFVGGLqyf+koiamARMd7mEAJXYEtoIk
dfuxKa2V4ansD1vfz30Y9nmNrj4TDtnV0YITPsO7RPPgWKNwEq9tYH9Uu9KY4TPa
z4i5yyKSXuExUayFRDqozKkd8gvgJn1POsOHvpRZeB3/g8JpmGKCUABNK67P/2x4
fIzidRPyjBFET5p3DxanqeX0lRnBFRGD3guMf+2VVKwe4L7nuK0b+8xa4CoU09zM
uZWomZS5/sZ0DLD20Ms6BeUtDMCzboUTmkxsdMmj/BUt60v2ElXJ2quKTjilJX7V
42fgfhYtbqOzSMG8jN5JLjp9g/YJBJ4lhCu78z6P76doJQ34VZjgNkhqHjkb/cHi
l5DBVqvmc73E5X0Nu3hwvSiU18Fu7FLRdTRRxRbFFJkuAhc6dRu1RL9wgKFAJj7M
gyIjjDBD2hnkFG4n/dLJ
=BZwM
-----END PGP SIGNATURE-----

--uT8p3dMaVFhkCoRJa5DBOdlfE1WFnvCgv--
