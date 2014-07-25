Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaGYEpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:45:36 -0400
Received: from ozlabs.org ([103.22.144.67]:36916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaGYEpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:45:35 -0400
Date: Fri, 25 Jul 2014 14:45:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: linux-next: build failure after merge of the tip tree
Message-ID: <20140725144522.32c1f6b5@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/09x8C0AWfck5zql6v/03jxQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/09x8C0AWfck5zql6v/03jxQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kernel/time.c:743:6: error: conflicting types for 'update_vsys=
call_old'
 void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
      ^
In file included from arch/powerpc/kernel/time.c:77:0:
include/linux/timekeeper_internal.h:114:13: note: previous declaration of '=
update_vsyscall_old' was here
 extern void update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
             ^

Caused by commit 4a0e637738f0 ("clocksource: Get rid of cycle_last").

I have used the tip tree from next-20140724 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/09x8C0AWfck5zql6v/03jxQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0eDtAAoJEMDTa8Ir7ZwVL9cP/iXis3u4igJeEhcAA4LaucY6
F1Tmi2FyQbmxZBlFKmbC/5df69ydRxHNepw/UygaTiFxx9vLE4lsBchCxWb4g+or
3OMmOoPUu38cfGmJSoEQjyVKLmksz9lYa38HdVmwNJ41CdMMx5rrAoLqa1sFz3I0
vv7jfRkMmJRCxx3wHUtAb7PskGhVvf64hd5c+9EBAO4Z/z6YmLuzn/mpt6ohDMj/
0mml9z71T+Dm/ZnHA3q29s219chkrkqgVENMkML3eeDMjLNWBvuJYUm5wdcTYxg6
ShbOpn8OFY+fbbP8JI5eaFVxmR2hNLrGOEqDJZfD0LR2zgMUrcCdNVHRoc+RC042
HLnYBfWVX1nuN6UdYWd/82tLii2TTpVRoKadKkRt/7vxkXLzemy2OI4Z9yensdAj
IWt6g9puX7nhCbzvWnDj9BhgI7tsiW98xlh6T+F0WNh/RcOel3lZYBOhNMjqvTvu
kRQwAEm+BGvembzlvm0K+Pn3kQzAxgtbDK4yPCyjzeiuUvotRQD0BQgOTQIPn18w
Y66UIEa0Pfu3y2HedONH+RV+SsuxG5u21ZofDKB3EzzeP/Q5KVhaaQShSSzNKBez
gktWBtPm42Y4WO/DDz4FIQFt2mDDUAnbxTaLy8kTYIT7oc4XJGtA6PE6bzUmBO6u
RBN/ZmxP2ILf/8oxWFkb
=YkH3
-----END PGP SIGNATURE-----

--Sig_/09x8C0AWfck5zql6v/03jxQ--
