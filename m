Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaH2Uzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:55:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36754 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaH2Uzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:55:40 -0400
Date: Fri, 29 Aug 2014 15:55:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC v1 2/2] usb: otg: Temporarily hold wakeupsource on charger
Message-ID: <20140829205535.GG16391@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409220399-28425-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYDVKSzuImP48n7V"
Content-Disposition: inline
In-Reply-To: <1409220399-28425-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aYDVKSzuImP48n7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 03:36:39PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: otg: Temporarily hold wakeupsource on charger connect and disconnect
> events
>=20
> Allow other parts of the system to react to the charger connect/disconnect
> event without allowing the system to suspend before the other parts can p=
rocess
> the event. This wakeup_source times out after 2 seconds; if nobody else h=
olds a
> wakeup_source by that time then the device can sleep.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [kiran: Added context to commit message]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
>  drivers/usb/phy/otg-wakeupsource.c | 10 +++++++---
>  include/linux/usb/otg.h            |  2 ++
>  2 files changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wak=
eupsource.c
> index 7c838d1..9f3c5c1 100644
> --- a/drivers/usb/phy/otg-wakeupsource.c
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -34,8 +34,11 @@ struct otgws_lock {
>  	struct wakeup_source wsource;
>  };
> =20
> -/* VBUS present lock */
> -
> +/*
> + * VBUS present lock.  Also used as a timed lock on charger
> + * connect/disconnect and USB host disconnect, to allow the system
> + * to react to the change in power.
> + */
>  static struct otgws_lock vbus_lock;
> =20
>  static void otgws_handle_event(unsigned long event)
> @@ -59,7 +62,8 @@ static void otgws_handle_event(unsigned long event)
>  	case USB_EVENT_NONE:
>  	case USB_EVENT_ID:
>  	case USB_EVENT_CHARGER:
> -		__pm_relax(&vbus_lock.wsource);
> +		__pm_wakeup_event(&vbus_lock.wsource,
> +		msecs_to_jiffies(TEMPORARY_HOLD_TIME));

indentation here is wrong. Also, I have gotten three patches from you
with very similar contents and subject. Please make sure to read
Documentation/SubmittingPatches, Documentation/CodingStyle and
Documentation/SubmitChecklist

cheers

--=20
balbi

--aYDVKSzuImP48n7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUAOjHAAoJEIaOsuA1yqREzuoP/i7u+Pp3nzBDeT+VtclrN2s4
Jhq0r9u4iZjwOVSOy1XRwqO20CKHAGdOHbAalu8cyXmGvnjYsXzc4lVMXtE8a5DG
kyzFbYVE/n3quCpGCpSaRis4UEX/TNmFcj9GVnYTEAprF8eerm9ZHv0E6wk03u7o
SDwcZscRAMRClHJNbSak2Yu51ox+I5VyMofNc8cCCCJ83zAsXxR+zCpFStj1NW2i
S07mTVWYBQOZr78FWXxj+HyjygbG36s2IBC//qt1Fy6T4rgPLRNguMb22SwzzGC2
OR36QSKQSbbYb3/1+LAmyEU6PaMpHB84y7YkgmTsP7BoK4ebSn44ItzbRnUT+7lc
Kx01x7NAWh77IiVOntV90I3RYgE9FvB4dMdP73xHxTRm8Ltj63NbJM7hyOrPwQH5
OtJU4BvD0yh0A1ykNCtfj5PnA2F1Gqe8C2ycMvij8lvLob3ryo1zr6pwzTghw0hP
aGKmMJTfRq3t/N/dnIgYvyJ7CLTJ6mH3brJwxlq3qdm1t7o2ktfXi/qhFlb/3ZX/
SPJ8GdmD/+oWY0OAfQK5bcbKyIoiWAAr9TsHAD13Jj1EMc5bRV31PEwBbBYEBp3M
rk1IgRZh7Cx6s0t6CfgIdVQ+2GGe8qsIp2aS1vvaP0qPmNX+W7jB1cTkAJXIKK2D
b7DtR+Tc8ASq+rV8NgzL
=Hmhj
-----END PGP SIGNATURE-----

--aYDVKSzuImP48n7V--
