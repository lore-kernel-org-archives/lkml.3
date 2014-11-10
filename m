Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaKJQbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:31:39 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44381 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaKJQbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:31:37 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Mon, 10 Nov 2014 17:23:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>, Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <20141109182231.GA29337@pd.tnic> <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2674380.b8tmZvY1V1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411101723.49197@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2674380.b8tmZvY1V1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 10 November 2014 12:22:13 Matt Fleming wrote:
> On Sun, 2014-11-09 at 19:22 +0100, Borislav Petkov wrote:
> > On Sun, Nov 09, 2014 at 06:37:46PM +0100, Pali Roh=C3=A1r wrote:
> > > this patch totally disabled efi rfc driver on x86 machines
> > > at compile time. But on some x86 machines it working
> > > without crash and reading from file
> > > /sys/class/rtc/rtc*/since_epoch returns correct
> > > information. So why to disable compiling driver on
> > > machines where driver working?
> >=20
> > Sounds like we need an efi=3Drtc_enable knob for people who
> > what to use it...
>=20
> I'm not so sure. By and large, the EFI runtime Time services
> just don't work very well on x86. Just because they work
> sometimes, doesn't actually mean it's a good idea to use
> them.
>=20
> The one scenario where the time services are useful is early
> on during boot when we want to get the timezone information.
> I have vague recollections of someone working on that.

On laptop Dell Latitude E6440 with 64bit kernel 3.17-rc6 (where=20
was rtc-efi.ko enabled at compile time for x86) it working fine=20
without crash. So I think that other Dell machines could work=20
too.

Maybe problems which were reported are only specific for 32bit=20
UEFI? Or 32bit kernels?

And I think that if I know that efi time service working on=20
machine, I should be able to use it with mainline kernel (without=20
hacking Kconfig to enable it and so...).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2674380.b8tmZvY1V1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRg5pUACgkQi/DJPQPkQ1IBZQCfTNuspzDzY56+NDmyAus3vY2g
bqUAn0vAGETIMSXsu9RZoEq0myvGdJOW
=MI7R
-----END PGP SIGNATURE-----

--nextPart2674380.b8tmZvY1V1--
