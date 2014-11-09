Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaKIRhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 12:37:52 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35365 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaKIRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 12:37:50 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Sun, 9 Nov 2014 18:37:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Matt Fleming <matt@console-pimps.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Dave Young <dyoung@redhat.com>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <1412348517.5410.13.camel@deneb.redhat.com>
In-Reply-To: <1412348517.5410.13.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2161255.Ze1lOtOiMd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411091837.47354@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2161255.Ze1lOtOiMd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 03 October 2014 17:01:57 Mark Salter wrote:
> On Fri, 2014-10-03 at 13:32 +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> >=20
> > commit da167ad7638759 ("rtc: ia64: allow other architectures
> > to use EFI RTC") inadvertently introduced a regression for
> > x86. We've been careful not to enable the EFI rtc driver
> > for x86 due to the generally buggy implementations of the
> > time-related EFI runtime services.
> >=20
> > Previous attempts have been made to us the time EFI
> > services, but all have eventually been reverted due to
> > crashes inside the firmware code.
> >=20
> > In fact, since the above commit was merged we've seen
> > reports of crashes on 32-bit tablets,
> >=20
> >   https://bugzilla.kernel.org/show_bug.cgi?id=3D84241#c21
> >=20
> > Disable it explicitly for x86 so that we don't give users
> > false hope that this driver will work - it won't, and your
> > machine is likely to crash.
> >=20
> > Cc: Mark Salter <msalter@redhat.com>
> > Cc: Dave Young <dyoung@redhat.com>
> > Cc: Alessandro Zummo <a.zummo@towertech.it>
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > ---
>=20
> Acked-by: Mark Salter <msalter@redhat.com>
>=20
> > Unless anyone objects, I'm happy to take this through the
> > EFI tree.
> >=20
> >  drivers/rtc/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> > index a168e96142b9..54ef393b0def 100644
> > --- a/drivers/rtc/Kconfig
> > +++ b/drivers/rtc/Kconfig
> > @@ -806,7 +806,7 @@ config RTC_DRV_DA9063
> >=20
> >  config RTC_DRV_EFI
> > =20
> >  	tristate "EFI RTC"
> >=20
> > -	depends on EFI
> > +	depends on EFI && !X86
> >=20
> >  	help
> >  =09
> >  	  If you say yes here you will get support for the EFI
> >  	  Real Time Clock.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at=20
> http://vger.kernel.org/majordomo-info.html Please read the
> FAQ at  http://www.tux.org/lkml/

Hello,

this patch totally disabled efi rfc driver on x86 machines at=20
compile time. But on some x86 machines it working without crash=20
and reading from file /sys/class/rtc/rtc*/since_epoch returns=20
correct information. So why to disable compiling driver on=20
machines where driver working?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2161255.Ze1lOtOiMd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRfpmsACgkQi/DJPQPkQ1JBdACgwuYNkLPD6Qvr4/HvZtYY0MCy
/aIAn0k9giHBUB71dqK54oTbnYiOLpvy
=aUcR
-----END PGP SIGNATURE-----

--nextPart2161255.Ze1lOtOiMd--
