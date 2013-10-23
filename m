Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3JWLA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:00:57 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:46943 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3JWLAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:00:55 -0400
Date: Wed, 23 Oct 2013 12:58:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131023105821.GC15082@ulmo.nvidia.com>
References: <5260BD8C.7000200@gmail.com>
 <20131022072443.GB8681@ulmo.nvidia.com>
 <52663D6D.5000806@gmail.com>
 <20131022124905.GA24255@ulmo.nvidia.com>
 <52673178.8070805@gmail.com>
 <20131023080002.GB7404@ulmo.nvidia.com>
 <52678D99.8090003@gmail.com>
 <20131023090925.GC11954@ulmo.nvidia.com>
 <5267A691.8050503@gmail.com>
 <5267A8F9.9050907@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <5267A8F9.9050907@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 06:46:17PM +0800, Mark Zhang wrote:
> On 10/23/2013 06:36 PM, Mark Zhang wrote:
> > On 10/23/2013 05:09 PM, Thierry Reding wrote:
> >> On Wed, Oct 23, 2013 at 04:49:29PM +0800, Mark Zhang wrote:
> >>> On 10/23/2013 04:00 PM, Thierry Reding wrote:
> >>>> On Wed, Oct 23, 2013 at 10:16:24AM +0800, Mark Zhang wrote:
> >>>>> On 10/22/2013 08:49 PM, Thierry Reding wrote:
> >>>>>> On Tue, Oct 22, 2013 at 04:55:09PM +0800, Mark Zhang wrote:
> >>>>>>> On 10/22/2013 03:24 PM, Thierry Reding wrote:
> >>>>>>>> On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
> >>>>>>> [...]
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> Okay, I just want to set the "notify" function pointer in "stru=
ct
> >>>>>>>>> platform_pwm_backlight_data", because I want to tune the bright=
ness
> >>>>>>>>> value before the pwm-bl sets the brightness to hardware. I don'=
t know
> >>>>>>>>> how to do that, unless we define the platform data explicitly.
> >>>>>>>>
> >>>>>>>> Okay, my question should have been what you need the functions f=
or and
> >>>>>>>> why you think you need them.
> >>>>>>>>
> >>>>>>>
> >>>>>>> If I understanding you correctly, I suppose I've said that: "beca=
use I
> >>>>>>> want to tune the brightness value before the pwm-bl sets the brig=
htness
> >>>>>>> to hardware".
> >>>>>>
> >>>>>> Why do you want to tune the brightness value? What are you trying =
to
> >>>>>> achieve?
> >>>>>>
> >>>>>
> >>>>> Oh, Tegra has a feature named PRISM(aka SmartDimmer). It changes the
> >>>>> color value to make the display looks bright so that we can reduce =
the
> >>>>> backlight brightness to save power. So everytime PRISM is triggered=
, we
> >>>>> call "backlight_update_status", then in the "notify" callback, we c=
hange
> >>>>> the brightness value which pwm-bl provides by considering the PRISM
> >>>>> compensations.
> >>>>
> >>>> If you automatically call backlight_update_status() everytime PRISM
> >>>> gives you new data, can't you just pass the correct value in in the
> >>>> first place so that you don't have to tweak it in the .notify()
> >>>> callback?
> >>>
> >>> OK, how to do that? -- "pass the correct value in in the first place"?
> >>
> >> Well, if you call backlight_update_status(), then you can pass in a
> >> brightness value, right? You usually do that by setting the backlight's
> >> props.brightness field.
> >>
> >> So when PRISM gives you new data, you could just read out the current
> >> brightness, compute the new one based on the current one and the PRISM
> >> data, set the props.brightness field to that value and then call
> >> backlight_update_status().
> >>
> >=20
> > Okay, anyway, I got the idea. Actually it's simpler. :)
> > I'm just curious that if we can do that in this way, why we need
> > "notify" anymore?
>=20
> Oh, by the way, how about "check_fb" fops? Is there some kind of
> substitution as well? I mean, if I wanna set "check_fb" and also want to
> define the backlight device via DT, is there a way to do that?

No, there's no substitution for that. .check_fb() is used to verify that
a backlight device is associated with a framebuffer device. There are
better ways to check for that with DT, although nothing has been merged
into mainline yet.

Thierry

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ6vNAAoJEN0jrNd/PrOheogQAKfa4VWTqzXxAE2s8g5+gh8U
Bb3L0ijlG0dedBXW5awc7uhvJzdebw4SrV5tgEyt4+bXPajBQx3GPZmGj1viMx9h
mc5Mgx9czPH/vwdKBqRRVqF5URP8xgJ7QrXClf2cim2g5dl/A4G+hBJuOLpiU4jG
YGDaFIdSNWnbAMtPno/VPPGdgHYm4qIC0qWrXlMA+7xmY7GpH5TK4f36HLxcIGVL
Oud1b4vGZ6PLoVLXt46l8oJKMoUNdi9E+FuVzYLkNWa2H9fm6Q286P0NG20uDC8Z
wQjIxzC1yg0biCXlLUYPhWtDJQ9+e78KEHwb0mi+CmxxgT0WbMVYELDGrOXYSOat
vK64qMvZk7JqsWbDMLUZVkPxx/q9hSct9vq2vbJWHMgiBcINvd4WLMsnevX1yzHl
/HRGyBVv+sgJjE/GbyzXQCm7eY4NJnGGqluWefvNvbhPFFTmUJB1p6Uk7bNCnKGn
+BGAAt8hUezFM6iFXL36/SbRyUE0UMgX8qkZZO3/YyVLMw3tCeYb/aKJ4Zomgxa9
728hT8y7TCUUIDsKVF4T/csGROa9YfsJSHcc4XzekEYHitXHJzhwyvH9weRusGDe
leZduW0c4Gr08HaiJxF/phU1tcqqEDjhfWlzYrAUC1n3dc4WUjs7azd72EghBwEJ
6ydP9PiwdoTto3Uad9Ih
=8ADE
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
