Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaEMHBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:01:39 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46119 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEMHBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:01:38 -0400
Date: Tue, 13 May 2014 08:59:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>, Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm_lpss: Add support for PCI devices
Message-ID: <20140513065935.GA6754@ulmo>
References: <1397311131-13371-1-git-send-email-chiau.ee.chew@intel.com>
 <20140512231816.GA65896@dvhart-mac01.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20140512231816.GA65896@dvhart-mac01.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 04:18:16PM -0700, Darren Hart wrote:
> On Sat, Apr 12, 2014 at 09:58:51PM +0800, Chew Chiau Ee wrote:
> > From: Alan Cox <alan@linux.intel.com>
> >=20
> > Not all systems enumerate the PWM devices via ACPI. They can also be ex=
posed
> > via the PCI interface.
> >=20
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > ---
> >  drivers/pwm/pwm-lpss.c |  160 ++++++++++++++++++++++++++++++++++++++--=
-------
> >  1 files changed, 129 insertions(+), 31 deletions(-)
[...]
> Has this landed anywhere? I didn't see it in mainline or next, am I looki=
ng in
> the wrong place?

This was applied to the pwm/for-next tree and has been in linux-next
since next-20140429.

> If it's just still pending, I ran into one issue integrating it
> with 3.14.2:
>=20
>   CC [M]  drivers/pwm/pwm-lpss.o
>   drivers/pwm/pwm-lpss.c: In function =E2=80=98pwm_lpss_probe_pci=E2=80=
=99:
>   drivers/pwm/pwm-lpss.c:192:2: warning: passing argument 3 of =E2=80=98p=
wm_lpss_probe=E2=80=99
>   discards =E2=80=98const=E2=80=99 qualifier from pointer target type [en=
abled by default]
>   drivers/pwm/pwm-lpss.c:130:30: note: expected =E2=80=98struct pwm_lpss_=
boardinfo *=E2=80=99
>   but argument is of type =E2=80=98const struct pwm_lpss_boardinfo *=E2=
=80=99
>=20
> Can we make the third argument to pwm_lpss_probe a const? The following is
> working for me:
>=20
>  static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
>                                              struct resource *r,
>                                              const struct pwm_lpss_boardi=
nfo *info)

A fix like that was applied last week and is in next-20140512.

Thierry

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTccLXAAoJEN0jrNd/PrOhNBwP/1s/0nurgaPdeXtNgukQsPMg
jJcbjG5/nzSAD/rxfSyyrDf+2mjTkmEui0a8RmTfsRDObPMhGLNiEtfQ7yiNGfkw
5JXbift58fv2jpmCsYXpIOihEgBUZD5jUzgMxJPnJyg6zS05beHbM799a76fyXVn
ulruyGqcFlwP6PgCl1Ltf36BbMryz2ftzPn9Z5oTGTGBQI7IHxktFCr86sBSrjeP
8bwVL2sCOvGcrzCWeFlAGDFiwv32yhT5UtjcphXDI7VEnMAZTMwiRVgUE/Qs7oKi
jDli+CkTGuWyxJjQhKEIDHS9EPs8dIePmOinO8w3xUnyoDzL36bzJeTDEAZOsL0P
q7kd9dc0Y+UD6996PC7ECFZOXYoTdfQhLp4kORYhLuKIo7TfJhd4HW9NOU5O/QcK
90us8YYqkszXW1dWOh0pDzVh29LomF7ScwhsxGPfPTrmwQi36XjX3ZE3NeCBCHWm
AllwvQPosA/A/w/VxQY/c77Ex3jW4w6TaGhyHTdBKwcg3kDqP6PPZlfdwgfdmWOS
w9eOxnZMNsv8XL9KkIBvLa/dy5lQVsbVHwPTOrZTU2u2QD3fdIyR5ja6SpjTyaO6
DcK1MJ9HoTHKIms48olaKJf22LIqHbmGk88pBCER35/UZqyQSAGGqfrXkIDR5okz
8YXKzgdI3sW3up0a3012
=uCRe
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
