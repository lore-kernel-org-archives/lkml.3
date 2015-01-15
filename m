Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbbAOMHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:07:23 -0500
Received: from sauhun.de ([89.238.76.85]:42945 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAOMHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:07:21 -0500
Date: Thu, 15 Jan 2015 13:07:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150115120704.GB2549@katana>
References: <rjui@broadcom.com>
 <1421274213-3544-1-git-send-email-rjui@broadcom.com>
 <1421274213-3544-3-git-send-email-rjui@broadcom.com>
 <20150115084119.GN22880@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20150115084119.GN22880@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> > +	iproc_i2c->msg = msg;
> Can it happen that iproc_i2c->msg still holds an uncompleted message
> here or is this serialized by the core? Wolfram? Either here something

We have per-adapter locks serializing transfers, if you mean that?

> > +static int bcm_iproc_i2c_cfg_speed(struct bcm_iproc_i2c_dev *iproc_i2c)
> > +{
> > +	unsigned int bus_speed, speed_bit;
> > +	u32 val;
> > +	int ret = of_property_read_u32(iproc_i2c->device->of_node,
> > +				       "clock-frequency", &bus_speed);
> > +	if (ret < 0) {
> > +		dev_err(iproc_i2c->device,
> > +			"missing clock-frequency property\n");
> > +		return -ENODEV;
> Is a missing property the only situation where of_property_read_u32
> returns an error? Would it be sane to default to 100 kHz?

Default of 100kHz instead of -ENODEV sounds very reasonable.

> > +static int bcm_iproc_i2c_remove(struct platform_device *pdev)
> > +{
> > +	struct bcm_iproc_i2c_dev *iproc_i2c = platform_get_drvdata(pdev);
> > +
> > +	i2c_del_adapter(&iproc_i2c->adapter);
> You need to free the irq before i2c_del_adapter.

One could also keep using devm_request_irq and disable all interrupts
sources here?

Thanks for the reviews, Uwe!

   Wolfram


--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUt61oAAoJEBQN5MwUoCm2NBUP/0gGYZRq83QMbPHm5H9LPpmj
uRvfNtoFlZGa4ZlwfmfPs4HseBOme3ppPc4/QMl283S3QcZufrpq/bP3l2H6cmXi
2WtirS/IYL2PvdzbRgVTR5SeCnmBhPEndA0K4J9+HejGUhOf7Q6PonrfAjP1jG8v
cBbC0PgUXSkPFQszp4th2cax4nS9Bjz8hPqrG1uKqS7siv0niGLV+CKuXnc3a59Q
udJGCsCZhvfqND5Dl+nOgxyR/teOguL9pCaQ8s8hX21FGuAIiUlPBk5/wB2UJVln
EPkl9+GevP9oQK/9ZyXLF0RoSaeeeX2yDRrmx4aRDnoSH+RBUL833f3K+JnW3kSP
v0MiiDo7YSp1W6t4g+kUn+AplH9PDbkH9QRy1ssmJ2tSuGxhUsL+SEf+fAMXtp64
CkF4wqn6Q092ZE0qmBM7X13hoIkRTvWaqDNW5U8+zakqR+8WfxubXMBAfU1U+ZLc
NdVrhy0dx4xcTSa82w19E7yx8G0J5Zdhe7xxqcx3ct0PJbMcnHMRuIhtkNXgAUSp
ybTjqmrkF1gNU9+MCmhrNo8fnWObK0U5CrTDYh6Acdi2Nqs1tBIlUOEHOSCVmLPn
uoD/5CTrRJkV1HppxxwC1jGGxxMXTFzbffnCTTya1XqP2yyTdPntXSUsHQfE458s
mgImHzp7eZfC/fVBtiVT
=C66l
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
