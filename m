Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162484AbaDCH0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:26:01 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43188 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162409AbaDCHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:25:57 -0400
Message-ID: <533D0CFB.7050707@monstr.eu>
Date: Thu, 03 Apr 2014 09:25:47 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 1/2] i2c: Add driver for Cadence I2C controller
References: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com> <533CF913.4020308@monstr.eu> <20140403071004.GA2571@katana>
In-Reply-To: <20140403071004.GA2571@katana>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uRFjPXGuh6ecXObbHBHLfOOWu4XTNMNbB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uRFjPXGuh6ecXObbHBHLfOOWu4XTNMNbB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/2014 09:10 AM, Wolfram Sang wrote:
>=20
> Please don't quote large parts of the message f you are not referring t=
o
> it.

Normally I do it. Forgot sorry.

>>> +#ifdef CONFIG_PM_SLEEP
>>> +/**
>>> + * cdns_i2c_suspend - Suspend method for the driver
>>> + * @_dev:	Address of the platform_device structure
>>> + * Return: 0 always
>>> + *
>>> + * Put the driver into low power mode.
>>> + */
>>> +static int cdns_i2c_suspend(struct device *_dev)
>>> +{
>>> +	struct platform_device *pdev =3D container_of(_dev,
>>> +			struct platform_device, dev);
>>> +	struct cdns_i2c *xi2c =3D platform_get_drvdata(pdev);
>>> +
>>> +	clk_disable(xi2c->clk);
>>> +	xi2c->suspended =3D 1;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/**
>>> + * cdns_i2c_resume - Resume from suspend
>>> + * @_dev:	Address of the platform_device structure
>>> + * Return: 0 on success and error value on error
>>> + *
>>> + * Resume operation after suspend.
>>> + */
>>> +static int cdns_i2c_resume(struct device *_dev)
>>> +{
>>> +	struct platform_device *pdev =3D container_of(_dev,
>>> +			struct platform_device, dev);
>>> +	struct cdns_i2c *xi2c =3D platform_get_drvdata(pdev);
>>> +	int ret;
>>> +
>>> +	ret =3D clk_enable(xi2c->clk);
>>> +	if (ret) {
>>> +		dev_err(_dev, "Cannot enable clock.\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	xi2c->suspended =3D 0;
>>> +
>>> +	return 0;
>>> +}
>>> +#endif
>>
>> Can you also please remove this #ifdef and use __maybe_used
>> instead? Better not to have any ifdef in the code.
>=20
> Is this a new pattern? For PM_SLEEP, #ifdef seems to be quite common.

The first suggestion to do it came from CAN maintainer.
It is valid in general for ifdef.
I have checked all our drivers and we are changing them to use __maybe_us=
ed
because then we can easily find out if there is any problem
when function prototype has changed.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--uRFjPXGuh6ecXObbHBHLfOOWu4XTNMNbB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM9DPsACgkQykllyylKDCEcfwCfQsLUeOED+rmyClPSDfDT/DKn
EgEAnjgSaJsz0mfHflcF8d2GEZwYhQGL
=hV/7
-----END PGP SIGNATURE-----

--uRFjPXGuh6ecXObbHBHLfOOWu4XTNMNbB--
