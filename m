Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3CFKMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:12:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3CFKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:12:03 -0500
Date: Wed, 6 Mar 2013 11:11:59 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable regulator
Message-ID: <20130306101159.GA3648@avionic-0098.mockup.avionic-design.de>
References: <1362527485-8611-1-git-send-email-achew@nvidia.com>
 <5136A781.2050303@nvidia.com>
 <643E69AA4436674C8F39DCC2C05F7638629BFE1DB7@HQMAIL03.nvidia.com>
 <5136CBC7.3030803@nvidia.com>
 <20130306070019.GA2436@avionic-0098.mockup.avionic-design.de>
 <51370056.3040508@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <51370056.3040508@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:iPvm/NXBIR2lQz+ZrTmIFLrTZyngj5qOBmbo4eDd+7i
 3CooHfxbsNun2Yim7c8AlUTAh7wYJsqezLzKUl8lCCqZh/HW7O
 Zqkr9XZ59m18nNDBRxswBuPQlW72SckZjcPJ+2niG9WT50tDVs
 nHyktOpkXEXwrrMKK/2IAfrug+SXrxOJO6vN5MHoatB3YhpRcM
 mDMSJLIKloHpKDaGixAycarZmopT6hKdqy52ZPkb1vkIIS8Hls
 rs8SXXWWN8BvQp4LzbsaeQLoIyI+6Kw0Vlm3uJ4xTYGqtqIHfG
 8Ucp8VkH6ZEMTo9KdSaoVJNAa3QcgxK8psIXsedmwgSddMKTSU
 oe0fNqn7zFt/9Ex0zyN6ZHRVVynQ0SEKk4O8s4DsNLBRXhGP+1
 2X6e3S7JuDs5GVCRHan4yYQhg5IN4xHZ6GybLdZrPQVjSzQK/q
 LIHON
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 06, 2013 at 05:37:42PM +0900, Alex Courbot wrote:
> On 03/06/2013 04:00 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Wed, Mar 06, 2013 at 01:53:27PM +0900, Alex Courbot wrote:
> >>On 03/06/2013 11:41 AM, Andrew Chew wrote:
> >>>>>   struct pwm_bl_data {
> >>>>>   	struct pwm_device	*pwm;
> >>>>>   	struct device		*dev;
> >>>>>+	struct regulator	*en_supply;
> >>>>>+	bool			en_supply_enabled;
> >>>>
> >>>>Couldn't you use regulator_is_enabled() and get rid of en_supply_enab=
led?
> >>>>It would also ensure the driver performs correctly no matter what the=
 initial
> >>>>state of the regulator is.
> >>>
> >>>Are you sure this works?  I'm concerned about the (bizarre and unlikel=
y) case
> >>>where this supply is shared with another driver, so I use en_supply_en=
abled
> >>>to track the state of the supply such that I can ignore that case.
> >>
> >>You're right, consumers can share regulators and the calls to
> >>enable/disable need to be balanced. Also there is no way to check
> >>the intensity of the backlight prior to the change to detect a
> >>transition, so I guess your approach is indeed the most appropriate
> >>here.
> >
> >I think the right thing to do here is just enable the regulator when
> >the pwm-backlight driver needs it. If it is shared with other devices
> >they'll have to do the same and the reference counting should only
> >disable the regulator when there are no users.
> >
> >Tracking this via platform data won't work because platform data is
> >statically defined at compile time. So if indeed there was another user
> >of the regulator it enable/disable the regulator at any time and your
> >en_supply_enabled would be wrong.
>=20
> Oh wait. I thought regulator_enable/disable calls needed to be
> balanced, is that not the case? So every consumer receives a
> different regulator handle in case of a shared regulator, which
> becomes disabled if all handles are disabled? In that case yes, we
> won't have to bother about a status variable here and balancing
> calls. Sorry for the confusion.

I think they'll receive the exact same handle to the regulator. Calls
will remain balanced as long as they are balanced in each user.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNxZvAAoJEN0jrNd/PrOh3rEQALr1nte7zY+rlahuC50LOX1e
JGGkSQOr4GJbkqfEeupqRDykQraoQDsimj/aS560X7vCIs0JsLbkoVGZV0ErXIjM
zRyUOzMZnz8xh/LpYyVGqLi+HZzwkWikGgt4G/hTv19QX5kAkLmHfMkf57rMLSa1
a+3e+D1yfXVIKQIOdFqei7IEyWXLhbWDpJ9NGkNHOPlUy8jRB1oWKdZGS4qIOfAk
3EqZXJKW0wEJCyUaPGX4QaAtfhqivr8rXA2FOz4KN5xuJPoBXsLxHkUJscdkXGnY
S18GBzZ2cUCfpOEBZONILNvCpeFTrXY4xOzUkcCqfJnQkJmF5jn2OZdsiRrweTjV
x9uLlNiiziVK9CyORUSe74oRLs7bNdkFPvS1gWH9SrGnzXkYK+34ukhFMFUo4Ptc
2FauDk0n6uMvfPO0+GpnSAwWNO34mY1GQcrzMNC2qOjrWOa8pTwUaTNFKIffqACJ
xwN4Z0c1N/r/5EgnEE0IJJ7WHhcMIcc0Bs0vD0d1gpzcQ5so3S6JU1JOUb1i3mxh
VUrhW+1EeOH2xJaCQrEN8R1kFqACAB+1cKUWvNeasR0q3zVQxKtmXEm9tyrALOg9
5rSW1/m6fGp1tjBPfOEQqKeVqv9/A89BA0VtwLpqdn75GwYcMTSw0aIeKTDiFvKl
iKkq4oha8QNyC5FypT1f
=YhEZ
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
