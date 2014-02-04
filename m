Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaBDUAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:00:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35493 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaBDUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:00:26 -0500
Date: Tue, 4 Feb 2014 20:00:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140204200018.GZ22609@sirena.org.uk>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
 <20140204110531.GR22609@sirena.org.uk>
 <CAJAp7OjCnJ=P9Gi20=D9gybREiSaqd1CaQ0K=9fGbCzU1gTFLw@mail.gmail.com>
 <20140204181831.GP22609@sirena.org.uk>
 <CAJAp7Ohn3ch2nK_S8j9ieRBzNeyt6OJmumEhRXXykB9RgMJsQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w8TYR/ucHPxfv1bK"
Content-Disposition: inline
In-Reply-To: <CAJAp7Ohn3ch2nK_S8j9ieRBzNeyt6OJmumEhRXXykB9RgMJsQg@mail.gmail.com>
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


--w8TYR/ucHPxfv1bK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 11:09:03AM -0800, Bjorn Andersson wrote:

> I have a regulator that's being configured from DT as:
> regulator-min-microvolt = <2950000>;
> regulator-max-microvolt = <2950000>;

> In the consumer I do regulator_set_voltage(2.95V).

> As min == max the voltage is applied by the regulator framework on registration
> of the regulator; and the regulator_set_voltage() fails as
> REGULATOR_CHANGE_VOLTAGE is not set for this regulator.

So we should be changing the code to allow a set_voltage() that sets the
voltage to the existing voltage regardless of constraints allowing a
change then - that's what the underlying issue is.  Your change wouldn't
cover the case where the hardware defualt is being used for example.

--w8TYR/ucHPxfv1bK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8UbOAAoJELSic+t+oim9MEkP/iKv+wtd24eEKDPtFAO8q8/6
sHiRfbuBTTZ/AYZpWG6wD85WNYtlRL8wu8Yrg2mlh/0RMjbpqaZGdgPcNKJRzadr
rnXKhtMgTmbJOlMSk3LBV+UvkxUdTx2yatcCtmuWs8zxVHWkl53VLMZgquuLxIV0
0FuFZo8SSHmKKeCPcr/jXCQ3kAfMNh+fYByp7mDP/Op5yNWQIawXqeEkxsyNu69S
zhoh5kQaRjVjT0s3teOiy2rsTzmaz21NmfPIYSCPr6XZkoiiuTeK6DYip51aczD9
QhpjrMlpKR0MqORSUYDVkn3HhpqTRuKjNdSeS9zLdgOCx7wk4YierIBdDQmB2oCS
OmK29ggO53ZwQjH4U6vfh8qkwaQKiqFKS3Pvcj1C50LHx4RxTIPxqjEbcxwSjoPZ
8g/VTEEa0MHAGdKz9ob6sdxV+CbQ4Dljo2EJnFmJ9v8ATBCLv834RRQ/TKqZVdXS
ZoGF3BIVnptGM9oxXs26MjrWj9oUud27JQgtxfERNxpwugaODziDdrU6udo95KE6
RgatPwaPOEnOg/eW2HDFuzzi2/6pQ0vcWbpkE7x+lrm5pdyDwRCRWHraxLRLTXB+
+bXqqm8AsD8TlZB4TsRuQAYf/E9CLCqFOjzSi292rnFUP1g7J2OIII1otCHATyDw
RonrsDBBvIoJvIgN7Z/C
=0rbi
-----END PGP SIGNATURE-----

--w8TYR/ucHPxfv1bK--
