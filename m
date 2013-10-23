Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3JWK5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:57:32 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63114 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3JWK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:57:30 -0400
Date: Wed, 23 Oct 2013 12:54:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131023105456.GB15082@ulmo.nvidia.com>
References: <20131017071445.GA2502@ulmo.nvidia.com>
 <5260BD8C.7000200@gmail.com>
 <20131022072443.GB8681@ulmo.nvidia.com>
 <52663D6D.5000806@gmail.com>
 <20131022124905.GA24255@ulmo.nvidia.com>
 <52673178.8070805@gmail.com>
 <20131023080002.GB7404@ulmo.nvidia.com>
 <52678D99.8090003@gmail.com>
 <20131023090925.GC11954@ulmo.nvidia.com>
 <5267A582.9070504@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <5267A582.9070504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 06:31:30PM +0800, Mark Zhang wrote:
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
> The param of "backlight_update_status" is "struct backlight_device *".
> So you mean after I get a pointer of correct backlight device, just set
> the brightness value I want to it's "props.brightness" directly?

Yes.

> I think the "struct backlight_device" should be opaque(although it's
> definition is in include/linux/backlight.h, I know that), so it's better
> not to touch it's member directly, that's why I wanna use that "notify"
> callback.

Well, backlight_update_status() is the only way to change the brightness
of a backlight. If nobody ever calls backlight_update_status() then the
=2Enotify() callback will never be called either.

By the way, what method do you use to control the backlight brightness?
Do you use the sysfs interface from userspace?

Thierry

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ6sAAAoJEN0jrNd/PrOhjWcP+QGu2R+vURzzuNBU/ctEP+Eo
nLOSYH00KzEcPiath1IqLJmRH1tPXTm/3qYti+58cqk9UQJtf4VDUemxVWfbAtMr
buHOdbuZkpWtgIa1wNGqaiPaoQNl86P5F9LESOOgODL/5QHzxHhhZK6HRcwmFDrk
WFMWat+uvJ5V4uRmaynJQDNB80F+5b8XUUIJEo9z5bz63atuyDGrBXCfLfuRQW7V
rVtncdmHRHKEriIbzvXiegkMo7Aq7USRyHu7gJVcAMvYbFTTZyXjgEj9Tn+h0hNx
JTLAc1TE0n7zXAmFWHtbopb/yAiuhaVGhIJKnynDElOBpRsuN5Oe/QUYazPKP+sF
9JYKUWrLTyjjzgtJc1oYnErqfz0y39H3eB5T5X0Bs1gFMi5jxCfUsdeAOylzHQhJ
kUFtJviWngxm29PXJKVBr6D0YetLrBe9lMH4z82vGPx7rO7MOtXpcIjUb0Xxq2+D
W1s5TXnaxtTitcwD5ByVi6nlr6s/7SM/3ZakzwiYBk+J8sH8hAN4b1nx11z/WFo4
4GFu8k3T4ZfQb8fo+pLPJqguT9G/JZTsBMgiF7I7+iydXHIGTcyDq/tPm4HQ3r7t
CpazY/l2UrvAaNOXE2xpBTWPl+XbGyA4NDhb+J2YFf6XnLjvbGkFwZaDBCTpQPGu
+kCy2/NzutKJiojgZcnB
=2OjZ
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
