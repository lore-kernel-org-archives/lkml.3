Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3JZLbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:31:49 -0400
Received: from ring0.de ([91.143.88.219]:55046 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab3JZLbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:31:46 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 26 Oct 2013 13:31:39 +0200
From: Sebastian Reichel <sre@debian.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131026113138.GA22920@earth.universe>
Mail-Followup-To: Kumar Gala <galak@codeaurora.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Florian Vaussard <florian.vaussard@epfl.ch>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
References: <1382626126-12565-1-git-send-email-sre@debian.org>
 <1382626126-12565-2-git-send-email-sre@debian.org>
 <FC6F0077-7E61-4F64-94E5-10E8FEF1F1E4@codeaurora.org>
 <20131025221850.GA8657@earth.universe>
 <085234CB-BD53-4120-AE77-B06FA9314E96@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <085234CB-BD53-4120-AE77-B06FA9314E96@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2013 at 01:37:57AM -0500, Kumar Gala wrote:
>=20
> On Oct 25, 2013, at 5:18 PM, Sebastian Reichel wrote:
>=20
> > On Fri, Oct 25, 2013 at 04:41:20PM -0500, Kumar Gala wrote:
> >> On Oct 24, 2013, at 9:48 AM, Sebastian Reichel wrote:
> >>> +- interrupt: should be one of the following
> >>> +   - <8>: For controllers compatible with twl4030
> >>=20
> >> Just checking, but the interrupt is always 8 for this device?
> >=20
> > Yes. It's currently hardcoded in drivers/mfd/twl-core.c.
>=20
> The fact that is hard coded in the driver does not imply that it
> should be in the device tree binding.  Is there an interrupt
> controller as part of the TWL4030?

Hardware looks like this:

&twl4030 {
    compatible =3D "ti,twl4030";
	interrupt-controller;
	#interrupt-cells =3D <1>;

    twl_pwrbutton: pwrbutton {
		compatible =3D "ti,twl4030-pwrbutton";
		interrupts =3D <8>; /* 8th interrupt from the twl4030 */
	};
};

Simplified the initialization of twl4030 stuff works
like this for non DT boot:

twl4030_init(...) {
    init_subdev(...);
    init_subdev("twl4030-pwrbutton", ..., irq=3D8, ...);
    init_subdev(...);
};

-- Sebastian

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSa6gaAAoJENju1/PIO/qaVtgP/AwHBjDQqJ+SbPRn/bUx2myo
2+Xq5I8sbDqOZg5Ktx44AwIRsRH4h6YwnIe1WVmVlqezfnfEqtuPR1A9madv44Vh
buCzrdjYC2mflH1CY9I7tFbk1z3BgyD4xugMIBe1x9kDoztzWDpY6lwlBfg9FoH1
7DWY1LfM5f0cSYAXNVj52reV5lIpSzPEIYfu4FU6UVx+Uk6EL+lyRuIY1mPeCYo+
Y556LSOKLLn5w5QjvkB58+xURHmx6t+MuDp/17tWaW0gpCXcTTBwtmevhYC+Id2T
nt9lR3d88c25y+rXV+4AWccNIMZjZoQ+2asj+paCB8unPAYfPRuJ94PDdybxmMxa
RGxq9T396B+lRRNB7Cy/GweGIrmLyElYLCeTc3YU+B/AMCka/CClm2lgF1UPZ0nj
rnNGPJ/2+Ibf5ID8VTKWx91Q4xWAU4Dy/fE/pVpRij7VwhD1JJLbremRcWu1nTY4
tS+uWcAQQ/Tjq0h/ucz8ZmL/H83vFtl0y/93zTakVpNSGXM506HFcQV3NZDAIV+W
33QX+d29m8cU4/3EtJ+l2pf5dp7Mr20ByoqB8ScVvoWaRniexECmkEK/M2r/oFwS
eONFUDXnYJz8STsd4MAZ8h+hdy8XQionjT/puoNuGBrjOaYoSqUHce2MljUyvu+p
fSPWCf0R1maM3M9xQAhW
=kLMb
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
