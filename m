Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3LJRw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:52:26 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:57794 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3LJRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:52:21 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting permanent mac address
Date: Tue, 10 Dec 2013 18:52:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.11.3; x86_64; ; )
Cc: Kalle Valo <kvalo@adurom.com>, Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com> <201312101814.35112@pali> <1386697762.30202.6.camel@dcbw.foobar.com>
In-Reply-To: <1386697762.30202.6.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6544305.mUThAbcFQS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312101852.17030@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6544305.mUThAbcFQS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 10 December 2013 18:49:22 Dan Williams wrote:
> On Tue, 2013-12-10 at 18:14 +0100, Pali Roh=C3=A1r wrote:
> > On Tuesday 10 December 2013 17:10:50 Pali Roh=C3=A1r wrote:
> > > On Tuesday 10 December 2013 16:49:23 Kalle Valo wrote:
> > > > Pali Roh=C3=A1r <pali.rohar@gmail.com> writes:
> > > > > Driver wl1251 generating mac address randomly at
> > > > > startup and there is no way to set permanent mac
> > > > > address via SET_IEEE80211_PERM_ADDR. This patch
> > > > > export sysfs file which can set permanent mac address
> > > > > by userspace helper program. Patch is needed for
> > > > > devices which do not store mac address in internal
> > > > > wl1251 eeprom.
> > > > >=20
> > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > >=20
> > > > We have ioctl() command for setting the mac address.
> > >=20
> > > Really? Is there ioctl for setting permanent mac address?
> > > Can you show me it?
> >=20
> > Now I looked at it again and I did not found any ioctl for
> > it. There is only ioctl cmd for getting address, not
> > setting it.
> >=20
> > #define SIOCETHTOOL 0x8946
> >=20
> > /* Get permanent hardware address */
> > #define ETHTOOL_GPERMADDR 0x00000020
>=20
> Yeah, because it's supposed to be permanent and unchanging.=20
> Which means if there was an ioctl for it, that would be
> contrary to the purpose of a permanent MAC address.
>=20
> I realize the N900 stores the WiFi MAC address completely
> differently than many other systems, and that's why this
> sysfs file was created.  I don't really have a great
> converged solution for that, other than what you've currently
> got, or perhaps adding SPERMADDR to ethtool.  One thing I
> *would* like though, is a restriction on the sysfs file such
> that if the permanent MAC is already set, it cannot be set
> again.  Otherwise the permanent MAC address isn't permanent
> at all.
>=20
> Dan

Maybe another way could be to use request_firmware to load address=20
from userspace... Or what do you think?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6544305.mUThAbcFQS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKnVNEACgkQi/DJPQPkQ1IC6ACfXfDhp4HT+tVRfEC1oIdak11e
zfAAoJBb/+UAUHTcOICKFZ3VF2jzkQRy
=wz9M
-----END PGP SIGNATURE-----

--nextPart6544305.mUThAbcFQS--
