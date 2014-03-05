Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbaCEXZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:25:24 -0500
Received: from ring0.de ([5.45.105.125]:47941 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbaCEXZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:25:21 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 6 Mar 2014 00:25:14 +0100
From: Sebastian Reichel <sre@debian.org>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org,
        hns@goldelico.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] power: twl4030-madc-battery: Convert to iio consumer.
Message-ID: <20140305232513.GA9542@earth.universe>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
 <1394052739-8589-2-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1394052739-8589-2-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marek,

I just have one comment:

On Wed, Mar 05, 2014 at 09:52:17PM +0100, Marek Belisko wrote:
> [...]
> -static int madc_read(int index)
> +static int madc_read(struct iio_channel *channel)
>  {
> -	struct twl4030_madc_request req;
> -	int val;
> -
> -	req.channels = index;
> -	req.method = TWL4030_MADC_SW2;
> -	req.type = TWL4030_MADC_WAIT;
> -	req.do_avg = 0;
> -	req.raw = false;
> -	req.func_cb = NULL;
> -
> -	val = twl4030_madc_conversion(&req);
> -	if (val < 0)
> -		return val;
> -
> -	return req.rbuf[ffs(index) - 1];
> +	int val, err;
> +	err = iio_read_channel_processed(channel, &val);
> +	if (err < 0) {
> +		pr_info("Error:%d\n", err);

This should be "Error: %d\n" (with a space).

Apart from that you should use dev_info() or dev_err(), so that the
message is properly prefixed by the device. Currently there is no
hint where this error message is generated.

> +		return err;
> +	}
> +	return val;
>  }
> [...]

After fixing this you can add

Reviewed-By: Sebastian Reichel <sre@debian.org>

-- Sebastian

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTF7JZAAoJENju1/PIO/qavQEQAIbXsimUlwv+td5tnBSSoYNk
nve/ssCPA+gKGdksDESk8e+HhG4+zeERk/F8utmKtTzLIt7cKMPLWfuX5GLDN/Ad
EQ0xjuO8icrtxFz66RCFp6xINsn5CNdquG/urAPM0k8RbBVyGDIDZyZyD2AhiDPC
3JAK7yNCm0yGhZvS4czP6ozRYzIsgylpGO9lWgupGWm/w7bhP/dW/yC4s9XWT//v
bc1Bv6qvBjooWg8WnrEWhmLmY2m6eTmyIOHg0C2KuJeBYiKABbIcHJsp/tlT5lY1
wlODM8OUfoRFpCVKAE0KKYnsjeyzDraqpE0UFLW6G6shNVTsRaca1m5fMA2aJiLt
wFrW6UHRA8DoCqDxofOVT61VOglpc9z8j37BMdc4Kpk4MpKarpIvpvhlcqyWYK1a
XHtErVm7xga8Y7HvBug+KvtoxOX28dwR/io4BtfF5ol5OQzJNym4gXILr7io+AiC
Q6yIF46QTmYIgZR5kzUd0raFDfaUBACsfkwd4vqZxYMPj59BJBkUD4QxQ83/FvRi
ewSFbNVN1jxP28k/l4pKRsY3dIoR8asgCK+RJRLt9xPizUvjphkYMR+xfUvsYPV8
ax2b7z6jnVa1Z+pA6MVP1eEYNQMlSCWTJ0z0+5h2K6HY0+ilPxsZ2Fk88aJJXgJN
XrIM70beavCMlV5p/Rdj
=xykJ
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
