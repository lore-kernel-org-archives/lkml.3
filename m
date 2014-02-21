Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaBUIUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:20:53 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35137 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753904AbaBUIUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:20:04 -0500
Date: Fri, 21 Feb 2014 09:16:03 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the Qualcomm QUP I2C
 controller
Message-ID: <20140221081603.GA3931@lukather>
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Thu, Feb 20, 2014 at 04:38:10PM -0800, Bjorn Andersson wrote:
> +static int qup_i2c_probe(struct platform_device *pdev)
> +{

[ snip ]

> +
> +	qup_i2c_enable_clocks(qup);
> +

[ snip ]

> +
> +	pm_runtime_set_autosuspend_delay(qup->dev, MSEC_PER_SEC);
> +	pm_runtime_use_autosuspend(qup->dev);
> +	pm_runtime_enable(qup->dev);

Since the device is already woken up, you probably need to call
pm_runtime_set_active here.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTBwtCAAoJEBx+YmzsjxAgvTAP/AgnTdalfmCBrk92uksd8D0Q
WpBW6Rbjm0HSKZkjoqashRQqxyUSWeAyfQV9/dpiW3mHb/O0M5u+Bz2nlI7KpNF3
UruTKE02DuDecfZf094nt8qDAQO7ai4rng5gm2GoqQRGpmobfwGv0BzSWqeTLhJs
EVOhzVhs3/7POGEjIGbwSbzHz7mTaXoFwW+8Fencfe2TJQq3k/E0hKIxQRhfWl6f
fRLugNYUTZhDJzbYdlDWHNKhAcQATMJOFzSNGv1iY/BNK1VDFiAjjGZbYntD44mb
GhJlVoLD6nlEXsLd8fCBfS/s26G5IREoYZQp2hvn3XMK8y0P35iA7Aq2BtcSH5tw
wXCeMZfg5ElG3jLTg57U4Va7/SAqPpXZtB7JMbBYGDlccl7pLvZde7kLDk4xV2J7
EGTi8pdKUh4V5I+4Gl0fYXGqkXvph4awR0ZVPYdzveKhs2LqCGphsP1diDSsukm3
V8k0nAAcqef5DXkxLraz+CCdZOZAZZE7hCQxVPUWRD6lBnliWghBbuyQWK0GvS9/
hg6HU8AkLqC1OY6Im7PrawHhHfJZnCWPt/MvWfKDXVEzx09HgzVP8K/gdo6zcplr
oIe+uBcFlx5Ov3Y/L3cbG47fVjgd3Ao6WdPFieNKoc9bKY5OaqGMvL7wyn/KEuMX
bMFa5zXQbI1ifTBWMgmY
=S/gg
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
