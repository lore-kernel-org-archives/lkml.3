Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaHPVhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:37:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38924 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaHPVhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:37:41 -0400
Date: Sat, 16 Aug 2014 14:58:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140816135836.GM28623@sirena.org.uk>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140528185051.GB22488@sirena.org.uk>
 <20140603131204.GJ27722@lukather>
 <20140603144319.GD31751@sirena.org.uk>
 <20140605142729.GG5765@lukather>
 <20140605154931.GY2520@sirena.org.uk>
 <20140606160552.GC9791@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HVCoas+krw6dou6l"
Content-Disposition: inline
In-Reply-To: <20140606160552.GC9791@lukather>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: axp20x: Update the bindings to use a
 local parent regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HVCoas+krw6dou6l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 06, 2014 at 06:05:52PM +0200, Maxime Ripard wrote:
> On Thu, Jun 05, 2014 at 04:49:31PM +0100, Mark Brown wrote:

> > This sounds like you are passing the MFD child device into the regulator
> > API when you should be passing the parent device in.

> We're passing the device coming from the platform_device that is
> passed in probe, that has been created by mfd_add_device, which is
> indeed the child device from the MFD device. So we should always use
> the platform device parent's instead?

Yes.

> > For electrical engineering reasons it's unlikely that the supplies are
> > actually floating but yes, they are mandatory.  This is an issue with
> > registering one device for the entire regulator subsystem on the PMIC,
> > it interacts somewhat poorly with deferred probe.  However for systems
> > with full constraints like DT and ACPI ones it should be mostly
> > sidestepped since the if there is no supply mapped a dummy supply will
> > be substituted.

> Yes, they are actually tied to the ground, but it's still something
> meaningless, that I guess shouldn't be expressed in the DT?

Probably, that does seem like a valid case for omitting them.

--HVCoas+krw6dou6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT72OIAAoJELSic+t+oim9QpIP/1b/yfvAnWBtVqjWg5EmRUyC
sFkNgjSnK7SB1SOQo0MbwJ9HH/a7cu5FKdcAlDMUMDxWaxINwIpXdxoaEdW+CsXo
hctok0LBnez9kzGS4oFIxIJBpHVf9TkNiauEqkSe2shM5e2Zvy4dNU0Kx+XXwsFy
/Cwsdl9e9e41yMBla+2oMmRb1hHGrFfdi4UkdHrtJ3wrq/tSQ5AukzsJ+MC50oT3
YRZxKsXV+XpsG7cNOAFNqAKlDBqpwpWWHB5YpkDmlz61YvbPxVx6ckIavJSSo/9i
IdeFl+gcZK4JKxHib6yNRxHHxriWUlngU39av9uM3PwpUyPaP+N+6oZ06L2FJSqY
py+yWhJZ5f4+vS9MlkxQZumcO7LBCebrLDdw6xCFHDkcG2Zax/RHunWNEspp8o3O
QoUZdagjnk6rFWGJgIgGnD/9aQNQbq3Ju0H03hwD1HaDYcKYFC2zaJr5frVUlIDg
ESJpWlq1WemWD9M8kR+CudPpXchvBvsE94KPD5Qxyr3zKnOkUXER10iL1cSAvljT
7yiebRJTM8hEcbEQObu8PO/7ES4lYDEjJ2qsEwN0L2CAaJGimy43gCt9pRhrBJAM
wDtTvBfegespOrhEKe1SuQlhl3ef5U3i+YcszKENn4V+6MNbplBlYYodldfTRS5B
UFTfbU6aBJlzz81VDMoK
=redy
-----END PGP SIGNATURE-----

--HVCoas+krw6dou6l--
