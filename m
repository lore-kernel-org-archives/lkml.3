Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3CFHKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:10:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3CFHKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:10:47 -0500
Date: Wed, 6 Mar 2013 08:10:40 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable regulator
Message-ID: <20130306071040.GC2436@avionic-0098.mockup.avionic-design.de>
References: <1362527485-8611-1-git-send-email-achew@nvidia.com>
 <5136A781.2050303@nvidia.com>
 <5136C423.3070400@wwwdotorg.org>
 <5136CC88.6080200@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <5136CC88.6080200@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:F+mxAZyq93PCsZaY1Rs1wYt+oySqyzBaX32gK4Br9R2
 MXBzeyOSdlNF7yz20HudUFUKzHzp9WP3rBnTkivjdy0mpJAUVg
 HptkMocVmCS97DXHhIBnVxicpvCpaFiAe07dUJ4UDq4eJ8HUn1
 09liD6Mf6MwDvT11VB3Iit7FHo/Xrdu7SBHRDMdIOqyEpJL38g
 iZp++XTJGMdXjJnowiI2pwxI+mL/WlmJoB0wFBDQC/jPUzHkvo
 Ui1cVcZxr4N0+yo2EFXPu5c3ovPnXkC2k4M2cZLQPm2r/9D+Uw
 fqJ6UBQMWziLwQTT7Rql3Vm4mHKuuLUPZEG8IDheI7ysRuNTng
 A9gBPfpUPsLVyf7RqrLQYhNgA0AZDaOzOMpbtAjEf/fhglT/dQ
 3f3Nb0TZiCfURObwNwKj999oxVCNAoKVjU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 06, 2013 at 01:56:40PM +0900, Alex Courbot wrote:
> On 03/06/2013 01:20 PM, Stephen Warren wrote:
> >On 03/05/2013 07:18 PM, Alex Courbot wrote:
> >>On 03/06/2013 08:51 AM, Andrew Chew wrote:
> >>>The backlight enable regulator is specified in the device tree node for
> >>>backlight.
> >
> >>>diff --git a/include/linux/pwm_backlight.h
> >
> >>>   struct platform_pwm_backlight_data {
> >>>       int pwm_id;
> >>>+    struct regulator *en_supply;
> >>
> >>You should not have this here. Platform data is supposed to provide the
> >>necessary information for the driver to resolve the resource - not the
> >>resource itself.
> >...
> >>There is one catch though: in case you don't want to use a regulator,
> >>and thus have none defined, regulator_get() will return -EPROBE_DEFER,
> >>so you cannot distinguish between "no regulator needed" and "supplier
> >>not ready yet" and your driver will always *require* a regulator. So at
> >>the end of the day you might still need a "use_enable_regulator" in the
> >>platform data to explicitly ask for probe() to look for it. This
> >>variable would also be set by parse_dt() if the "enable-supply" property
> >>exists.
> >
> >A driver that requires a regulator always requires that regulator. If a
> >particular board doesn't have SW control over the power source, you're
> >supposed to provide a dummy (fixed) regulator so that the driver doesn't
> >care about the difference.
>=20
> That's good to know, thanks. So does this mean that Andrew should
> make the enable regulator mandatory and update current users to
> provide a dummy one?

That would be the right thing to do. I was planning to move all users of
pwm-backlight to use PWM lookup tables as well at some point (in order
to get rid of the legacy pwm_request() calls), so maybe we can do both
in one go.

Thierry

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNuvwAAoJEN0jrNd/PrOhj1EP/jHq9gEaXOQBD5Vc/MbBabU/
mlDCBLHtpvs+DhPnSIlHRvbhmdhgpCbtAFDZLBoKURxYp2dVE+/cOMH1sW2WKv+2
M8mr2xe8OXvjZ1QBpERNuyhS/h0UJvCu3+HbhmOcXzLPDVc6YlYK4SpoIz5Rm+m+
WWKeTihbyhcsLdCXgxYr0IjRpV4oKrRvmoYumoLoBi85mYp+9cnkBg7U9top0q3D
Sk0F5WrpixaY39C3i847Odthr86N8foSaxcOsTb20uLRIoDttOq/LrdhQ8SsZ740
UBhoxrfF18ogZvHfYMRaNhjnTjuBJYkjXz2xn3NdCCV52pcx4vpaQ5XmVALLH2LX
Hv3721v87E9ja/qvHRJEqanDTgx3IFnArYtA0GilrxC5kTVF0hL0DYToNVYpGtDk
yC0+UtO0GI5PNLC2i4AtIOahoc3sOZCNX2IJLvXwL+5dXgU7GDtDSjXV8IrWoPqj
XqBvyAQgn0nDrWAlI93/1N9jDKhm+ibVZk5t1doYpZxd4yUlpvocgiK/33WjbH2F
orbg8ILvIZ9spNGAw/qvvrFVvv3iKA8lyZTGIxpcwBVFwlv9UdG5r4hRufIoMFTJ
Tam7oFrwqzRh0SxPOo3eTGpJscE5T4OyI53O1QTb+Xdvh44z9RggnngAGU35Mhr8
bLgRUBR4OqGEY5mrPh5w
=Swot
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
