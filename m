Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab3CZESW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:18:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60257 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3CZESU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:18:20 -0400
Date: Tue, 26 Mar 2013 15:18:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenneth Heitke <kheitke@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Subject: linux-next: build failure after merge of the char-misc tree
Message-Id: <20130326151811.de958e38f0116334a62e1c8b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_15_18_11_+1100_OmeuWvNHFMq+aBNc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_15_18_11_+1100_OmeuWvNHFMq+aBNc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the char-misc tree, today's linux-next build
(x86_64_allmodconfig) failed like this:

drivers/input/keyboard/pmic8xxx-keypad.c:24:35: fatal error: linux/mfd/pm8x=
xx/gpio.h: No such file or directory

Caused by commit e44b0ceee4cc ("add single-wire serial bus interface
(SSBI) driver") which added the Kconfig symbol MSM_SSBI (later changed to
just SSBI) which did not exist in the tree before.  However,
MFD_PM8921_CORE depended on it and that selects MFD_PM8XXX which allows
the above file to build (and fail).

I have used the char-misc tree from next-20130325 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Mar_2013_15_18_11_+1100_OmeuWvNHFMq+aBNc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUSGDAAoJEECxmPOUX5FEwQ4P/3ZVicnBCxhBFi1Z+CvlTF6G
AGSk7LqjopKQrel/+SV0u/H/71B0dfz8Ydko4OMjhUaWaMtcZoTljCPL9nUpLBaF
taOsu5SnFrU+7PKWtcr3T9SVqalyoljKGBoqGhM4UnR9MZGDga7PGzC+ps6MZJY4
l//lHKpVQhvpsIZGDIl881E6eSwHCWWS/KJ0qDNiHYLW+DsPWWTWgDSt4fKD5YzZ
kNiyNcw2HFCbnwBqF4lGnZC61KxT06LRgTgkZ9FEsfE6YRU/Sqrxmr2rPVIbMbSY
CoGuNGllcRBI4hEkoHUYZ+uYh2WBcFkQDZwBBfZByKbqfT2e22dWHKbVvU4aG1Tt
PsvCEB/zhFffrTCXAbNxiVwTRYOIT/mRRfzL86VHYu3MK6KyigHLWystmQ+LItJm
qBx7dlQVC0/hts1UXlKCVhCYdxNvOOOVb3g9SiUBDNcGRJrlAhDFwU721qeG/Fjk
FiOgpa0lTAixE4ObYSrcl936cOBMCoxjG8PnUT5htHJ+oQwaTduBQuTBU5PMsczO
M8plHcelBvrMnNo3dIXoQ8L8qTk1gxdiuW0ggrQY++aFxWYvfaUHXIfOtJGY1IIM
so96Z6V+HREnbxrPmRup+elOuayyszXguGpWmWWhoAH/uuBuWm5mPLRaRQfRkoDB
gWlfpPJ407vCvh/R2Ax9
=y7zr
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_15_18_11_+1100_OmeuWvNHFMq+aBNc--
