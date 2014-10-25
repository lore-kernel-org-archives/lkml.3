Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaJYVe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:34:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48568 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaJYVe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:34:27 -0400
Date: Sat, 25 Oct 2014 10:46:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Clark <robdclark@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, David Brown <davidb@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Message-ID: <20141025094643.GQ3729@sirena.org.uk>
References: <1414178111-19525-1-git-send-email-balbi@ti.com>
 <20141024201138.GL3729@sirena.org.uk>
 <CAF6AEGssn23wSaSCY-MH+CUk1YD2g7Ld+rejQq0BSHUAcXgZEQ@mail.gmail.com>
 <20141024211848.GP3729@sirena.org.uk>
 <CAF6AEGsDhv6V8ggOsLHgk6YgWEaL4iV1yX4qOdA_=KzCAWqR=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G+DT6X5ssgZ56VG3"
Content-Disposition: inline
In-Reply-To: <CAF6AEGsDhv6V8ggOsLHgk6YgWEaL4iV1yX4qOdA_=KzCAWqR=w@mail.gmail.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: stub out devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G+DT6X5ssgZ56VG3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 05:57:24PM -0400, Rob Clark wrote:

> Oh, you are only looking at the one in mdp4_kms_init(), which could
> possibly be a simple regulator_get().  Look instead at the ones in
> hdmi_init(), where I need to know whether to defer or not.  At one

No, I saw that - looking at the code in hdmi_init() it's using normal
devm_regulator_get() correctly (it appears to be open coding
devm_regulator_bulk_get() and likewise for the enables and disables but
that's a lot less serious).  I can't see anything actively broken with
that code other than the error handling on failed enable.

> point I was having a problem getting dummy regulators with
> regulator_get() but that could have been a symptom of another problem.
> I will re-try regulator_get() next time I am working on the kernel
> part of the driver..

It's a bug elsewhere, if you are getting a dummy regulator on a DT
system it means that you don't have a regulator set up for that supply
so the core is just assuming that it's always on.

--G+DT6X5ssgZ56VG3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUS3F9AAoJECTWi3JdVIfQUZcH/iCv2GYsjiKyR/CID3r7bS0T
Oj4OleCsUb3OV7UaY3JzyjtNp28Z/UMeSelGuQDNuNCrzBReMZvhXIQuP3yrOKrj
VkoHGSdIpnb71FfOh+OR2YA9UGQIsxDXX7n6fkrOPTxTOtUC8/BfXlXkUipXO/2R
RWrOdw1jNA3Y8XX7mYLLztq4HsFBmJnqL/mD8/e/+eofg++Wmr7jCjS31TwmahG9
kVcyk+5agh165wJu4XqMKmDcpN/RVQBupXiD6m6n9UmY3Aub8R/SHWqUKFZyZUe9
5JqFxlrdIhUfguT5v+9oEv2Ms1z0TUxt7FSMhNNLTe7FMANe6ZKVh8ujLNGs/pM=
=yw8O
-----END PGP SIGNATURE-----

--G+DT6X5ssgZ56VG3--
