Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaHaQqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 12:46:25 -0400
Received: from mout.gmx.net ([212.227.15.18]:54279 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaHaQqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 12:46:24 -0400
Message-ID: <54035154.6080306@rempel-privat.de>
Date: Sun, 31 Aug 2014 18:46:12 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Writing clocksource driver, tips?
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GN75KUVAtun9UinU8taRtMoXWjFGMIm5o"
X-Provags-ID: V03:K0:5hVu5PwwTUJV+S4mvLJE7vlrnl+d/jcOjbPgkxItvm01N4sTIUG
 LA7gOxGWrOYYCPAAqIaSUY7j/lXpPmmPXujqsCSow6GSUrbgrIifRfDL16CfY9XERvRVxyj
 HLrb+mX+KMBVqwuBOsbcT5VjD+VXZPCn59lY10mTgO6qFJjjWZUxCCMXfaqPmAMRjk8nF/U
 OeqjVI2dVXj3pnAwkOxSQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GN75KUVAtun9UinU8taRtMoXWjFGMIm5o
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello all,

currently i work on porting linux to Aplscale ASM9260,
most basic parts are done, now is the time for clocksource driver. I
never did it before, so i need some beginner tips.
My current driver clocksource provide periodic events at 100Hz rate. But
this hardvare can do more then it.
This SoC has 4 32bit-timer controller attached to 100MHz source. Each
controller has 4 separate timer register each of them can be configure
separately for scale, match and interrupt. 3 controllers can choice the
tick source.
This controller looks similar to one found on NXP LPC1311, but looks
like no similar hardware in drivers/clocksource.

For now i have fallowing questions:
- 1 timer can be used for clocksource other as  clock_event_device, how
can i use other 2 timers on same controller. and how can i use other 3
controllers?
- theoretically i can use clocksource_mmio_init to read directly
timer_counter_register. Which scale should be used on it. 100MHz is
probably too match.
- should clocksource provide interrupt on overflow or some kind of limit?=


--=20
Regards,
Oleksij


--GN75KUVAtun9UinU8taRtMoXWjFGMIm5o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlQDUVsACgkQHwImuRkmbWmK9AD/TLya1LhHqkawf6xTaOKOX+F+
s64Th2F6jXeVTThDkG8A/jwvrjTROkXfhffsmyw3QMmQ75/fAcHTsXRetZ4l3j5X
=TcR7
-----END PGP SIGNATURE-----

--GN75KUVAtun9UinU8taRtMoXWjFGMIm5o--
