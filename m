Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaJGI2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:28:25 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40721 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaJGI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:28:20 -0400
Date: Tue, 7 Oct 2014 10:28:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bart Tanghe <bart.tanghe@thomasmore.be>, matt.porter@linaro.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v5]pwm: add BCM2835 PWM driver
Message-ID: <20141007082816.GC24254@ulmo>
References: <1412250075-3082-1-git-send-email-bart.tanghe@thomasmore.be>
 <54335F80.9050005@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <54335F80.9050005@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 08:35:28PM -0700, Stephen Warren wrote:
> On 10/02/2014 04:41 AM, Bart Tanghe wrote:
> > Add pwm driver for Broadcom BCM2835 processor (Raspberry Pi)
> >=20
> > Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
> > ---
> > Changes in v5:
>=20
> By v5, I would drop "rfc" from the email subject.

And resend as well. Use resend only if you're resending without having
made any changes.

> > diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
>=20
> > +static int bcm2835_pwm_request(struct pwm_chip *chip, struct pwm_devic=
e *pwm)
> > +{
> > +	struct bcm2835_pwm *pc =3D to_bcm2835_pwm(chip);
> > +	u32 value;
> > +
> > +	value =3D readl(pc->base);
> > +	value &=3D ~(PWM_CONTROL_MASK << PWM_CONTROL_STRIDE * pwm->pwm);
> > +	value |=3D (PWM_MODE << (PWM_CONTROL_STRIDE * pwm->pwm));
> > +	writel(value, pc->base);
> > +	return 0;
> > +}
> > +
> > +static void bcm2835_pwm_free(struct pwm_chip *chip, struct pwm_device =
*pwm)
> > +{
> > +	struct bcm2835_pwm *pc =3D to_bcm2835_pwm(chip);
> > +	u32 value;
> > +
> > +	value =3D readl(pc->base)
> > +	value &=3D ~(PWM_CONTROL_MASK << PWM_CONTROL_STRIDE * pwm->pwm);
> > +	value &=3D (~DEFAULT << (PWM_CONTROL_STRIDE * pwm->pwm));
>=20
> What is this second mask operation intended to do? The first mask
> operation already clears all the control bits, so clearing them again
> doesn't seem useful.

I suspend that you'll also want to use pwm->hwpwm instead of pwm->pwm.
pwm->hwpwm is the index of the PWM for the chip, whereas pwm->pwm is a
global index so the above breaks if another driver registered a PWM chip
before this driver.

Thierry

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUM6QgAAoJEN0jrNd/PrOhC4gQAKHRAqnveK8ZHZ+ps8lYscnH
ndqDjutkw3JBDzkt5WADV/RS/9fy2mMS0RF1Y8wkyvAasHGgkeKUV5LQ1xo8ak9y
kenRLuJWQ+SEXLRePUcErdFIUgNjllamQQqlfNXdyF5IlqVJeAAaQZpb292DMOWY
BShDuAYT66ciA8hke5efQdamv0kb+jY2Qi2HtW3TphJTrFbL2nD+BcXJiHWIBhIF
kD24ECJfx6lrIqo9JddAJwsHn2S7ot0IwpXa/53I0PTpncWHBtIeGOSJqD9+iqG7
UnC794W/gZ7kVSqVip7V/GpBmcwn6fMAhuqlrWzHMpPAs3VzoKI4wEyAHNkT5S8C
7aSrUKezGmyYNrvhCEViVa9+M1f3kvUPaOP6Ge8OfYFl+nj7JdZtnaMY7ccCb16A
lFaeVLJetDooKnzXRwVnD+BMGAWrx0azWxm3mdMpV4nrS2QS+QI89tg/qFTe0jV/
JY9pYfu+QM1t1IJDBj5V1qe9CaZ6XR8uveXFsId4CAAUeONYC0hHxsUeTcnWVe+x
bpa7IxSGzPQZdmHs2CaeH1woja5kJmAaPWKJ/TPV6HGrx82wtlw34vOMOqhSRd+M
XO7DwOGb8EDmpn3jdCf8amhAy5YMQ693KDDyJo8oER4PZoeI9cqH4GQYaHlRzDaW
RbJ6f8USVYcd9mrkz4DI
=aNfr
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
