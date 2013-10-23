Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3JWQSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:18:03 -0400
Received: from ring0.de ([91.143.88.219]:42341 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab3JWQSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:18:00 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 23 Oct 2013 18:17:53 +0200
From: Sebastian Reichel <sre@debian.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131023161752.GA14745@earth.universe>
Mail-Followup-To: Mark Rutland <mark.rutland@arm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <1382540482-12261-1-git-send-email-sre@debian.org>
 <1382540482-12261-2-git-send-email-sre@debian.org>
 <20131023160934.GA6042@kartoffel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20131023160934.GA6042@kartoffel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 23, 2013 at 05:09:36PM +0100, Mark Rutland wrote:
> On Wed, Oct 23, 2013 at 04:01:20PM +0100, Sebastian Reichel wrote:
> > Add device tree support for twl4030 power button driver.
>=20
> This requires a binding document. As it is it's not possible to review.

Right. I will add it and sent a v3.

> >=20
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
> > ---
> >  drivers/input/misc/twl4030-pwrbutton.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/mis=
c/twl4030-pwrbutton.c
> > index b9a05fd..a3a0fe3 100644
> > --- a/drivers/input/misc/twl4030-pwrbutton.c
> > +++ b/drivers/input/misc/twl4030-pwrbutton.c
> > @@ -52,7 +52,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pw=
r)
> >  	return IRQ_HANDLED;
> >  }
> > =20
> > -static int __init twl4030_pwrbutton_probe(struct platform_device *pdev)
> > +static int twl4030_pwrbutton_probe(struct platform_device *pdev)
> >  {
> >  	struct input_dev *pwr;
> >  	int irq =3D platform_get_irq(pdev, 0);
> > @@ -106,16 +106,24 @@ static int __exit twl4030_pwrbutton_remove(struct=
 platform_device *pdev)
> >  	return 0;
> >  }
> > =20
> > +#if IS_ENABLED(CONFIG_OF)
> > +static const struct of_device_id twl4030_pwrbutton_dt_match_table[] =
=3D {
> > +       { .compatible =3D "ti,twl4030-pwrbutton" },
>=20
> There's no need to shorten this, "ti,twl4030-power-button" would be far e=
asier
> to understand. Unless the datasheet refers to it as pwrbutton?

Yes it's abbreviated in the datasheet.

-- Sebastian

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSZ/awAAoJENju1/PIO/qak7EQAIt2KMQix8La8p3JTbAgAT+g
kmyMdouP1VVijHkkPRW3RTo2jqtSdf87W23QhgeUlCaRo1+y11pkpi+B7Db79TFN
2R5yijCXbZv6wOhwYn5DJzm0aNliUeQyZxfsxUKRQfdjQsV3QJizX6m9qCzBnLi/
5GS0aSOozf8IgUPzlysPeBjPNgCVcZN3M78Ne3LUEoDhSUHMH0VkS6PKPjTDQNDF
ol0UY6SadiSUBhQRYbHVxZX6fxrGWeR5wntIpOQu4W86n+zk6s78tjk2qvBRSRts
pg2MC5sGL1xe5FUNYvft100wxabFGSJNSFbE68Dc+JOEWHlw4AoQsbokJXNNMkW7
QmYdd0jKrbitNIKVSBMBMFH/liHiywGF/hqMGvtUQMULK+9Mlnw2m6MI7reOkvH8
a8uDxnzGYKjgDGq6lWqmQagICr/hbynZPEoybx05JMm15NIQJ3EdGLTBNtCdJe1c
ZvcV1/mliAiCDN0yvpTXeSyLhRL375ZM7pGk/+UXcnwwLN6lEJNM/J953PsGOK5I
TvKC993JFLaQV+UuGo7PnJM2WFJmBNCvY8nge6Jj44s8w/sJSA+SHC54pTudm5R6
LVYqKkl5but1J1bG0W0eT8VccdDGCmSCPbf7J8K8PxNPAxQisC+iQVKDyU3MXXHr
P3vWSkReiwVA8DMOvE9f
=RZGE
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
