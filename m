Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaIHOVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:21:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50895 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbaIHOVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:21:44 -0400
Date: Mon, 8 Sep 2014 09:21:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Todd Poynor <toddpoynor@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v3 1/2] usb: phy: Hold wakeupsource when USB is enumerated
 in peripheral mode
Message-ID: <20140908142128.GO22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410170963-14182-1-git-send-email-kiran.kumar@linaro.org>
 <20140908133855.GH22409@saruman.home>
 <CA+RfmHYVohWD5kTFUqdXsT+LvbpK2_qVRfFhnp4x9trhQhNXDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p/1JFEOz/hVXxMAZ"
Content-Disposition: inline
In-Reply-To: <CA+RfmHYVohWD5kTFUqdXsT+LvbpK2_qVRfFhnp4x9trhQhNXDw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p/1JFEOz/hVXxMAZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 08, 2014 at 07:48:06PM +0530, Kiran Raparthy wrote:
> On 8 September 2014 19:08, Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Hi,
> >
> > On Mon, Sep 08, 2014 at 03:39:23PM +0530, Kiran Kumar Raparthy wrote:
> > > From: Todd Poynor <toddpoynor@google.com>
> > >
> > > usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
> > >
> > > Purpose of this is to prevent the system to enter into suspend state
> > from USB
> > > peripheral traffic by hodling a wakeupsource when USB is connected and
> > > enumerated in peripheral mode(say adb).
> > >
> > > Disabled by default, can enable with:
> > >    echo Y > /sys/module/otg_wakeupsource/parameters/enabled
> > >
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: linux-usb@vger.kernel.org
> > > Cc: Android Kernel Team <kernel-team@android.com>
> > > Cc: John Stultz <john.stultz@linaro.org>
> > > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > > Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> > > Cc: Benoit Goby <benoit@android.com>
> > > Signed-off-by: Todd Poynor <toddpoynor@google.com>
> > > [kiran: Added context to commit message, squished build fixes
> > > from Benoit Goby and Arve Hj=EF=BF=BDnnev=EF=BF=BDg, changed wakelock=
s usage
> > > to wakeupsource, merged Todd's refactoring logic and simplified
> > > the structures and code and addressed community feedback]
> > > Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> > > ---
> > > v3:
> > > * As per the feedback,no global phy pointer used.
> > > * called the one-liner wakeupsource handling calls
> > >   directly instead of indirect functions implemented in v2.
> > > * Removed indirect function get_phy_hook and used usb_get_phy
> > >   to get the phy handle..
> > >
> > > v2:
> > > * wakeupsource handling implemeted per-PHY
> > > * Implemented wakeupsource handling calls in phy
> > > * included Todd's refactoring logic.
> > >
> > > v1:
> > > * changed to "disabled by default" from "enable by default".
> > > * Kconfig help text modified
> > > * Included better commit text
> > > * otgws_nb moved to otg_wakeupsource_init function
> > > * Introduced get_phy_hook to handle otgws_xceiv per-PHY
> > >
> > > RFC:
> > > * Included build fix from Benoit Goby and Arve Hj=EF=BF=BDnnev=EF=BF=
=BDg
> > > * Removed lock->held field in driver as this mechanism is
> > >   provided in wakeupsource driver.
> > > * wakelock(wl) terminology replaced with wakeup_source(ws).
> > >
> > >  drivers/usb/phy/Kconfig            |   8 +++
> > >  drivers/usb/phy/Makefile           |   1 +
> > >  drivers/usb/phy/otg-wakeupsource.c | 136
> > +++++++++++++++++++++++++++++++++++++
> > >  include/linux/usb/phy.h            |   4 ++
> > >  4 files changed, 149 insertions(+)
> > >  create mode 100644 drivers/usb/phy/otg-wakeupsource.c
> > >
> > > diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> > > index e253fa0..d9ddd85 100644
> > > --- a/drivers/usb/phy/Kconfig
> > > +++ b/drivers/usb/phy/Kconfig
> > > @@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
> > >  config USB_PHY
> > >       def_bool n
> > >
> > > +config USB_OTG_WAKEUPSOURCE
> > > +     bool "Hold wakeupsource when USB is enumerated in peripheral mo=
de"
> > > +     depends on PM_SLEEP
> > > +     select USB_PHY
> > > +     help
> > > +       Prevent the system going into automatic suspend while
> > > +       it is attached as a USB peripheral by holding a wakeupsource.
> > > +
> > >  #
> > >  # USB Transceiver Drivers
> > >  #
> > > diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> > > index 24a9133..ca2fbaf 100644
> > > --- a/drivers/usb/phy/Makefile
> > > +++ b/drivers/usb/phy/Makefile
> > > @@ -3,6 +3,7 @@
> > >  #
> > >  obj-$(CONFIG_USB_PHY)                        +=3D phy.o
> > >  obj-$(CONFIG_OF)                     +=3D of.o
> > > +obj-$(CONFIG_USB_OTG_WAKEUPSOURCE)           +=3D otg-wakeupsource.o
> > >
> > >  # transceiver drivers, keep the list sorted
> > >
> > > diff --git a/drivers/usb/phy/otg-wakeupsource.c
> > b/drivers/usb/phy/otg-wakeupsource.c
> > > new file mode 100644
> > > index 0000000..d9a1720
> > > --- /dev/null
> > > +++ b/drivers/usb/phy/otg-wakeupsource.c
> > > @@ -0,0 +1,136 @@
> > > +/*
> > > + * otg-wakeupsource.c
> > > + *
> > > + * Copyright (C) 2011 Google, Inc.
> > > + *
> > > + * This software is licensed under the terms of the GNU General Publ=
ic
> > > + * License version 2, as published by the Free Software Foundation, =
and
> > > + * may be copied, distributed, and modified under those terms.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + */
> > > +
> > > +#include <linux/kernel.h>
> > > +#include <linux/device.h>
> > > +#include <linux/module.h>
> > > +#include <linux/notifier.h>
> > > +#include <linux/pm_wakeup.h>
> > > +#include <linux/spinlock.h>
> > > +#include <linux/usb/otg.h>
> > > +
> > > +bool enabled =3D false;
> > > +
> > > +static DEFINE_SPINLOCK(otgws_spinlock);
> >
> > why do you continue to ignore my comment that this should be built
> > *into* struct usb_phy so it's a per-PHY setting ? Is this some sort of a
> > joke that I'm not getting ?
> >
> > Hi Balbi,
> Thanks for taking time in providing the valuable input.
> I have changed everything per-PHY where ever global phy pointer is used.
> Since otgws_spinlock is not dealing with any phy related parameter,i have
> not included that in struct usb_phy.
> Sorry,i was not expecting that you are referring to otgws_spinlock.
> I'll modify as per your suggestion and resubmit the patch.

while at that, also drop that enabled boolean too.

--=20
balbi

--p/1JFEOz/hVXxMAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDbtoAAoJEIaOsuA1yqRE8zMP/R6LDbQPWQ/KkmWPhas1g8KC
E/qxYc14N1rHT5KHZscefy7ThVKbFt8T7+QCkfQ0EAsmTVJbfbH4ZiV3RygzOnHO
EeGr0b1S+UQ/AjiBtTodnd7t2jrA/sB7it9BI/fcdbtuwOAV1d69R2SmVfiSAFAY
UXsKZtob5omTnceCfXztcpNolaiRUqdUHqZkHgjsa91msGq465+q3VVhfGdAr0xg
DwzlSai9Y0gmwt7PBVLoEiLvSq3lQ90izHPFyC/rkFh7tBXucUUM0qQZwNckojjp
JhrT3wjKyYB5j9Hk/QRt0O7+q2xktRQ2CLkNZ01pZ8hZSbEpTGDEn6cqhMW98R5q
YM6yYi5SYy2hcdKOkSiSgb/VoUSLs+DoPXBIZsZAL42BJhBWOkKvydBh0A/c0mNF
9GVj8z9K1HIkeh8aKdbx116b/CKAdswaP9NbfhBWVEKU2w80Y2rdztNaaeWuUHnS
OW16iLd07sMQsqsthEDokE3TFZlC6iAo0EuAtxYei0GUog4QUN+Um3tw19yBeERx
oqHDFoj30sC38GrBE9BqwLS1vIl7oOG4XHmgfI6h2Nr2n/6wA6iXV3rX3+zeM3zD
+IDO0bTDkmosCkS/v+ohpnOj8Gavv1xsJQBSvLqY4vTqugAjXudKlnBlkk68rZiI
0Xa6ykWhfAy21ARBwpUT
=VT1w
-----END PGP SIGNATURE-----

--p/1JFEOz/hVXxMAZ--
