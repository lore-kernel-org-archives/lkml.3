Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3JZAZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 20:25:32 -0400
Received: from ring0.de ([91.143.88.219]:53615 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab3JZAZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 20:25:31 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 26 Oct 2013 02:25:02 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Jenny TC <jenny.tc@intel.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: N900 DT
Message-ID: <20131026002500.GA16970@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Jenny TC <jenny.tc@intel.com>,
	Anton Vorontsov <anton.vorontsov@linaro.org>,
	linux-kernel@vger.kernel.org
References: <201310240806.49340@pali>
 <20131024085155.GB28938@earth.universe>
 <201310252039.41026@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <201310252039.41026@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pali,

On Fri, Oct 25, 2013 at 08:39:40PM +0200, Pali Roh=E1r wrote:
> Now I found this patch and it looks like it will be in mainline=20
> kernel. And after that it could be simple to listen for needed=20
> events from isp driver in my bq driver (without touching isp).
>=20
> https://lkml.org/lkml/2013/7/25/204
>=20
> Can you look at isp1704 driver for DT support? I think that only=20
> one gpio needs to be passed to driver from board data.

I had a quick overview over Jenny's patchset [0] (the patch you
referenced is part of a bigger patchset). I don't think the
scenario found in the Nokia N900 is covered by it, but probably
now is the time to change it :)

So for everybody new to this thread:

Multiple chips are involved in the charging of the Nokia N900
battery:

bq27200:   This chip is used for reading battery status. AFAIK
           it's not directly involved in charging the battery.
bq24150a:  This chip takes care of actually charging the battery.
           It has no clue about USB related stuff. The maximum
           current it draws can be configured, though.
isp1704:   USB charger detector. This chip is used to detect how
           much current may be used by the bq24150a chip.
rx51-temp: Analog temperature sensor for the battery, which is
           connected via an analog-digital-converter.

The question is how to connected these driver with each other
if device tree is used to boot the system. Any suggestions?

[0] http://thread.gmane.org/gmane.linux.kernel/1377608

-- Sebastian

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSawvcAAoJENju1/PIO/qa8aEP/RmJ5Z7rwOnIsGX7nvuXtLMZ
3ujUcpLCmug+cpqKvj5ivHWjb20iF6Vr0LWf/dguQ2DXBEaB2fjPNY7/w80FgKRL
a+GtUYEXVwj6BwbIkcuHdJWk3EQKwfsiEAT9VClpFJKd8sAKUfQ1xN8qf3YzYyfy
/e3KERKO/D82w4d8R4M0+r6k7cWKCYtys+NE62D7hOVE3MgKmbTVJnp3K9z73a/v
7z/9FAwAI8O7pMGNNzCRfSXaaXDYdhN+wDNFCaEtFPspg7Xgrq9/VfeGqQt5cZAi
0U0bujr1erjYJ3KxsUsETIXgwTCANRL2FeTHyQHsL9yELuIznrGBtkKSSzlLWVIU
8QQouyOFlfN+/MdSEZovS/LFP51Bqc8jUolBCFeEpBT0gtx+y1RA6x5OcsluA1IY
Vv6CROBtzn4jr4GAzO4xAyCO/uyyfolWgorYzwzAvk9yVZzQRLWTmdpTjdGFBllB
G04hFSLGXmV35VlsuKzwT+dkVj0oDIjXVl24liuJW5jJLwH8gsOT5JsNRwmPdLdb
sqpnp4LW3hkT1lpOrqjoKstWAz3LWqeHQJKwSWl3DMAM8GIU7pHyY3JxtQNJtkaA
isxxRZkvVkE+bSzUKRz/majkIOLQ9ux1wa9OnmI5LSZPdp7xgPSzrhTwheV1MQTT
WnBmAP5YRf3LKnegVKcG
=eM4f
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
