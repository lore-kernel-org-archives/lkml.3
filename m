Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab3DCIP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:15:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54383 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206Ab3DCIPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:15:53 -0400
Date: Wed, 3 Apr 2013 11:15:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <sarah.a.sharp@linux.intel.com>, <rob.herring@calxeda.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>, <t.figa@samsung.com>,
        <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130403081532.GE25837@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
 <515BB951.40702@ti.com>
 <CAFp+6iG8WdWHXVCANx77OiTXLeZ-4qE4jySWqPLhfR1KOEP4fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6v9BRtpmy+umdQlo"
Content-Disposition: inline
In-Reply-To: <CAFp+6iG8WdWHXVCANx77OiTXLeZ-4qE4jySWqPLhfR1KOEP4fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6v9BRtpmy+umdQlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 11:48:39AM +0530, Vivek Gautam wrote:
> >> Adding  APIs to handle runtime power management on PHY
> >> devices. PHY consumers may need to wake-up/suspend PHYs
> >> when they work across autosuspend.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> ---
> >>   include/linux/usb/phy.h |  141
> >> +++++++++++++++++++++++++++++++++++++++++++++++
> >>   1 files changed, 141 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> >> index 6b5978f..01bf9c1 100644
> >> --- a/include/linux/usb/phy.h
> >> +++ b/include/linux/usb/phy.h
> >> @@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(en=
um
> >> usb_phy_type type)
> >>                 return "UNKNOWN PHY TYPE";
> >>         }
> >>   }
> >> +
> >> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
> >> +{
> >> +       if (!x || !x->dev) {
> >> +               dev_err(x->dev, "no PHY or attached device available\n=
");
> >> +               return;
> >> +               }
> >> +
> >> +       pm_runtime_enable(x->dev);
> >> +}
> >
> >
> > IMO we need not have wrapper APIs for runtime_enable and runtime_disable
> > here. Generally runtime_enable and runtime_disable is done in probe and
> > remove of a driver respectively. So it's better to leave the
> > runtime_enable/runtime_disable to be done in *phy provider* driver than
> > having an API for it to be done by *phy user* driver. Felipe, what do y=
ou
> > think?
>=20
> Thanks!!
> That's very true, runtime_enable() and runtime_disable() calls are made by
> *phy_provider* only. But a querry here.
> Wouldn't in any case a PHY consumer might want to disable runtime_pm on P=
HY ?
> Say, when consumer failed to suspend the PHY properly
> (*put_sync(phy->dev)* fails), how much sure is the consumer about the
> state of PHY ?

no no, wait a minute. We might not want to enable runtime pm for the PHY
until the UDC says it can handle runtime pm, no ? I guess this makes a
bit of sense (at least in my head :-p).

Imagine if PHY is runtime suspended but e.g. DWC3 isn't runtime pm
enabled... Does it make sense to leave that control to the USB
controller drivers ?

I'm open for suggestions

--=20
balbi

--6v9BRtpmy+umdQlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW+UkAAoJEIaOsuA1yqREKsUP/1oYpZl5k1Bge6wzca/3IXBr
NiTF3t1/1qK9gHR5NJqru+DbHb3X8LqioD5vOsLoEa6lApB5yCBwhJtt8vcgOLT2
sBhZQryRUtq8Bh4gSLI6GHKsAp6LnodjPzaRNBXsim27IyYB/vaPh00k5jiM4Pe4
ZJw8FG4s+lZu2IhfUd7cpIliLDjsLA4Kiv4DmtLtttcyEwrSJSZ4SIdRhKHEuUYL
pVM5puvXTUu0W/WVAPiKT6mA2yycdGyyJf0EJSrR8xpq0D+vcjKfgcVSRRKqpdaV
PM/WbKAKMZYxkijuSBR6h5Kx6AW+3c4HTnHxNd6J5MraqmrqKdZghgWrDY7mfQGj
Tg3aj4YPpdaRXHLTmKLYwIJHH+yJVSpflZbTGX/3bkJ0n3RGidm852eqMKzzPMQq
vKMxHyzK98Fv08NueMZSJyLAYbw52zHA/3QsYF9qc98MfZcEtISgfRdhWF+9t3yq
zKkzi3UrI7r5vkYDI9d8AQvJG0dSPhHrdOPY+01F6932S2kmjWrIPbyeGP9UWHbJ
RcJRYtlZaJGGAvu1dMZpn4MHIuvZZNKnhJ0x/NBOGwv0go6uW9yfCPnvlPy+j/HL
K+zb6FBsRJi/Khg8uJxZF81aT1URF2OUZVS+BejBbmCwJLKMB9A6IpP9HLvhx8+y
OWtrYroRhU6/1TlfzlBF
=ZjZ5
-----END PGP SIGNATURE-----

--6v9BRtpmy+umdQlo--
