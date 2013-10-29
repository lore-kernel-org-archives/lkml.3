Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3J2QS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:18:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54337 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3J2QS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:18:58 -0400
Date: Tue, 29 Oct 2013 09:18:16 -0700
From: Mark Brown <broonie@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Alex Courbot <acourbot@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Message-ID: <20131029161816.GE16686@sirena.org.uk>
References: <20131025112224.6e5265e6@notabene.brown>
 <526A0E71.100@nvidia.com>
 <20131025183345.2b963e13@notabene.brown>
 <526E3605.9080002@nvidia.com>
 <20131028221004.3294c1ea@notabene.brown>
 <20131028235344.GB16686@sirena.org.uk>
 <20131029111037.6e59499d@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <20131029111037.6e59499d@notabene.brown>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Any news on Runtime Interpreted Power Sequences
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 29, 2013 at 11:10:37AM +1100, NeilBrown wrote:

> Yes, the device is soldered down and has a reset line that needs to be pulsed
> low at about the same time that the MMC port enables the regulator.

> How do you propose that I describe this?  Which driver should know about the
> reset GPIO, how to I tell it about the GPIO, and which function should do the
> pulsing?

I'd expect the driver for the device to know about this, obviously
depending on what this actually does it might want to use this at
runtime (for example, putting the device into reset to minimise power
while it's idle).  We really need a generic way for devices such as this
on enumerable buses to run before the current probe() in order to allow
them to manage their power up sequences in embedded systems, this is
*far* from a unique situation.

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSb9/EAAoJELSic+t+oim9oLMP/jg2V5UyqiBEWhktPY5+iE0U
xi8EQMpT4HShmUPa9LbEw9dV5MkKe2R/amXXys64fO8YLHGib4hxO2bk5zWmzDME
s9GwriQuQ5h7HEz+bjny+G4omDPYu0PwSZsX9u2i61XqbL+gMbIM+DjeeU4Lx9kC
sZIDRIY4BU1uhdJFIDtg+eXHv429NKYduf7VwM2w84YJgHwyslC4UzgkyE+3UMv1
suQRbXWU2x5UXed0A7p38FU2lIXbKD5+XkF1BuVc/7utz/1g5T2MmNz9v2bA+5eF
u5T/iuZiowzRISd5Txr/1paAG4VaDQ1UFD+Ms9vEFWfuKPbBmAKrhDp+rH71ZD+U
4zEgQ/9+v+foufW2orY/4Occ9axRniQGh2C8F6gJ2Yo+F+X5sfqL53R7WqKQlXiL
kklMo1+drF0XG7o92Yxdq0gWyF7t/5CqD1NdCO48g2W36d2twyB7SCqhtuFCzp60
khzc8WByCDGW9pn6pRKmxQ0ivM5ejQiXTFdow+3zT4v9pcsA8etL+SiVu+RAeLvg
FWlTiILY3E/iVESfmL/jIC8+glfoLlh6Mrwro5cmTZ0kh9prH/FbCU6OMDDE8FLt
aVaSTEcDoKNRx2IRhL0T5LxnG9Wl5DuRAiWI8r2TmthwmgmhvzJTDQYt694QKEMY
6Cuwhl6ZIJoCd4tHWwr6
=L3us
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
