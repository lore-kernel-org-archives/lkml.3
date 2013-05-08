Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3EHGFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:05:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55703 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3EHGFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:05:42 -0400
Message-ID: <5189EAF2.5020406@ti.com>
Date: Wed, 8 May 2013 09:04:34 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com> <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com> <20130506213413.GH5634@blackmetal.musicnaut.iki.fi> <20130506223653.GA12089@obsidianresearch.com> <51884971.9050508@ti.com> <20130507003651.GA26035@obsidianresearch.com> <5188FE54.6050200@ti.com> <20130507182711.GB28628@obsidianresearch.com> <20130507190628.GI5634@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20130507190628.GI5634@blackmetal.musicnaut.iki.fi>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2CMLHLASCCPTAHMHHTLKW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2CMLHLASCCPTAHMHHTLKW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/05/13 22:06, Aaro Koskinen wrote:
> On Tue, May 07, 2013 at 12:27:11PM -0600, Jason Gunthorpe wrote:
>> On Tue, May 07, 2013 at 09:15:00AM -0400, Eduardo Valentin wrote:
>>>> But broadly the direction seems that drivers should have minimal
>>>> dependencies so, eg, the thermal maintainer compiling for x86 should=

>>>> be able to compile test/static analyze your driver..
>>
>>> Well, I do not see much of this attempt actually. Do you have some li=
nk
>>> / evidene that shows someone who actually cares about compiling drive=
rs
>>> for targets that they are not used for? On this specific driver, I
>>> actually have  had exactly the opposite advice [1]. I am not convince=
d
>>> people actually want to do that.
>>
>> There was a discussion a bit ago, but I can't find a link.. The
>> context was subsystem maintainers are being asked to look after more
>> code with the DT transition moving things out of arch/arm and at least=

>> one complained they couldn't even compile test on x86... But again, I
>> can't find a link and you are right, there are lots and lots of
>> 'depends ARCH..' style things in kConfig already.
>>
>> Lets just call it something to think about.
>=20
> Tomi started a thread related to this recently:
>=20
> 	http://marc.info/?l=3Dlinux-kernel&m=3D136731558332265&w=3D2
>=20
> I think there's some good reasons listed there, but I guess up to the
> subsystem maintainers to decide what they prefer.

As Sam pointed out in that thread, there's no need to change the Kconfig
language for this. I did some testing with fb drivers, by having a
CONFIG_ALL_FB_DRIVERS option which "removes" the arch dependencies for
some fb drivers.

It does uglify the Kconfig files a bit:

-       depends on FB && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
+       depends on FB && (SUPERH || ARCH_SHMOBILE || ALL_FB_DRIVERS) &&
HAVE_CLK

I'm still undecided if I want to pursue this with fb drivers, as it
seems that quite many of them do really depend on the arch code, and I'm
not interested in trying to fix them.

But if other subsystems would benefit of this also, perhaps we could
have a common CONFIG entry that would allow compiling a driver on any
arch. I just can't think of a good name for the config entry =3D).

 Tomi



------enig2CMLHLASCCPTAHMHHTLKW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRier2AAoJEPo9qoy8lh71WEMP/1iK+iuUonTrFCWslx+GIbv7
VDkEhmm5u7rAeUVeJXx5BeGNk6sJ2yzINrAcpY6nCyDfE/QYdvEl05Pm/gFDnnzR
N0AP9O3+B+eFTePrLAPYSnduhH2a0dTuVJK9AUYYs6rTyofqXKdmZGKnBbu3ytfD
f6RYjuVP1Nyb6826tq1Ddi+vIKJmM97T0/J5STSlyFxQduy0bQuE+gGk04kdOMrm
BTCU/ofiFlptgRIPAZkkSCJN0h9nmdC4maqgzy3utgd4hzAf8CRCFei628kOyTeW
5LB+pRdg0cR3n1q9v2hSCkjgvgDqr2IkQnZdeEeC3o4Uz79AEJPG4aODODXh3Irj
O4jEb2b9V3oEyRrhSwTR61fMkpDEYMb88wdrFMyHMqKbqM4etaRzmC10QKZNW3jK
9GsE+WLvPR3cOUN1HLGrDS8NBCV4hqaoCe5gjnsX+iKpxESrDEJPSscqoWTD9q3e
aMJjwLOq4D6VjirP9aq7jZgK7KKEHuBPK4FeXAAZ57DXwyMzYvT32h2/lC+UAgLq
gMfabboxRxhdT1OF5RyJzHO9fbww9XqQnp/Fnqe8mwF+si3Bny+76TNxKu4nohXs
mKd2Pky1lCINjlrm/7vConSCzm/1u40JIcsltJRsHexHlvL+61DQ02czqoA4SQ42
0cRDqTeUFeUk+yOHTdAX
=/bma
-----END PGP SIGNATURE-----

------enig2CMLHLASCCPTAHMHHTLKW--
