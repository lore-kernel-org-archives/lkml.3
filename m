Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbaE2WEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:04:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47043 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaE2WEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:04:47 -0400
Date: Thu, 29 May 2014 23:04:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Message-ID: <20140529220426.GQ5099@sirena.org.uk>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1401211721-19712-4-git-send-email-bjorn.andersson@sonymobile.com>
 <20140528165529.GC5099@sirena.org.uk>
 <CAJAp7OgY-99jRqvBOPbkj=Nrt7vW=0Ae+Xvf3J7JrDS1eoigWw@mail.gmail.com>
 <20140529211815.GP5099@sirena.org.uk>
 <CAJAp7Oj7jUw_PGxS6TEG=eCMkfaTTi0V1+8EZt4Mp_8gEUFaWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MXxcbiX/Q4+iy5U7"
Content-Disposition: inline
In-Reply-To: <CAJAp7Oj7jUw_PGxS6TEG=eCMkfaTTi0V1+8EZt4Mp_8gEUFaWA@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MXxcbiX/Q4+iy5U7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 29, 2014 at 02:59:38PM -0700, Bjorn Andersson wrote:
> On Thu, May 29, 2014 at 2:18 PM, Mark Brown <broonie@kernel.org> wrote:

> > No, this is awful and there's no way in hell that stuff like this should
> > be implemented in a driver since there's clearly nothing at all hardware
> > specific about it.  The load tracking needs to be implemented in the
> > framework if it's going to be implemented, and passing it up through the
> > chain is obviously going to need some conversion and accounting for
> > hardware conversion losses which doesn't seem to be happening here.
> >
> > I'm still unclear on what the summed current is going to be used for,
> > though...

> You do load accumlation of all the requests from the drivers of the Linux
> system, but in the Qualcomm system there might be load from the modem or the
> sensor co-processor that we don't know about here. So additional accumulation
> is done by the "pmic" - that is directly accessed by those other systems as
> well.

So the resulting load is then set directly in hardware instead of
setting a mode?  That would be totally fine but it doesn't free us from
having the logic for accumilating the current we know about in the core;
that's the bit that's just at completely the wrong abstraction layer.

> I understand your strong opinions regarding this, so I will respin this to
> forcefully set the regulator mode intead of merely casting a vote.  I.e.
> implement set_mode to actually set the mode.

Or just don't implement mode setting if it's only used by this crazy
stuff.

> But as there are no users anymore, I could just let the constraints part go for
> now and once we've figured out the dt part there will be some way of setting
> these. Okay?

Yes, that's fine.

--MXxcbiX/Q4+iy5U7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTh67mAAoJELSic+t+oim9eosP/iAsqkP+rmAU7kl40vTRz//a
AFrnCLvH5352QESPRF/CvpHoDzf9WPkTno2+eAHGzcwxTACuwDrjGeeqVfTP4hoL
AubcprETpIq+1IDCaljSiAraAM0W2YICiEMUHzEmjpygWLDajHD1ItG8VSqd0KB7
0cTDsOXQG6jSdWeMtRzZudPrTHYt+4hAF3wAR/VO4aocQgGZ1E9AJwU5ddk1/p4k
roKT5nElhwGWAKc5wqobT9VhlqwxyA6k/JrMlEcUlEwW29mIjwgr8BInQBPfPA5J
QpCHp6Azp/YvLhS1yvfPCz/TYGpQoN9CwiieMtX/0MIbawnP5jcyRNUfHk+nDEoT
JWfPpSAUKDJz89fxu7Eo2/EHPmIauqhv/ycu7S8p45b08k1OMaYgp4I0gn7bXml7
N0ZvmQuBlyDaNuRWZ/1egn7QBbNPdDNMlsZpr4PWY40Y8DBCfsyRfiA1I3O43x6V
HEnvFML1Bl3pcF8jWS8MdYuyPsKu6WYt353L8cwEjngpI6HvSRy1sWWX04O/lp9G
laxkJwTnuioeBm1q+0AMk7jWQPXEn+pywA4615uFlcYai5QMANhblPXXykwMW5oA
7V9Ge7GAQAOEBwmjDpDEeBygb7fFnKrFMnzvS9/bGmfMQXtv7h6yCzvMfuap4zvq
GseO22m1lFSrDQfkgKvR
=sk+r
-----END PGP SIGNATURE-----

--MXxcbiX/Q4+iy5U7--
