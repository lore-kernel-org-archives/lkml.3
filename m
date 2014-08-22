Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaHVWP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:15:59 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47572 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaHVWP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:15:58 -0400
Date: Sat, 23 Aug 2014 00:15:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the pwm tree
Message-ID: <20140822221540.GC24037@mithrandir>
References: <20140823070737.371f09fb@canb.auug.org.au>
 <20140822220610.GB24037@mithrandir>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <20140822220610.GB24037@mithrandir>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 23, 2014 at 12:06:16AM +0200, Thierry Reding wrote:
> On Sat, Aug 23, 2014 at 07:07:37AM +1000, Stephen Rothwell wrote:
> > Hi Thierry,
> >=20
> > After merging the pwm tree, today's linux-next build (powerpc allyescon=
fig)
> > failed like this:
> >=20
> > drivers/pwm/pwm-lpss.c: In function 'pwm_lpss_config':
> > drivers/pwm/pwm-lpss.c:81:2: error: implicit declaration of function 'r=
eadl' [-Werror=3Dimplicit-function-declaration]
> >   ctrl =3D readl(lpwm->regs + PWM);
> >   ^
> > drivers/pwm/pwm-lpss.c:87:2: error: implicit declaration of function 'w=
ritel' [-Werror=3Dimplicit-function-declaration]
> >   writel(ctrl, lpwm->regs + PWM);
> >   ^
> >=20
> > Caused by commit 28160b18787b ("pwm: lpss: Properly split driver to
> > parts").
> >=20
> > I have reverted that commit for today (and 06c7b5394e21 ("pwm: lpss:
> > pci: Move to use pcim_enable_device()") which depends on it).
>=20
> Ugh, that's unfortunate. I have a set of scripts I use to build-test
> before pushing, but I don't usually do full allyesconfig builds. It
> seems like pwm-lpss.c might only be missing a linux/io.h include. It
> will likely be Monday before I find the time to properly test and fix
> this, do you want me to remove the commits from the pwm/for-next branch
> so you don't have to revert it again?

Just confirmed that adding a linux/io.h include fixes the build. Will
push a fix in a minute.

Thierry

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT98EMAAoJEN0jrNd/PrOhxNEQAKAuhTODMFZKeZKSTQfJI8Ck
KbofA4MZTvsAtQb1BqS3uev5HY84OOddnAk4YI+T+0cdFCOgY6yrWFPWs7R9ejf/
WfZViMt4c06xs/137UCORLCkl+SOzhDDwaWnI5emEERaKPhqOXcnsxTJHQ5I97Zu
aRjDkJW08SP0BRNWAZ3MKmmWcJW1qrTBHtZ6sveNTVtOGZDF5DMdwQoQ85IhAa+x
enxvueqWf2e3JDf6sOiIq+0NfHHF9uC/Kj5omqGzN+wskYGMEn7aIljcr8RYUuWh
MmUuiTuJxchE2ek5C1AjdjYMfH82FUUze7rzqF0EdIW8huCC7KTVM5iRiGjNeX4z
W1FzSVy3GvvUzSlj0vG+2TlxWYjLWPCPGojhKNgDyqqdDk6fgUcfvWgo272Fo+Ys
4DPF638T3NyZBZ12v9AQEhN0hpI2je/KPafLipOZ03OSOzGIU0QlAqUdSwd/keFJ
Ss1ZRUnQFYMJtA9t+ptjMtqcq8fLQSj4AXDk8S4h4mAueURQnIgd14F5r90TNeV+
3p2fdVDt2WF8OqFjqt4a2n6iK/qJwE2p4XAXp4yLDfoO8UpIWqDKiWPjoe0awx4y
Efr9Nb73TqiNOZMlxD5zv24dnaQSXz5NrXU7+ytD1CWYopOS9nihdYZjUT2xFjMb
vl2YPRp/BF4EF63Uzn/P
=dcys
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
