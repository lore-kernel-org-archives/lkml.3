Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbaKNLVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:21:10 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41391 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965084AbaKNLVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:21:06 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Fri, 14 Nov 2014 12:21:02 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <201411101723.49197@pali> <5460EB92.1090501@gmail.com>
In-Reply-To: <5460EB92.1090501@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3214755.DR6N2d8hxz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411141221.03260@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3214755.DR6N2d8hxz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 10 November 2014 17:45:06 Austin S Hemmelgarn wrote:
> On 2014-11-10 11:23, Pali Roh=C3=A1r wrote:
> > On Monday 10 November 2014 12:22:13 Matt Fleming wrote:
> >> On Sun, 2014-11-09 at 19:22 +0100, Borislav Petkov wrote:
> >>> On Sun, Nov 09, 2014 at 06:37:46PM +0100, Pali Roh=C3=A1r wrote:
> >>>> this patch totally disabled efi rfc driver on x86
> >>>> machines at compile time. But on some x86 machines it
> >>>> working without crash and reading from file
> >>>> /sys/class/rtc/rtc*/since_epoch returns correct
> >>>> information. So why to disable compiling driver on
> >>>> machines where driver working?
> >>>=20
> >>> Sounds like we need an efi=3Drtc_enable knob for people who
> >>> what to use it...
> >>=20
> >> I'm not so sure. By and large, the EFI runtime Time
> >> services just don't work very well on x86. Just because
> >> they work sometimes, doesn't actually mean it's a good
> >> idea to use them.
> >>=20
> >> The one scenario where the time services are useful is
> >> early on during boot when we want to get the timezone
> >> information. I have vague recollections of someone working
> >> on that.
> >=20
> > On laptop Dell Latitude E6440 with 64bit kernel 3.17-rc6
> > (where was rtc-efi.ko enabled at compile time for x86) it
> > working fine without crash. So I think that other Dell
> > machines could work too.
>=20
> I can also confirm that it works correctly on a number of ASUS
> and ASrock desktop motherboards with the most recent BIOS
> updates, and on a Lenovo Thinkpad L540.  I can however
> confirm that it DOES NOT work however on an Acer Aspire
> V5-131 system, though I had never updated the BIOS on that
> one, so it may work correctly with a newer BIOS version.
>=20

So how to solve it? I think that something like efi=3Drtc_enable=20
param is better then disabling it for x86 at compile time.

Once we figure out which machines are affected or if in future=20
vendors fix their firmwares it can be enabled for new machines...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3214755.DR6N2d8hxz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRl5Z8ACgkQi/DJPQPkQ1KGPgCfen5v4pG31fdM7u0dt1yAdW5B
+q8AoJeSNHJqsY8oZ6h4wUu2d1UvZCTs
=EqRm
-----END PGP SIGNATURE-----

--nextPart3214755.DR6N2d8hxz--
