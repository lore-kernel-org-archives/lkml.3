Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaDGLRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:17:35 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42401 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGLRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:17:32 -0400
Date: Mon, 7 Apr 2014 13:16:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 08/16] backlight: pwm_bl: set pwm polarity when using
 platform data
Message-ID: <20140407111639.GB26985@ulmo>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-9-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <1395234209-15546-9-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 02:03:21PM +0100, Alexandre Belloni wrote:
> Set inversed polarity when .pwm_active_low is set in the platform_data. W=
ith
> device tree, this is taken care of by of_pwm_xlate_with_flags(), called f=
rom
> of_pwm_get().
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 8 ++++++++
>  include/linux/pwm_backlight.h    | 1 +
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index b75201ff46f6..ffdd3b2b2742 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -309,6 +309,14 @@ static int pwm_backlight_probe(struct platform_devic=
e *pdev)
>  	if (data->pwm_period_ns > 0)
>  		pwm_set_period(pb->pwm, data->pwm_period_ns);
> =20
> +	/*
> +	 * The DT case is taking care of polarity in of_pwm_get(). For the
> +	 * non-DT case, set the polarity from platform data.
> +	 */
> +	if (data->pwm_active_low)
> +		if (pwm_set_polarity(pb->pwm, PWM_POLARITY_INVERSED))
> +			dev_err(&pdev->dev, "impossible to invert polarity\n");

Could this perhaps be solved by adding a field to the PWM lookup table
that's used for non-DT cases? The idea being that we can use the same
interfaces for DT and non-DT cases, so we should try to move both
towards the same representation.

Thierry

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQokXAAoJEN0jrNd/PrOhYwQP/3iS086fybBevF1BDVESvgLK
Z+iw30tfhnbHyAoxyc7044d3+BNgtdRFR/EF3TPUrnwSbK3FaU6zfg+iacxvdor4
Ti/yH/FlV/Y1/Z0Ku5LdEXX+3wYu76NDmrastygh/gSqAOJWNgnijEEBGxboBWKg
XFZNCoPLCWFQaZ0Mm2Szhr/XIA6ENU9Lul+c5TFHYI85HhkRwEI3NrVeR+LkqQEY
J/a9FpGAExNvm3Ks4U3tKVvj7wEQkWiGUraGZsV/ecITsTN0dJ1M92ATtnvkMffl
DVKNqkmoY3p/2bzThEhAVFq/N+QU6yIQwzt4iHrsadnqeIrajzHhfWs4hYUt7Wz9
AR2RNcTUxXRoLNR7lJtXrx1gFAcYXqYzub09ghtMM25tpUAdX6nfQ2orIsFSBYi9
IT0bERQySx97gKsr6TTW8epwZ8wFt7AKjOSUIi4a/SqliwIOAlMOC5WUaQwZ/e1P
PAwEA70B+9jqlAPqWXSssno2DTGuZ8Pa6WZmYrq+WizOpicE+Bvx0HdC3+66ojt6
K0CjQoPFC+2vF0og1M/N+UGg4CC+jBJNO/mHBx9TLWOfhEI5lRrjZtzUkj64KUmY
bnyNtH/0Zclic/JRMOQA1oUK8wo35dpFDGm5IvkLX7YE/I1cCffV+9WdHo8O4KPx
dmy11yA2Tc1yW99vUWpk
=cgnq
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
