Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3JWKyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:54:16 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47474 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3JWKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:54:14 -0400
Date: Wed, 23 Oct 2013 12:51:41 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131023105140.GA15082@ulmo.nvidia.com>
References: <20131017071445.GA2502@ulmo.nvidia.com>
 <5260BD8C.7000200@gmail.com>
 <20131022072443.GB8681@ulmo.nvidia.com>
 <52663D6D.5000806@gmail.com>
 <20131022124905.GA24255@ulmo.nvidia.com>
 <52673178.8070805@gmail.com>
 <20131023080002.GB7404@ulmo.nvidia.com>
 <52678D99.8090003@gmail.com>
 <20131023090925.GC11954@ulmo.nvidia.com>
 <5267A691.8050503@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <5267A691.8050503@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 06:36:01PM +0800, Mark Zhang wrote:
> On 10/23/2013 05:09 PM, Thierry Reding wrote:
> > On Wed, Oct 23, 2013 at 04:49:29PM +0800, Mark Zhang wrote:
> >> On 10/23/2013 04:00 PM, Thierry Reding wrote:
> >>> On Wed, Oct 23, 2013 at 10:16:24AM +0800, Mark Zhang wrote:
> >>>> On 10/22/2013 08:49 PM, Thierry Reding wrote:
> >>>>> On Tue, Oct 22, 2013 at 04:55:09PM +0800, Mark Zhang wrote:
> >>>>>> On 10/22/2013 03:24 PM, Thierry Reding wrote:
> >>>>>>> On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
> >>>>>> [...]
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> Okay, I just want to set the "notify" function pointer in "struct
> >>>>>>>> platform_pwm_backlight_data", because I want to tune the brightn=
ess
> >>>>>>>> value before the pwm-bl sets the brightness to hardware. I don't=
 know
> >>>>>>>> how to do that, unless we define the platform data explicitly.
> >>>>>>>
> >>>>>>> Okay, my question should have been what you need the functions fo=
r and
> >>>>>>> why you think you need them.
> >>>>>>>
> >>>>>>
> >>>>>> If I understanding you correctly, I suppose I've said that: "becau=
se I
> >>>>>> want to tune the brightness value before the pwm-bl sets the brigh=
tness
> >>>>>> to hardware".
> >>>>>
> >>>>> Why do you want to tune the brightness value? What are you trying to
> >>>>> achieve?
> >>>>>
> >>>>
> >>>> Oh, Tegra has a feature named PRISM(aka SmartDimmer). It changes the
> >>>> color value to make the display looks bright so that we can reduce t=
he
> >>>> backlight brightness to save power. So everytime PRISM is triggered,=
 we
> >>>> call "backlight_update_status", then in the "notify" callback, we ch=
ange
> >>>> the brightness value which pwm-bl provides by considering the PRISM
> >>>> compensations.
> >>>
> >>> If you automatically call backlight_update_status() everytime PRISM
> >>> gives you new data, can't you just pass the correct value in in the
> >>> first place so that you don't have to tweak it in the .notify()
> >>> callback?
> >>
> >> OK, how to do that? -- "pass the correct value in in the first place"?
> >=20
> > Well, if you call backlight_update_status(), then you can pass in a
> > brightness value, right? You usually do that by setting the backlight's
> > props.brightness field.
> >=20
> > So when PRISM gives you new data, you could just read out the current
> > brightness, compute the new one based on the current one and the PRISM
> > data, set the props.brightness field to that value and then call
> > backlight_update_status().
> >=20
>=20
> Okay, anyway, I got the idea. Actually it's simpler. :)
> I'm just curious that if we can do that in this way, why we need
> "notify" anymore?

We don't need it any longer for DT, you've just proven that. =3D)

However we still need to support board files, and the .notify() callback
is the only way for board files to use board specific means to enable or
disable the backlight depending on the brightness value.

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ6o8AAoJEN0jrNd/PrOh/HIP+wYxrOrUfyozovAOC4oYsk/t
nbm1mR4d6kUiGljPiIW/6TXjd06ruBe+h52MMgS9rqIP72BueSGKxR84PNqQ63gL
SQXvl6MC/CNE+zOs9zhS4zrW8kNwL74iRO/+2YU9UuExWnCobs7MO3boNZUwXJPM
MLAXKQPDepe0EUAc/xzyijtox35PNDSgX2vu1V5g2RbBZTt8kK5Iwis1zskIr4/h
HX18z7VpIpRWGimb6xkZHM2tuthgWwbucJOtYrPTT550ql6l68dXCEvRO3g6juOZ
9K7SvtyR/VZk6rkbF/nbMFURdAohiL66EFXZgcnihf22Eby3JtN4adMBnxR5C+51
rMEzBo1dPnASKOrDGEmu0JI6NnuIdMswHkIO2gJHUqJuOJ5S3XYlKzGwhm4ZxgV+
4Kq6rJ/Z62//YFwzL3FZ04JwTCcmoKSCKZKydJS5lvvzoWSL9I66VmI4Vc55hmZK
8RiKVy/LWyzYhTLTpOgdEzYGDhH/uvnODd99trkXQKckIUdILST57ofWypCcw4Lj
S5IzUVlUO0DJReEBCq0MSmZCePR7e18l08zK93uWKeGm+3rhbI9oB3XZfSUNSw35
NpKrt8dji8yZ+JQniOQARTlknV1tQ7A0796+50i6ST7Bp0g9hw617XGdM+pIqXnm
JhOBkxiUHZzWieBG63OO
=orWi
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
