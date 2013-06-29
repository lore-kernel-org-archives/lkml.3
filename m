Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3F2SHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 14:07:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35843 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3F2SHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 14:07:33 -0400
Date: Sat, 29 Jun 2013 20:07:30 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130629180730.GI2593@lukather>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
 <20130628200333.GA2756@lukather>
 <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
 <20130628214512.GA11985@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J+eNKFoVC4T1DV3f"
Content-Disposition: inline
In-Reply-To: <20130628214512.GA11985@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J+eNKFoVC4T1DV3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 10:45:12PM +0100, Lorenzo Pieralisi wrote:
> On Fri, Jun 28, 2013 at 09:05:42PM +0100, Olof Johansson wrote:
> > On Fri, Jun 28, 2013 at 1:03 PM, Maxime Ripard
> > <maxime.ripard@free-electrons.com> wrote:
> > > On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> > >> On Fri, Jun 28, 2013 at 05:44:02PM +0100, Maxime Ripard wrote:
> > >> > Hi Arnd, Olof,
> > >> >
> > >> > Sorry for steping in so late, but these two patches fixes a warning
> > >> > introduced by the commit 1ba9bf0a (ARM: 7762/1: kernel: fix
> > >> > arm_dt_init_cpu_maps() to skip non-cpu nodes) after 3.10-rc7.
> > >> >
> > >> > These two patches solve the situation for sunxi. The first one by
> > >> > Lorenzo is to be applied for 3.10 if it's still possible, and the
> > >> > second one on top of arm-soc/for-next. Tell me if you prefer a more
> > >> > formal pull request for these patches
> > >> >
> > >> > Thanks!
> > >> > Maxime
> > >> >
> > >> > Lorenzo Pieralisi (1):
> > >> >   ARM: dts: sunxi: cpus/cpu nodes dts updates
> > >>
> > >> The patch above should already be queued in next/dt right ?
> > >
> > > Indeed.
> > >
> > > Then why the latest patch of your patchset got in 3.10, while the
> > > patches actually fixing the DT it would have impacted were delayed to
> > > 3.11?
> > >
> > > (And why was it merged so late in the development cycle?)
> >=20
> > This. So now we have to scramble because some device trees will
> > produce warnings at boot.
> >=20
> > Russell, the alternative is to revert Lorenzo's patch for 3.10 (and
> > re-introduce it for 3.11). Do you have a preference?
>=20
> Ok, sorry about this guys. Technically speaking the DT bindings updates
> (cpu/cpus nodes), dts updates and the ARM 7762/1 merged through Russell's
> tree all are fixes, but probably we should not get them in as such.
>=20
> ARM: 7762/1 was implemented to fix the warnings caused by new dts with
> topology nodes (cpu-map node), and should go to stable kernels as well
> since we want those kernels to boot with new DTs.
>=20
> I should have prevented it from getting in as a fix, I really apologize.
> I should also ask to drop the patch from the stable kernel queues, since =
this
> would cause further issues (basically we should send all dts updates to
> stable kernels as well, and unfortunately that's something we will have
> to do anyway, when it has to be decided, if 7762/1 goes in 3.11 or later =
with
> CC'ed stable we should send the dts updates to stable as well at the same
> time).
>=20
> I think the best solution is to revert ARM 7762/1 now and re-introduce it=
 as
> a fix after 3.11, when the dust has settled, I will drop it from stable
> kernels queue as well if we all agree.
>=20
> If we drop ARM 7762/1, 7764/1 needs rebasing since those patches order
> unfortunately matters.

Ok, so you're saying we need to revert 1ba9bf0a and 7764/1. I couldn't
find a commit corresponding to this one, however there is a commit
labelled 7763/1 from you that touch the same area (18d7f152). Are these
the commits that need to be reverted (and then reapplied for 3.11) ?

Russell, Arnd, Olof, who should revert this patch, and through which
tree?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--J+eNKFoVC4T1DV3f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzyJiAAoJEBx+YmzsjxAgosAQAI7cYE+Tw+vbB+cZa+n4zJJQ
ZqkJTGAmjqTKS+4acJ0zrpO0udxZw91csXTdi327udR91L0bqpGHBQBKypYcuKhL
ZS5jG6QIs8qZSjzwrMfrvV9aMqt+zSfDfJgrYuPdW78tXEmS/8tKHVil91yevqZA
dkS4JE3q5LnDQaFoYvZq3mJ4+vOSgBEEUtlFjYZgd6gM2CvFAasNK7NTatTl8uH9
Xaor+CI81JYfCHVQ6Ajgeccgbn0nk6EzosTtLCXCtRxooArWJsy04F9xCYKVYezE
Qs7Ga5mg4CuugMGcuUvQ+kzGPS7ZYsRisC5LfFat5jX9cvufgg89Zdc9uGlfi7ng
HUkPAMTSnHUT37wEhttjNeuz97oTJgaj8Fsvzf+IKQMSi5wunxGsnbi0h1kSpvcQ
4sC3AbdgrWLU6q/4Wr/dx0ZekDh5p6hVsZ3qbWO3FJAsU7DCQ199V8u2sEdPs5aF
euP2SA0bvS/zUal9TickNm2qTK8QPrOwsP0Wri/PJp1sMiZiNrKBRjsj1CVVsRhP
n+6pJtcO+pzPzDm+mcmQxnohVgNkoEVP6WqNT9HUYnCR+IVOA9wLd3CK9ylEy+JU
41T1KzrsUKJABe/bBVhqqhWDOl5vD5j+OwOP7q0VXDNR99BZ8Q+cBwRyXOp7RCaY
iiqoK7TVQNDIlcu3dqbc
=5KgB
-----END PGP SIGNATURE-----

--J+eNKFoVC4T1DV3f--
