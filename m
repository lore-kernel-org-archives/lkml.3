Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3JYOo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:44:56 -0400
Received: from ring0.de ([91.143.88.219]:51611 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab3JYOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:44:54 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 25 Oct 2013 16:44:28 +0200
From: Sebastian Reichel <sre@debian.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131025144427.GA14862@earth.universe>
Mail-Followup-To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Florian Vaussard <florian.vaussard@epfl.ch>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
References: <1382626126-12565-1-git-send-email-sre@debian.org>
 <1382626126-12565-2-git-send-email-sre@debian.org>
 <526A680A.8090308@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <526A680A.8090308@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi P=E9ter,

On Fri, Oct 25, 2013 at 03:46:02PM +0300, Peter Ujfalusi wrote:
> > [...]
> > +#if IS_ENABLED(CONFIG_OF)
>=20
> You don't need to do this.

It's done like this in all the other drivers.

> > +static const struct of_device_id twl4030_pwrbutton_dt_match_table[] =
=3D {
> > +       { .compatible =3D "ti,twl4030-pwrbutton" },
> > +       {},
> > +};
> > +MODULE_DEVICE_TABLE(of, twl4030_pwrbutton_dt_match_table);
> > +#endif
> > +
> >  static struct platform_driver twl4030_pwrbutton_driver =3D {
> > +	.probe		=3D twl4030_pwrbutton_probe,
> >  	.remove		=3D __exit_p(twl4030_pwrbutton_remove),
> >  	.driver		=3D {
> >  		.name	=3D "twl4030_pwrbutton",
> >  		.owner	=3D THIS_MODULE,
> > +		.of_match_table =3D of_match_ptr(twl4030_pwrbutton_dt_match_table),
>=20
> If you try to compile this driver with config !CONFIG_OF it will not work=
 in
> this way.

For !CONFIG_OF of_match_ptr is defined as follows (in "include/linux/of.h"):

#define of_match_ptr(_ptr)  NULL

So the preprocessor will remove the undefined symbol.

-- Sebastian

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSaoPLAAoJENju1/PIO/qapscP/1wH218rX6suEps9GQ3nqB/8
ttufgBcA/qofrMTgTYPSYleEZrGEA1VIW4SGLnQvsHhivnMHlavki2nbw2ib88CA
99G6tOqaCnKjmy6pJoOyWK4VK2oreI1MGgd55dTxEMApBcyEhNi/Ch1p3xe/gBWw
3BvlQTg1qo9rc0Bpo4qzHjHUAOOsEbJVqXVwpUHVApZGHo4nwhbiVapkEvA5pTgo
6617/CZv5Ttoq6uHJeaD9STuQ8c5REzWMSuLtBqaMOQC8CQTcSXjmuNlai/QTFQe
6dd9q56QDu/Ji93kT03Y3EhXek7L/rOKs4GjatmfQ63nfdCMqz7elUUTC8iuZMfl
DOpmwhDAXKwlNRwCpMEXDUxrluV7iuavxrGTvb2/61DXtgCrKMMOuAocEscm3vNk
sv75K8803sb2mZgvkU9jD51VXQBhjcm4oD1yYvpnwSU3/wmxOXxspYfDsas3Ppd/
LKSZQsEpxEikalnGp5l9dvMgZ7XI00nmaj3h5xhRn/Mv+ArFqUevtF3Yuk6535Zb
ZGVLnF60ixQEz0s7Q3W9QwCcowVr+tjiohEyUQV3jQLEuqAsJmVmcat34AqF4KIN
h3P7VS0XAcNtHLE570PcUb4hh7DOSdKcqkMvmnUFUB0ukdtI3uSj8rIENKjJRDNt
aX9UET3e5q5p73zZSA8F
=WoCt
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
