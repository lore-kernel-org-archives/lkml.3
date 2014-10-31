Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbaJaLKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:10:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52043 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbaJaLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:10:00 -0400
Date: Fri, 31 Oct 2014 12:09:53 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20141031110951.GB10778@ulmo.nvidia.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <2811016.mhqlsl6pTS@wuerfel>
 <20141030165907.GK32589@arm.com>
 <6420333.oMJU1UYt9n@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <6420333.oMJU1UYt9n@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 09:04:54PM +0100, Arnd Bergmann wrote:
> On Thursday 30 October 2014 16:59:07 Will Deacon wrote:
> > On Thu, Sep 25, 2014 at 02:15:10PM +0100, Arnd Bergmann wrote:
> > > On Wednesday 24 September 2014 18:17:19 Will Deacon wrote:
> > > > Hello everybody,
> > > >=20
> > > > This is version three of the series I've originally posted here:
> > > >=20
> > > >   v1: https://lkml.org/lkml/2014/4/17/269
> > > >   v2: https://lkml.org/lkml/2014/5/22/468
> > > >=20
> > > > This is basically just a rebase on top of 3.17-rc6, minus the alpha=
 patch
> > > > (which was merged into mainline).
> > > >=20
> > > > I looked at reworking the non-relaxed accessors to imply mmiowb, bu=
t it
> > > > quickly got messy as some architectures (e.g. mips) deliberately ke=
ep
> > > > mmiowb and readX/writeX separate whilst others (e.g. powerpc) don't=
 trust
> > > > drivers to get mmiowb correct, so add barriers to both. Given that
> > > > arm/arm64/x86 don't care about mmiowb, I've left that as an exercis=
e for
> > > > an architecture that does care.
> > > >=20
> > > > In order to get this lot merged, we probably want to merge the asm-=
generic
> > > > patch (1/17) first, so Acks would be much appreciated on the archit=
ecture
> > > > bits.
> > > >=20
> > > > As before, I've included the original cover letter below, as that d=
escribes
> > > > what I'm trying to do in more detail.
> > > >=20
> > >=20
> > > I've now applied the parts of your series that are required to have
> > > every architecture provide all the 'relaxed' accessors to the
> > > asm-generic tree, on top of Thierry's series.
> >=20
> > Since these didn't make it for 3.18, would you like me to repost the se=
ries,
> > or do you already have a branch suitable for 3.19?
>=20
> I still need to figure out how to do this right in combination with Thier=
ry's
> patches. Last time I had his patches first and yours on top, and I didn't
> manage to rebase your series when his broke.

Would it help if we merged both series so that we have to rebase only
once? I'd really like to get the asm-generic/io.h series merged soon
because 64-bit Tegra support depends on it and we'd really like to get
started on that.

Thierry

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUU23/AAoJEN0jrNd/PrOhXOwP/1xpWYno5QfE0nWI4HaS9UpL
JU13r3BokKMIkCiqpVOtqOPhcJSBbZwdnyvQTnhjSo689d90VLu8LNgEb+Wf5z48
Ozm+SjJYqBujLm3dXk0tmUcRFIoMeyoNlLVcktT0y2A95akP8+unh11XslRlKGBS
K32iC7LSszuDvjRnFSQ/uPVbAQw12CIIjuHDUv9F8VLRYSdsQnNhYKCrbclJCsrM
w6fCiOsDHgX+5veFY1+HLN0dpWxwRO5XRp8irolFKGCpPVq0h1IhpZkl96K+Y6Oe
RRLwzsc6zr87BPfBVoS/XF0dUXtFe5Mn1d6RhnSUtC8zzoJ6OXrrWvzbY4CRywcE
CsFoubm/WCj7Z0JAh2UmCsGq32M9TbGZ4GbGftVFTt49I870gYjKgAjEZXYOJQUn
ONAyVUTOd0yvDnxYlmyPxfMtC346z4gbIj6UeGlYGAUU7bmOrDFHvlWsgTVzdfid
EPO9+HRMIMioGIfitsGr9yTzMOo5wzi0gU0VLUmOcF3VhwBo+fgwuEp5I73prAeF
OcvvzJpmW0Wz1qDsueHHB5myka8roaZcnbON0zprGgUAv2LoZ4D3yeAWCsSgSiub
8RKwlAOOcrk24scTOCjOWt4TjCF+NwYMfz8YcTb2EQELjqt/CBjQG4NEmEOuxdEE
DsCHYMe5eMlvrrjsvErd
=myce
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
