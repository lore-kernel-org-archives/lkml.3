Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3FGQrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:47:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54893 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3FGQrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:47:19 -0400
Date: Fri, 7 Jun 2013 17:47:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130607164700.GW31367@sirena.org.uk>
References: <20130606100346.GC1883@sirena.org.uk>
 <51B0651D.3090902@itdev.co.uk>
 <20130606105530.GT31367@sirena.org.uk>
 <51B06FE4.7040805@itdev.co.uk>
 <20130606131638.GX31367@sirena.org.uk>
 <51B0B52C.1090807@itdev.co.uk>
 <20130606164629.GG31367@sirena.org.uk>
 <51B1F859.1010504@itdev.co.uk>
 <20130607154134.GU31367@sirena.org.uk>
 <51B20630.7000304@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bdvOYxGdT/r+cPTQ"
Content-Disposition: inline
In-Reply-To: <51B20630.7000304@itdev.co.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bdvOYxGdT/r+cPTQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 05:11:28PM +0100, Nick Dyer wrote:
> Mark Brown wrote:

> > I thought there was this protocol you're concerned aboout, not raw
> > registers?  Presenting the actual data in binary form seems sane, how
> > one gets to the data is the issue.

> OK, so we seem to have gone round in a circle here. Initially I understood
> you to say that providing a binary read/write attribute for access to the
> configuration data was not acceptable.

What was being proposed was just mapping the register map straight into
userspace and implementing the entire protocol in userspace.  Having the
unparsed attributes visible themselves is relatively normal.

> >> The chip itself will enforce which registers are read-only (by ignoring
> >> writes) or write-only (by returning zeros if read). Encoding all this
> >> information in the driver would just make it more brittle in the face of
> >> touch controller firmware updates.

> > So not only do you interact with the firmware via this protocol but the
> > actual hardware register map is unstable

> The register map is fixed at firmware compile time. The driver contains
> code which parses the object table and figures out the correct register
> offsets which are used on the particular chip that it is talking to.

> The user space tools that we have written contain an equivalent parser. Is
> it the duplication of this code that is your concern?

I don't think you're using the usual definition of "register map" here.
You seem to be switching between talking about this object model the
device has and device registers - perhaps the objects are also registers
sometimes?

> Are you saying that your concern is that user space shouldn't be able to
> directly access these registers, for example to trigger a reset? In which
> case, how should user space reset the chip if required?

If the application layer can reset the device underneath the driver that
doesn't seem awesome; similarly if the application layer is having to
worry about the device getting powered off underneath it this doesn't
seem great either.

> >> It would be possible for the driver to intermediate for some of the
> >> registers that it cares about. For example, if we change the screen width
> >> then the driver could reinitialise the input device. But I can't see that
> >> it makes sense if you are changing several settings in a row for the input
> >> device to be reinitialised several times. It is far less buggy to provide a
> >> single way of tearing down everything and reinitialising (which could be
> >> simply triggered from user space) than to encode all of the dependencies
> >> (which is bound to introduce bugs).

> > I am having an extremely hard time connecting anything you're talking
> > about here with the discussion at hand I'm afraid...

> I'm trying to provide the background to this design as you've requested, I
> apologise if you find it confusing.

You appear to be assuming a great deal of familiarity with the specifics
of this device here.  Where does all thi stuff about reinitialsing the
device come from?  What are these dependencies and what does all this
have to do with setting parameters?

> > Nobody is talking about changing the protocol for interacting with the
> > device.  The discussion here is about the ABI the driver offers to the
> > application layer.

> OK. I think that the ABI offered to the application layer should also be
> object protocol, implemented over a binary attribute, which is what the
> patch under discussion does. Is the problem that I need to provide better
> documentation of object protocol?

As Greg says you do need to document any new sysfs ABIs you're adding
anyway.  However if this is some stateful protocol you're implementing
then does it really map onto sysfs well, sysfs attributes are normally
more just data values?

Won't the driver end up getting into a fight with the magic userspace
stuff if the driver has no idea what the magic userspace is doing?  How
would suspend and resume work?

--bdvOYxGdT/r+cPTQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsg6BAAoJELSic+t+oim91d8P/AgjEuNYA0Htvw9y+f09wO2K
XIX0eVoqJdV8D9b2m+LWI5GqeWLZejoJrTDFzquynkN1burF75mtBhr3nbHipXtC
i58PMF+rBd16e6j5RszxKasaIYnqGqznXkokB3/dHXNm3ajPOv1BBFT0XM/S+SfU
LNCHT+CXDhwAl4CHQgk1xAzFmkk7I9CPe8wDkZkFthH0apdBlkH/Kx7AnIdA2/Pz
uyvt0t8o8+9Il/cID1HLMuzCe7yijGUNCov2USzZqCE+sbfVFgoxLXd5EhooHNjx
HBr+aOdu8hbxlDuWvPpKRcnTZvFLnZXREq6fe5kSeGP7LzZ0gRhjetbUd5C9TrW6
a9crwm0rd8+VlGeft5NRMfo3YR5k1tcq02pP6mF72EsFT5ZHXtjleuU85z2cZTik
1kjuxPbaX8Cx7p9ipx5U/7B4o8D7R3FSd9c5cI2/hQJ6QADuHu73FM+lV45bqs6j
L1z7U9i11lVwJ3w6gkKvF4T+llc50VrbEjjhW4Y18+VS645yurPJ2jFCkU0KycHw
JIbQr6Gx7amBdcAtOO8FENRf8oGEtjyWQpAylOb2WRb0gmOTSE3BcEbiUrJdSW1V
NhA44JqHSzfAFuKizCYtnRlbIQu04mOCcIupcpZjIXiIDMH8zYGIZQvzEyxDTeeh
XaN4s895FkqBJAnKKxsW
=HiCk
-----END PGP SIGNATURE-----

--bdvOYxGdT/r+cPTQ--
