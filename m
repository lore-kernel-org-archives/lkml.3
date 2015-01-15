Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbbAOMAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:00:22 -0500
Received: from sauhun.de ([89.238.76.85]:42916 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbbAOMAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:00:20 -0500
Date: Thu, 15 Jan 2015 12:59:57 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150115115957.GA2549@katana>
References: <rjui@broadcom.com>
 <1418183832-24793-1-git-send-email-rjui@broadcom.com>
 <1418183832-24793-3-git-send-email-rjui@broadcom.com>
 <20150113225012.GK22880@pengutronix.de>
 <54B5D0F9.8030902@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <54B5D0F9.8030902@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >> +	case M_CMD_STATUS_LOST_ARB:
> >> +		dev_err(dev->device, "lost bus arbitration\n");
> > I wouldn't dev_err that, only dev_dbg. I'm not sure how usual the errors
> > for the next two cases is, maybe degrade them to dev_dbg, too?
> >=20
> These errors are rare, and it's nice to keep them at the dev_err level
> so the user will be more aware.

This is wrong. Arbitration lost and NACK is pretty standard stuff on an
I2C bus. User doesn't need to know about it, it is just noise in the
logs. Timeout is different, you can report that (although I should
probably move such a message into the core). Please also use the proper
errno codes defined in Documentation/i2c/fault-codes. They should be
distinct enough to drop the messages.

>=20
> >> +		return -EREMOTEIO;
> >> +
> >> +	case M_CMD_STATUS_NACK_ADDR:
> >> +		dev_err(dev->device, "NAK addr:0x%02x\n", dev->msg->addr);
> >> +		return -EREMOTEIO;
> >> +
> >> +	case M_CMD_STATUS_NACK_DATA:
> >> +		dev_err(dev->device, "NAK data\n");
> >> +		return -EREMOTEIO;
> >> +
> >> +	case M_CMD_STATUS_TIMEOUT:
> >> +		dev_err(dev->device, "bus timeout\n");
> >> +		return -ETIMEDOUT;
> >> +
> >> +	default:
> >> +		dev_err(dev->device, "unknown error code=3D%d\n", val);
> >> +		return -EREMOTEIO;
> >> +	}
> >> +
> >> +	return -EREMOTEIO;
> >> +}

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUt6u9AAoJEBQN5MwUoCm2CzQP/jHAfzfpZl0Bsv8w2u4Qawd3
9XA8FfwpNJ3Pg6H1DRN4rO07Plb8vrk0rAJhv8a1upFV0BXbUU0CoJn4pifCO3TY
9TBVUlHOXhJ1jXhgfE37E9HRDUFS+sXLHQyCe/g8Mo0uEfEFuZi2vG2ax69QoiId
WIVTZHmQIT6ckHy3bU+Q8suSY1LmvzrgXLU5stnS559F81kqh9MtHdDDb9h1rX79
FBRwWJOHTe1OsmbmKUgokXHkSWUG0IZ4k45OWucsOyEtYxuQ/A2MrocuiP7g3XOF
GFh2WlcgS+2cvufvauuDrxDpe7P87FQ9dVgl4+Tun5YsF8WYdUQIlmsPC1TZr4jR
svU6nCLYU8S6VPXH5PVwugLTBOzv8xD/9w/eQEVnL34Ldr0lUDStViU85ShG4T4V
HcMkMqE7sJ6GzWBV9L0eV0CW2aCyJP1CrR5wGQCLSkwlzVRlJsA0zdlyNOpKK86T
w4izoJ7w0/tmFrZVkv267hGiUbr0piVFjKyN5WGffu9c50oUbzkGmee1Vo4Dk9Vt
+rCWl/p791tGsRkhLXbGh63dHlGBwrLwkbhkNQZ899dT9hVlIc5gGDw0Vmfb/nPA
fxrslb21nI7xL4qtxiyPyNgVuzaLPrmEIermmACTmtHKtz0MIQyWqY6nOgnVG1Ab
fAMNSRXX9JV+c1E547lg
=VnzZ
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
