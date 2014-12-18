Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaLRLNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:13:43 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59243 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaLRLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:13:39 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 2/3] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Thu, 18 Dec 2014 12:13:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412101250.13891@pali> <548853CB.7000704@roeck-us.net>
In-Reply-To: <548853CB.7000704@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1511995.XDp1mBtrhd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412181213.36143@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1511995.XDp1mBtrhd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 10 December 2014 15:08:11 Guenter Roeck wrote:
> On 12/10/2014 03:50 AM, Pali Roh=C3=A1r wrote:
> > On Tuesday 09 December 2014 23:42:08 Guenter Roeck wrote:
> >> On Tue, Dec 09, 2014 at 09:23:22PM +0100, Pali Roh=C3=A1r wrote:
> >>> On Tuesday 09 December 2014 21:20:23 Guenter Roeck wrote:
> >>>> On Tue, Dec 09, 2014 at 09:07:00PM +0100, Pali Roh=C3=A1r=20
wrote:
> >>>>> This patch adds new function i8k_get_fan_nominal_rpm()
> >>>>> for doing SMM call which will return nominal fan RPM
> >>>>> for specified fan speed. It returns nominal RPM value
> >>>>> at which fan operate when speed is set. It looks like
> >>>>> RPM value is not accurate, but still provides very
> >>>>> useful information.
> >>>>>=20
> >>>>> First it can be used to validate if certain fan speed
> >>>>> could be accepted by SMM for setting fan speed and we
> >>>>> can use this routine to detect maximal fan speed.
> >>>>>=20
> >>>>> Second it returns RPM value, so we can check if value
> >>>>> looks correct with multiplier 30 or multiplier 1 (until
> >>>>> now only these two multiplier was used). If RPM value
> >>>>> with multiplier 30 is too high, then multiplier 1 is
> >>>>> used.
> >>>>>=20
> >>>>> In case when SMM reports that new function is not
> >>>>> supported we will fallback to old hardcoded values.
> >>>>> Maximal fan speed would be 2 and RPM multiplier 30.
> >>>>>=20
> >>>>> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >>>>> ---
> >>>>> I tested this patch only on my Dell Latitude E6440 and
> >>>>> autodetection worked fine Before appying this patch it
> >>>>> should be tested on some other dell machines too but if
> >>>>> machine does not support i8k_get_fan_nominal_rpm()
> >>>>> driver should fallback to old values. So patch should
> >>>>> be without regressions.
> >>>>=20
> >>>> It looks like many of your error checks are unnecessary.
> >>>> Why did you add those ?
> >>>>=20
> >>>> Please refrain from adding unnecessary code.
> >>>>=20
> >>>> Guenter
> >>>=20
> >>> Which error checks do you mean?
> >>=20
> >> There are several you added. I noticed the ones around
> >> 'index', which would only be hit on coding errors. At that
> >> point I stopped looking further and did not verify which of
> >> the other added error checks are unnecessary as well.
> >>=20
> >> A quick additional check reveals that the fan variable
> >> range check in i8k_get_fan_nominal_rpm is completely
> >> unnecessary - if the range was wrong, the calling code
> >> would fail as well, since you unconditionally write into
> >> an array indexed by the very same variable. Given the
> >> simplicity of the calling code, it can even be
> >> mathematically proven that the error condition you are
> >> checking can never happen.
> >>=20
> >> With that I really stopped looking further.
> >>=20
> >> Guenter
> >=20
> > Should I remove those access out-of-array checks?
>=20
> If you want me to look into it further. In general, I don't
> accept code like this, since it increases kernel size for no
> good reason. It also makes it more difficult to find _real_
> problems in the code since it distracts from seeing those.
>=20
> Guenter

Ok, I will rework this patch and drop that first cosmetic.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1511995.XDp1mBtrhd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSStuAACgkQi/DJPQPkQ1J6ZgCgq93tIgluca1rd7MHRy5KThMF
c5cAn3ie1X64U+6F2fq/EmgtWZrRz0mw
=fs7R
-----END PGP SIGNATURE-----

--nextPart1511995.XDp1mBtrhd--
