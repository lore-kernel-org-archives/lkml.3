Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab3IBRl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:41:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40941 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3IBRl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:41:27 -0400
Date: Mon, 2 Sep 2013 18:41:21 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Ashish Chavan <ashish.chavan@kpitcummins.com>, lrg <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130902174121.GV3084@sirena.org.uk>
References: <1375110386.21326.6.camel@matrix>
 <20130729160157.GZ9858@sirena.org.uk>
 <1375689331.28910.5.camel@matrix>
 <20130805144201.GF9858@sirena.org.uk>
 <1375717898.29528.23.camel@matrix>
 <20130805162342.GS9858@sirena.org.uk>
 <1377778108.15438.6.camel@matrix>
 <2E89032DDAA8B9408CB92943514A033751E611AF@SW-EX-MBX01.diasemi.com>
 <20130902103843.GL3084@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A033751E612F5@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyWBHxIrsGpYNMFw"
Content-Disposition: inline
In-Reply-To: <2E89032DDAA8B9408CB92943514A033751E612F5@SW-EX-MBX01.diasemi.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyWBHxIrsGpYNMFw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 02, 2013 at 03:38:18PM +0000, Opensource [Adam Thomson] wrote:
> On Mon, Sep 02, 2013 at 11:39, Mark Brown wrote:

> > Please fix your mailer to wrap within 80 columns, it makes your mails
> > very hard to read if you don't do this.

> Yeah, sorry for that. Having to use Outlook and of course it doesn't seem to
> have that feature (at least not that I could find), so trying to do it
> manually.

It's always been in there, can't remember where exactly and I don't have
access to Outlook any more.

> > They are not separate, they are soldered to the board as part of the
> > same package - quite a few other devices use a similar scheme and are
> > also handled in this fashion (the TI TWL devices are one example).

> The difference here is that our combined devices can also be separate chips,
> not just one HW package containing logically separate devices. I don't believe
> that's the case with say the TI devices.

That doesn't seem like a unique feature.

> > This is roughly what ends up happening, you do need to instantiate
> > another I2C client no matter what.  The important thing here is that the
> > CODEC does not need to be separately registered by the user, if it
> > really is only the I2C client that needs creating that's probably OK so
> > long as the user doesn't need to worry about that implementation detail.

> The only thing that would need populating is some small platform data for the
> codec (MIC bias voltages, and such). You'd still have to do this, combined or
> separate, as this is platform specific. Other than this, the I2C client
> initialisation for the codec is simple, which is a reason why I don't think
> the PMIC needs to initialise it, and you can just as simply do it from machine
> code.

It's the bit where the board has to register the CODEC separately at all
that's the thing.  Think about it from the point of view of people
writing and reviewing the machine bindings - they end up with this odd
chip that appears twice with two names and registration schemas.

> > The reasoning is simply that if the chip design solders a single device
> > to the board then the software system integration should register a
> > single device with the system.

> Ok, but what about the scenario where the devices start life as separate chips
> and are then later also packaged together as one chip but still with no
> internal connection, like DA9055. The drivers were already written and accepted
> as separate entities in the kernel, without chained initialisation. What would
> be the approach there? To me, logically it makes sense to leave them separate.

It doesn't seem to make much difference what order the drivers are added
in here?  You're going to need to add a new device IDs for the SIP anyway
since it'd presumably be badged as something new - if it wasn't then
that's a bit different.

--PyWBHxIrsGpYNMFw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJM2+AAoJELSic+t+oim9LhUP/3N7VNhGkU0j1cEwGowp9Sf5
FId+xLQ6qvHz3rLqjksNOoCz9tjsg9zX+Hzy9zh65EFHgJcX8FJVOfs2G5XMWX/h
61ZOpGDjIBZVH87tvpD8IM/ATd8nBvrMGpvwmS9D0rfcZz4Zqo8+7ugX4cWJ9Rxf
jc60XNPh0rtMbBDABZHI8iVzevvzPvhbgqrVKGs5FVSoH6zhcog0m4C5rZgXIQCJ
kHOxHAY3aC/Jrfkl/ufarV3GkCU06OrTGGNT2IPVRWtr7notCRv3EP0XGowDTvGs
4SI316/Hm8IWxV05odj0dNoHHLVTmDgyUbT0a7JOiSMlhHlsCyUSYXCTIjXfjDta
55NN5xYitw08TinpE2mLzVRK+aVhRNHiVl4dqc7xWJq0puIZ9Nzft2B3/Nj2kzy5
J6TMdfZeHrWSK0u26PS4jpabc/KDzXfDZGh/S7wXWwMFVA5kQpRR16+w+scxms6n
3uiNkBak0xuyCLnxnKiibdHH5vOk+XcTzhsJHh6bsfZK9DTcC6Jq324H4zpz5fJN
6R3+YZ2l2ZsB4fgFn7SThz4w9c7lGROWhkosokKZDgQlELpDj3hOK3D7e8jyuQ35
eieGVnQvriAA4QbwB1/QqOHfvPuwfWc5tczPgvX2HfWfrHOw5pB28Nmz2cJnnNzC
NbSUFZVPvaxy+dLvhHvN
=mExI
-----END PGP SIGNATURE-----

--PyWBHxIrsGpYNMFw--
