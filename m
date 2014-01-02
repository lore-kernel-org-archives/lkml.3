Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaABNKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 08:10:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40246 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABNKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 08:10:49 -0500
Date: Thu, 2 Jan 2014 13:10:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140102131045.GZ31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
 <52C466E1.3030302@metafoo.de>
 <20140101210814.31e3f3a9@armhf>
 <52C4766B.8080000@metafoo.de>
 <20140102102647.6efec89d@armhf>
 <20140102111056.GT31886@sirena.org.uk>
 <20140102124331.2bcfc172@armhf>
 <20140102115618.GW31886@sirena.org.uk>
 <20140102134437.1e39da55@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OhJ1ewkhZtPPLZD8"
Content-Disposition: inline
In-Reply-To: <20140102134437.1e39da55@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OhJ1ewkhZtPPLZD8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 02, 2014 at 01:44:37PM +0100, Jean-Francois Moine wrote:

> I still don't understand. There is already such cases in the Cubox:
> the S/PDIF output from the kirkwood audio controller is connected to
> both the HDMI transmitter and the S/PDIF TOSLINK. So, in the audio
> controller, the port @1 defines the S/PDIF DAI and the endpoints @0 and
> @1 point to the remote DAIs, creating 2 snd DAI links:

> 	port@1 {
> 		audio_hdmi_spdif: endpoint@0 {
> 			remote-endpoint = <&hdmi_spdif_audio>;
> 		};
> 		audio_spdif: endpoint@1 {
> 			remote-endpoint = <&spdif_audio>;
> 		};
> 	};

Oh, so the endpoints are virtual and that's supposed to be three things
wired together rather than a single device with multiple links?  That's
really not very clear from reading the above and seems cumbersome -
every device will want to explicitly identify every other device on the
link and any configuration is going to either need to be replicated on
every device or we'll need to check lots of places for the configuation.
It seems like this will be hard to work with.

--OhJ1ewkhZtPPLZD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSxWVSAAoJELSic+t+oim9OFQP/3QBJt6410x0lbgRbMIr8sjm
yJVrBKFItdvIAqZkYxJJKRFMhN2PFfiJ3Y++rgebkpu5UkM0940p78EPjVnRaOSh
4WaSFE3eDWO2bJlR/NQVCe79R+4HHPNwoq5Y9tlbpK9SFhYqVc+o7YfwC/ZUKxdM
csre8jtSo//1gLcRnKGvNj+8QRwH5X8qp9EMyaOhN+eVuEjwsKzJQE94cpsb5hUW
I2lvPLJQDea3tnEacpKhirSjXFB6eDbg/TRkmUA1oC8bs14Ni9sC27Z+fxwdr+pA
XxWFpL9Ian4VB4UBOWgvvpuORSkUJd/1ZyQEWFScd4bU52K/otZgEvI9UgyppK55
xs5cv48d1Z3wc8h+hVZn+OImsDv6N+3DSNSjS6NOq9et9/JVU3xMKRxEK+wb5sUa
ocq86lwca/IpATTiEqSrQn59XGhTVgdI/FvtNHthWm3PaELtbzYH7AwxJiFI+eD6
B251rzySM+GfNR7YJUGPVcOAWHSRcXAFBdIGD6fjxg2lGi/pyJr5FpVpfJCq8r8h
i2eHyDlWL8k7ZBqB1VYn6ie99tHBJngdwlOncNErEc0LS9RX/eRbKj5DWVwa+1I2
a/vGUO974FOP9lhw7e6SeQSP3nUnDEMJ66gDPiaSJFBF0GcCvSwQOj5UH2jo6zGx
u93TYtDZ8lEKiJeqaU+D
=Lt4g
-----END PGP SIGNATURE-----

--OhJ1ewkhZtPPLZD8--
