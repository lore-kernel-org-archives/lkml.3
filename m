Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3BUTnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:43:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36620 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536Ab3BUTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:43:05 -0500
Date: Thu, 21 Feb 2013 19:43:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Shawn Joo <sjoo@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: use regulator name for sysfs
Message-ID: <20130221194302.GA16870@opensource.wolfsonmicro.com>
References: <1361433237-3217-1-git-send-email-sjoo@nvidia.com>
 <51267454.5040607@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <51267454.5040607@wwwdotorg.org>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2013 at 12:24:04PM -0700, Stephen Warren wrote:
> On 02/21/2013 12:53 AM, Shawn Joo wrote:

> > regulator is named by numbering on sysfs, e.g. regulator.0, regulator.1
> > it confuses to find desired regulator before counting the order.
> > add option for regulator name by use_name_onsysfs.
> > if it is true and name is not NULL, desc's name will be the name.
> > e.g. if name in desc is "LDO0", then regulator.LDO0 on sysfs.
> > otherwise it follows origin.

> Does it make sense to make this change always, rather than based on some
> new flag in regulator_desc?

It's certainly insane to change this based on the driver and given that
sysfs is supposed to be an ABI it's questionable if we should do it at
all.  We certainly can't use the descriptor name as that's very likely
to clash if you have more than one PMIC.  Taking a glance through sysfs
on my system what we're doing at the minute is pretty idiomatic, sysfs
isn't really intended for humans but rather for machines to prettify.

> Another place a similar change might be useful is debugfs.

debugfs already uses more human readable names, it uses the supply name
(which is what we should be using if we were going to do anything as
it really ought to be unique already).

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJni/AAoJELSic+t+oim9VfoP/271YcwJcCm1lxCVBfT7IajF
tXzZsxzAy1zrrhzlVwuHkAUh1fuLOP4zaXkyXIbsKFaAvIhrD+PYHuoQXgbpKbZW
jn8BfVOrbVVwqqonRuhsPhyYHt9v34JUa/Vke7af3MXbudaFxny6AZ+vt3gYqDk6
QnnqM+u/veXf+h6/50MAzmH6npo56GppnIC4N03z+Jsdo7G4AOkrWndeuNfZKFCW
qAO0as5JvHmiyHAt1rQJfimYtXwOEKrlNzJx2Uzzf/rdP8jAN7PvU1eTXVLOY9Un
NjhUJbmepQtfx4oIUQNSrhDX9CMz6s6QC6PB5AxV/93OsyDqV5btDrh8tb+tiYQ2
9dcyrPFb+/ME7Yk9ojHMPas4y4pnHnAUxkv3QP27HL673O5F0rUnL8PWLmPZ36fJ
GlpU5x6lzKt6rVmWRK/TU3+pY4Grbgb2v9WgXsJRJFtKSa1zr/4ORhaWCgMP3kQD
hpT/w320o/XXK5jHYNbw88cM0b9Po2gYoHpjijhuhL+6LupU1HrdFnc844pvAvlI
czstskTgtOZz86skVkmM4V0tzpHBwiQi9Fcm8OGNC+ishvB7jJKPLYaUn4x/KmL0
kEedtoNLenUdBGT1EazWftvlAMTUsilqeCz1D9Xk7CwvPnowmYHwd2jpoBsKKK6u
1H0sqZQYv7idTa1md7Fs
=oSzL
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
