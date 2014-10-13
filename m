Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaJMP6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:58:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39283 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbaJMP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:58:18 -0400
Date: Mon, 13 Oct 2014 10:57:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] rtc: omap: fix class-device registration
Message-ID: <20141013155707.GH21709@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-4-git-send-email-johan@kernel.org>
 <20141010175919.GO31348@saruman>
 <20141011095947.GB18988@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="byLs0wutDcxFdwtm"
Content-Disposition: inline
In-Reply-To: <20141011095947.GB18988@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--byLs0wutDcxFdwtm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 11, 2014 at 11:59:47AM +0200, Johan Hovold wrote:
> > > @@ -450,14 +441,14 @@ static int __init omap_rtc_probe(struct platfor=
m_device *pdev)
> > > =20
> > >  	/* handle periodic and alarm irqs */
> > >  	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
> > > -			dev_name(&rtc->dev), rtc)) {
> > > +			dev_name(&pdev->dev), pdev)) {
> > >  		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
> > >  			pdev->name, omap_rtc_timer);
> > >  		goto fail0;
> > >  	}
> > >  	if ((omap_rtc_timer !=3D omap_rtc_alarm) &&
> > >  		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
> > > -			dev_name(&rtc->dev), rtc))) {
> > > +			dev_name(&pdev->dev), pdev))) {
> >=20
> > i don't get it. Why pass pdev as cookie when all you need is rtc ?
> > Doesn't sound very good to me. Also, IRQ handler *must* be registered
> > only after RTC is registered. That's because if you request an IRQ here,
> > you could already have a pending interrupt and since you won't have a
> > valid rtc pointer you won't be able to clear the interrupt line.
>=20
> We don't need the class device (rtc pointer) to clear the interrupt
> line. The iomem base is enough, and that is static until Lokesh adds the
> struct omap_rtc_dev abstraction. Then we pass that as the cookie.

I wonder how that patch will look like ;-)

> And all RTC interrupts have been disabled, and pending interrupts
> cleared before registering the handlers so that should not be a problem.
>=20
> To the contrary, once the class device has been registered user-space
> could enable interrupts at any time and that is why everything should
> have been set up before.

alright, got it. Thanks

--=20
balbi

--byLs0wutDcxFdwtm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUO/ZTAAoJEIaOsuA1yqREX2YQAISJkbdj9LvlLe7tZSIGuarp
NDlfDeTVp4sUbCMaR4MBT/ROQAF1sw96JC+xjDSEHQNkiLsJSVCt+j8U/HUvoTi5
omsDTrJtNhTWuAGHXIO+e1pUQlCta6efXWdP/6sCXSb28OMHiFARK0ee//+dOFRy
0jQsp/Dg8dK4zH6eflxfQrr2mVbFRallq6bj1St+LiKX+SIhayyKYRHBXq93kzEG
dcpt3MKtL62aYMCD/gGbS1/QAuP7Y9/6uCNw9OHf4Ekd+24YeWJGp7Ez/ZZTBymK
yvXfe8T7lanUrPU+Cnnolyd67sdp7lDUYmWzqiSD7/BzQcDLRibQjj3cNCp5GHz5
RR8Pq3KuoUlthzbyKYpnWG50exm4uz7yixjTn609KOQ3E5qLxXgcy3Zw9CmuylXo
W7BKWffHJFYEWdZz4onDbQLZ6Xlf28Y44yhRBO5D6cK2GrTuJ5Kl6lYgF09hYCHa
/0SFmEBXkcyiW2wD7tl4A6wEJZ9fG11Jxg90DNl9rSoX/D6OXo2uspprJ7zyZ/Pp
CuawpYi/M8vCIadFRV4d9uNu5QHj31VrAmR6TanddH562za8KXpgMLK71n2zo1Ap
D+me7jRLM4BIqMErnvEzYjUJePBDN6WSPKtbfgTq6k4zWr2QZAPMs4UlbpB2XAWn
56Ni+MgytrVzNDzXcFSI
=NIq4
-----END PGP SIGNATURE-----

--byLs0wutDcxFdwtm--
