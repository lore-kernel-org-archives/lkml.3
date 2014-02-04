Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaBDSSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:18:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35398 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaBDSSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:18:38 -0500
Date: Tue, 4 Feb 2014 18:18:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140204181831.GP22609@sirena.org.uk>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
 <20140204110531.GR22609@sirena.org.uk>
 <CAJAp7OjCnJ=P9Gi20=D9gybREiSaqd1CaQ0K=9fGbCzU1gTFLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hze9XmyoPo8YE0yg"
Content-Disposition: inline
In-Reply-To: <CAJAp7OjCnJ=P9Gi20=D9gybREiSaqd1CaQ0K=9fGbCzU1gTFLw@mail.gmail.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Make regulator object reflect
 configured voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hze9XmyoPo8YE0yg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 10:02:14AM -0800, Bjorn Andersson wrote:
> On Tue, Feb 4, 2014 at 3:05 AM, Mark Brown <broonie@kernel.org> wrote:

> > Why not do this at the time we apply the voltage?  That would seem to be
> > more robust, doing it in a separate place means that we might update one
> > bit of code and not the other or might change the execution path so that
> > one gets run and the other doesn't.

> I do share your concerns about having this logic mirrored here is
> risky, unfortunately the regulator object is created upon request from
> a consumer; so it is not available when regulator_register() calls
> set_machine_constraints().

Oh, hang on - that's what you mean by a regulator object...   I don't
think this fixes the problem you think it does.  What is the actual
problem you're trying to fix here?  The min_uV and max_uV on a consumer
struct are supposed to be the request from that consumer, they should
only be set if the consumer actually made a request for a voltage range.

> An alternative is to drop the conditional setting of
> REGULATOR_CHANGE_VOLTAGE from of_regulator.c and force the regulator
> drivers to set this flag explicitly; to avoid the difference in
> behavior depending on configuration.

Why would having each individual driver open code things help?

--hze9XmyoPo8YE0yg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8S70AAoJELSic+t+oim99YQP/1BxdeK2mjtBUDtyq/VwrPsC
Wen5LfTOtKdvHr/jf3YW+JqEKhHYXnsqWrWnwddBOGfuAFH8EWPdBrz0Rm4zukpZ
84gamGSry3Sb2l/E8aDIN8wRXc2ZgzB3cN8ExaK8ihWdUnJiI1VlsqcGEUwzElTX
0U/pw9oJKY8S7X18uddvMlBN/kEIv/BWH4ZWb1Sfoe0DJBwf+UmvHNkHi+setLs5
B93eV3ucwmxAmgI3nekqiokPXD6o8adB9BP2lH/vHC5fGcwM4rrbyJmynT/Vye77
EmtXVQWhTKlc+cPlyQobeyOVXZykUU3HLxyHeTkyUXZQkJYNP87W3ZmaciVAkN/2
en9MXHNdZATF+z43lAOC6k1VUGu1giNPs7tt/1rDMko7hdlsdnAMxXVja+MPJ6Dr
0qB8VUbAvclUWpoLmR8oi53WbSesaxo20EH6KEsAi/jH1U25aHS0RxrWS1XKHPOF
TfPkfV97UaLnhVdA3WQD/yeRej5pRnAcArGTKH2CSBri6LEy8PvCAyhd8LIT9ifX
g1cL7PXhbcHOePH5peQz9Sz0D+r710geD4R+a6/iON6Tm/Kh0Cn/X3eENPrU0hXD
M13iYQ3wrWOw0OZHbBZb5aZX5KnRlCTKp97nCUdU+BBbclmTwtXoXXm+zePGeD2a
O+2BmNgT59MuBeoKDMii
=XefN
-----END PGP SIGNATURE-----

--hze9XmyoPo8YE0yg--
