Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaGKNCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:02:08 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43471 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaGKNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:02:05 -0400
Date: Fri, 11 Jul 2014 15:01:59 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm64: Use include/asm-generic/io.h
Message-ID: <20140711130158.GA10827@ulmo>
References: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com>
 <201407101514.16530.arnd@arndb.de>
 <20140711121923.GE11473@arm.com>
 <201407111458.09884.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <201407111458.09884.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 02:58:09PM +0200, Arnd Bergmann wrote:
> On Friday 11 July 2014, Catalin Marinas wrote:
> > ioread32() is indeed an alias for readl on arm64 but if the address it
> > gets as argument looks like an I/O port, it adds PCI_IOBASE (via the inl
> > macro). This would no longer happen with Thierry's patches.
> >=20
> > So I guess that for this patch to work, we also need ioport_map() to
> > return an address from the PCI_IOBASE range. Should we merge this now as
> > well:
> >=20
> > http://linux-arm.org/git?p=3Dlinux-ld.git;a=3Dcommitdiff;h=3D3423064d8e=
42a38164a8436bcdf7434cf9cd2192
>=20
> This is also part of patch 1/3 in Thierry's series.

The hunk in my patch 1/3 is missing the "& IO_SPACE_LIMIT", I can respin
and include that.

Thierry

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJTv+BGAAoJEN0jrNd/PrOhyFEP+KqkpdLYOQtehNTGpf9JPtyu
PeptxgaKpNht/2HockC7o4RPJ1OieH/4yhL8FYPnRgsqQX/YvENnn3p6/wZft8yE
jJb3vnL5mC25u/3cyeiXsLm0umsTlE9iRbqSjZ7sIzeG7bGMrkTeHIQ6bNdhtY/S
/XXvbxCKEv53Ud4542Cv6zrk1zDm8l2RSuSQrr9faG605UVEvEmwPsF6UUdlZSDQ
N5mQFhh+HWvQH7v+gciGmXUm4udaa6dbdYijtwpGN1Al4Tp2ChsNSZeHe54gEu95
lXvF4bfru299E+Pi+FBmyN315AI97HEZhB2luc36Ek4qetTBfOVlTrSTBQMVQsZq
u4hDvrFCC8Koc9ElwhYQWS1kZqRPa5P62dQS0Xkf34YnE0NiJ0FuqCPjOmKuDgwo
0M1zalDe5v0Uka3d5u/ddUr4YfPRvN4BltE2VtuiuDiLlXacyZwC2buf4ZIA476T
0NSGdt1eY26X13fMBYZDmFBfVDwHybJ3AiV9VaPpeI7AMovPJeUyRk5V+zX5nssk
/+V0OvHBKP2q3Z/zcYtxgrwTyGGCdp86xP/OxlJcngy0eXbfnIfKm4Mh+20uZfqK
p3v0rNpiH2hU+XsmBiz/oBSXtDAEkzsrmJu12brCSG67/8hF+o3NOD2Fo0OPPPzb
TTwIKEzAC7/DyyVxfjw=
=vJsf
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
