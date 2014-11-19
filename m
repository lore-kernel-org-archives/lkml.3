Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaKSVor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:44:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbaKSVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:44:45 -0500
Date: Thu, 20 Nov 2014 08:44:31 +1100
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Balaji T K <balajitk@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>,
        Venkatraman S <svenkatr@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 0/3] mmc: omap_hsmmc: make more use of mmc library
 functionality
Message-ID: <20141120084431.7a2220bc@notabene.brown>
In-Reply-To: <CAPDyKFr=vjh5UOzkrbn7Fpm8j97sqf6xxD7tm+HydOKtyeYKoQ@mail.gmail.com>
References: <20141107234628.4923.60525.stgit@notabene.brown>
	<CAPDyKFr=vjh5UOzkrbn7Fpm8j97sqf6xxD7tm+HydOKtyeYKoQ@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/H=w4tjHKMTzb/RuIgp.QGOA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/H=w4tjHKMTzb/RuIgp.QGOA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Nov 2014 11:14:24 +0100 Ulf Hansson <ulf.hansson@linaro.org> wro=
te:

> On 8 November 2014 00:52, NeilBrown <neilb@suse.de> wrote:
> > omap_hsmmc currently duplicates some work that can be done for
> > it by common code, and consequently does not benefit from extra
> > functionality in that common code.
> >
> > In particular, mmc_of_parse and the slot-gpio library are not used.
> >
> > This set of patches allows omap_hsmmc to use that common
> > functionality, and benefit from any extra devicetree parsing
> > that it performs.
> >
> > The one awkward part of this change is that omap_hsmmc has an
> > interrupt handler for 'card detect' which does more than the
> > common code.
> > I see three options:
> >  1 - move that functionality into common code
> >  2 - discard that functionality
> >  3 - allow the common code to be configured to use a device-specific
> >      card detect interrupt.
> >
> > This series implements '3'.  I suspect a mix of '1' and '2' would
> > be a better choice but I know no of the history or justification
> > for those differences.
> >
> > My preference would be for this series to be applied (if there are
> > no other issues) and if there are opinions about effecting '1' or '2',
> > they can be done with subsequent patches.
> >
> > Thanks,
> > NeilBrown
> >
>=20
> I like the looks of this patchset, but it needs a rebase.

Thanks.  What should I rebase against?  Is 3.18-rc sufficient or is there
some other tree I should work against?

Thanks,
NeilBrown

>=20
> Kind regards
> Uffe
>=20
> >
> > ---
> >
> > NeilBrown (3):
> >       mmc: omap_hsmmc: remove prepare/complete system suspend support.
> >       mmc: omap_hsmmc: use slot-gpio library for gpio support.
> >       mmc: omap_hsmmc: use mmc_of_parse to parse common mmc configurati=
on.
> >
> >
> >  drivers/mmc/core/slot-gpio.c           |   21 ++++
> >  drivers/mmc/host/omap_hsmmc.c          |  158 +++++-------------------=
--------
> >  include/linux/mmc/slot-gpio.h          |    2
> >  include/linux/platform_data/mmc-omap.h |    4 -
> >  4 files changed, 47 insertions(+), 138 deletions(-)
> >
> > --
> > Signature
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/H=w4tjHKMTzb/RuIgp.QGOA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVG0PPznsnt1WYoG5AQL1CRAAiyq+USFIPgRFmSfmWsLBb+jUXWQw9WUL
wj044A4rtK/deuEWqzQfodo23bZvi/3s64Q70VbgBMCsu20sAj0Vc2Of1gi6KSqk
x5z3ic/HcWUNWlN5RnkoR0vR6Bj98dj4lMBOryw5gNW2FfZ8by1Wu8qcmwUHffsS
Rvo5GPzzVW9kLdkJUVBb1lxB8KYv27Fh/3ca3Bts9TJAQh5HzBGgGl/4+XWLDTkB
/YSiqxPEwbdw6bw6mOEcPvQ970jFjWbFrHWJXciK2Wv38x55arq4hKa5NcMRY+f/
xH6o9n0LrGIYKYgpdgimMLG7vW8p9kzJ19v9jxMlzW1urXWsrOuKfky/hdeMq2jn
QtkepdrajTn8K0E72TKiLCc3scXQcsqs+5JhSg5ILnSJMb2qTDNR1vNM3Z6b/mp+
4a7P2ULI5kGETKXxrAgjwFdHW+jkLw/I5GT0PQrovfLuLoSu5HkaGmwoKRbPNE8S
cBjeng79RhR9EBnbgeYgulGWQ5iYc7FIVT9Alie8FYkox+F/9ZHrQF7p81u5dIhp
+LsbWNUtScCm6e557V4mzgyQ8LA5Nlh9G6hYxgutslXDbDtaQJ/3Mo8uK79AFQ8n
FK//Y6iMfTxCZLzk8KYCKLDFbeAdgfBp7DtO9mGtdmNv/KleFZ4iX+kgwpsOemO4
0haZeQek7t4=
=y1zT
-----END PGP SIGNATURE-----

--Sig_/H=w4tjHKMTzb/RuIgp.QGOA--
