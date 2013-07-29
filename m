Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3G2F4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:56:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40583 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3G2F4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:56:18 -0400
Date: Mon, 29 Jul 2013 15:56:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the spi tree
Message-Id: <20130729155609.bb9d635427d8eef1da954e3a@canb.auug.org.au>
In-Reply-To: <20130729050011.GJ9858@sirena.org.uk>
References: <20130729134223.bbae9d9f2a9cd6ca1717c976@canb.auug.org.au>
	<20130729050011.GJ9858@sirena.org.uk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_15_56_09_+1000_76k97KRii/DMK2cu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_15_56_09_+1000_76k97KRii/DMK2cu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, 29 Jul 2013 06:00:11 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Jul 29, 2013 at 01:42:23PM +1000, Stephen Rothwell wrote:
>=20
> > drivers/spi/spi-pxa2xx-pxadma.c: In function 'wait_dma_channel_stop':
> > drivers/spi/spi-pxa2xx-pxadma.c:136:2: error: implicit declaration of f=
unction 'DCSR' [-Werror=3Dimplicit-function-declaration]
> >   while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)
>=20
> > Frankly, Mark, if you are unable or unwilling to do some basic cross
> > build testing, please do not do any more of these patches that add
> > CONFIG_COMPILE_TEST.  Leave them to someone who can.
>=20
> This was cross built.  It didn't show up due to the fact that the
> minimal configs I use for build coverage (and in fact every single
> config I was building) didn't have PCI turned on (which is a dependency
> for this option actually building anything) which allowed this config
> symbol to be enabled without showing the problem due to the slightly odd
> way the config for the driver is structured; any system with PCI that's
> not PXA would be affected.
>=20
> Most (though not all) of the other issues have been due to similar
> stuff.  I do rely on the 0 day tester for the full builds but I do pretty
> routinely test (especially on x86) these days though with minimal
> configs and on my full working tree.

Did the 0 day tester find these?  If so, then maybe you should wait a
while longer before adding these things to your published trees.  If not,
then I wonder why not.

Even so as a developer, you should not really be submitting patches that
have not been at least build tested.   You can find out which files are
affected by these config changes and then really simply do:
(assuming an x86 native platform - adjust for cross compiling)

$ mkdir ../test.obj
$ make O=3D../test.obj allmodconfig
<make sure that the CONFIG options got turned on>
$ make O=3D../test.obj <files affected s/.c/.o/>

You don't need to do full builds to find most of this stuff.  Of course,
this will not find link time errors or missing module symbols.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Jul_2013_15_56_09_+1000_76k97KRii/DMK2cu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9gP9AAoJEECxmPOUX5FEUnMP/io/BBkFTS+XKzmzusE/+x+W
AVsBizL5RizO5rvpg0TY6OYzchP7+08pt3FwKs70XlGhXLan2bBmp0bSqUbxqrIN
kz3VZjnddno6hDCewH6YMgENVsbnXb6PScDhhv9++zRIy00uD3XCxniBUzNfFT8J
dVR3/fCrpYEIZ6hbj7X65vgdRCdYs5/lO4NqvLROePQizt6LeS9NH7Tazc2faLYz
r+1uXqw7Srgr9XLJwp7a35ePpeWKJUprQAYMa7dl2hWAPu2xgjtfD+SNQraAFg0N
hn3N4pjgNqDQjRuMZc6XK+zDcTdQvnbf9uY4n2PjqG2ZfHC4hjw/gheUZ9pTkZ59
iVjXE0AGG/YBq2GeXEA8Il/wfaJc9zC+EB/HH+4KYYXG/1R0UcllVBvChGC2MNqc
SPSH5KMuHIQdIj/a1t1/r02m/kADiBoafHk95Zwb0nJTqOi/qK5ubb5Q4zpcO1No
jd/ZdgDauF8chH2a+8j/u/agxR9617RIklvuUmee2zzBIm1y0qfAe8TfEEYRF/t9
HKMIjhT2VEkWV2uehSsf/9+eTr7dejTSj2jrJoK5t4YFyZNbFgfglW+WqrmsH8Iw
OG8I1NwwXGWTlnZdg500Tsz2n0i/A/ftRyOIHRFotpNFxHZSpXHysKNCe4XyBqED
6i52mEC1yiZpKAY7XlFH
=8Mu9
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_15_56_09_+1000_76k97KRii/DMK2cu--
