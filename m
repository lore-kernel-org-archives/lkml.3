Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbbAUMPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:15:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36194 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889AbbAUMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:15:05 -0500
Date: Wed, 21 Jan 2015 13:12:02 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David =?iso-8859-1?Q?Lanzend=F6rfer?= 
	<david.lanzendoerfer@o2s.ch>
Subject: Re: linux-next: manual merge of the mmc-uh tree with the sunxi tree
Message-ID: <20150121121202.GF4367@lukather>
References: <20150120141750.3dcade27@canb.auug.org.au>
 <CAPDyKFq4TyiadznYCM-dGmeu799vWevBt1XVZ4DALhv-3bP=AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y18yPE/eBgOv3N1p"
Content-Disposition: inline
In-Reply-To: <CAPDyKFq4TyiadznYCM-dGmeu799vWevBt1XVZ4DALhv-3bP=AA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y18yPE/eBgOv3N1p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 21, 2015 at 12:27:09PM +0100, Ulf Hansson wrote:
> On 20 January 2015 at 04:17, Stephen Rothwell <sfr@canb.auug.org.au> wrot=
e:
> > Hi Ulf,
> >
> > Today's linux-next merge of the mmc-uh tree got a conflict in
> > drivers/mmc/host/sunxi-mmc.c between commit 6c09bb851e57 ("mmc: sunxi:
> > Convert MMC driver to the standard clock phase API") from the sunxi
> > tree and commit 776e24c502da ("mmc: sunxi: Removing unused code") from
> > the mmc-uh tree.
> >
> > I fixed it up (the former includes the latter change) and can carry the
> > fix as necessary (no action is required).
>=20
> Maxime,
>=20
> I can't find the sunxi tree, is it listed in MAINTAINERS?

No, it's not, I should probably add it :)

It is here: https://git.kernel.org/cgit/linux/kernel/git/mripard/linux.git/

> I know I have acked below patch, but that was quite a I while ago. Is
> there any reason to why I can't take it through my mmc tree at this
> point?
> "mmc: sunxi: Convert MMC driver to the standard clock phase API".

It still is needed to preserve bisectability, which is why you acked
it in the first place. Otherwise, you would end up with a build
breakage in the clock tree, because the mmc driver would still use the
removed custom phase functions, and a failing MMC driver in your tree
because the MMC clocks would not have the phase callbacks implemented.

It's a pretty wide window of failure, and especially for the build
breakage, I don't think it would be wise to split these patches.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Y18yPE/eBgOv3N1p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUv5eSAAoJEBx+YmzsjxAgEccQAIjze+3pVxO+fjTrLHi5QihR
RV8KDOf0K9zSkOromZgy/C2c8CHP6ogdpim+ApHdvuJgCDbuwUj0wLfsXG6kCXpj
oKbEr5Uh7096zmpNhSvSy6425DXxKUCsb10Hl5j7UH5LCOAEXyJMEiOwzb0vqDJK
F8dS2x0U2zlQ1EZ9Cmrhj+enGApGEf1mSrnLfU906hnQ7tgfd2zIiELI6PSu4aEs
lx48gPwvH80JGywx247ihgNajU9SOJ5E1zzPnvhSghuIyOsOXrqGQyHrDeaBO0m1
ChT52ROvTedzDU479U1IWsjFxTX+zOxZf4WsCpl/wtBLHHgU8uONd5Xu7xeRiNDR
lLtSsw5Co6Uacg33Q/x4chYrWxajcsFzrlm9qaFbsZoVbfpB3H9j5UFY78ZBEgX+
7voj8VasrAWt+JaGU8bfSPIHagLxc+kcvz2cn+Ju8pR4C7/4fjY5zbdl3bxeORet
kmYdONgNHOnNIOFgQX7JV/BnuBBnGXtpVeBUg4BDX0nf711OXvo00mAhiOkbOl7+
NHnb0ZN3Cz6P1VFLO4tJrHK3LB/06qeWE6H5358qEvjknhvr1ypnhhPI9F9YbCC3
h1xu3uCWZLk3Kip02Ie+zw+KmMMnq5ONvfzDaZ8nof/RZk8HsEqJv3Uzy23LvypE
JAgXFKiJ5Cjm6ZPj8Vex
=Uw3O
-----END PGP SIGNATURE-----

--Y18yPE/eBgOv3N1p--
