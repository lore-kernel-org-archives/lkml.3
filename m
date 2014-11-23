Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaKWNlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 08:41:22 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:61032 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaKWNlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 08:41:20 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Side effect of pressing special keys
Date: Sun, 23 Nov 2014 14:41:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2329723.YIZi5ZuPmt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411231441.17592@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2329723.YIZi5ZuPmt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

pressing some keys on laptops could cause some side effects.

Example scenario 1:

Laptop has Fn key for enabling/disabling WIFI and when that key=20
is pressed BIOS is doing two things:

1) Switch hard rfkill state of WIFI
2) Report that Fn key was pressed to kernel
   (either via i8042 bus or via ACPI/WMI)

Example scenario 2:

Another laptop has Fn key too, but BIOS does not change state of=20
hard rfkill. So system (kernel or userspace) is responsible for=20
interpreting what that Fn key means and call correct action (find=20
rfkill device for WIFI and soft block it).

And my questions are:

1) What should userspace do if some input device report that=20
KEY_WLAN or KEY_RFKILL was pressed?

2) Should kernel report to userspace that (on specific laptop)=20
has pressed key some side effect?

3) How to deal with existing userspace application which=20
interpret all pressed keys as described in example scenario 2=20
also on laptops from scenario 1? KDE4, NetworkManager, ... are=20
know to do that!

Note that this problem is not only about rfkill/wifi keys. Same=20
apply for keyboard brightness Fn keys and also for key=20
KEY_KBDILLUMTOGGLE (which toggle keyboard illumination level).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2329723.YIZi5ZuPmt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRx4/0ACgkQi/DJPQPkQ1InpgCePJDnhH0PMZAvoRCbrRGJFuW2
zCcAoIws4Ph2ObF8GwfGSJCEQsRBGCS4
=x+rJ
-----END PGP SIGNATURE-----

--nextPart2329723.YIZi5ZuPmt--
