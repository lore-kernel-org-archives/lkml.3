Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaEONik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:38:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:58649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaEONii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:38:38 -0400
Date: Thu, 15 May 2014 15:38:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: WARN in do_rt_tgsigqueueinfo()
Message-ID: <20140515133834.GN13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VSVNCtZB1QZ8vhj+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VSVNCtZB1QZ8vhj+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Thomas, Oleg,


trinity$ MALLOC_CHECK_=0 ./trinity -xinit_module -xreboot -xshutdown -xunshare -xnfsservctl -xclock_nanosleep -xuselib -xumount -xmount -m --quiet -C 400 -l off -xmremap

[watchdog] kernel became tainted! (512/0) Last seed was 4072360471

[15908.562512] ------------[ cut here ]------------
[15908.567245] WARNING: CPU: 22 PID: 3312 at /usr/src/linux-2.6/kernel/signal.c:3060 do_rt_tgsigqueueinfo+0xb4/0xc0()
[15908.577715] Modules linked in:
[15908.580857] CPU: 22 PID: 3312 Comm: trinity-c198 Not tainted 3.15.0-rc5-01700-g505011124ad0-dirty #1070
[15908.590412] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[15908.597228]  0000000000000009 ffff880428715e40 ffffffff81682052 0000000000000000
[15908.604834]  ffff880428715e78 ffffffff8109808c 0000000000000001 000000000000ffff
[15908.612402]  00000000efdcefbf 00000000efdcefbf 0000000000000129 ffff880428715e88
[15908.619941] Call Trace:
[15908.622423]  [<ffffffff81682052>] dump_stack+0x4e/0x7a
[15908.627600]  [<ffffffff8109808c>] warn_slowpath_common+0x8c/0xc0
[15908.633658]  [<ffffffff810980da>] warn_slowpath_null+0x1a/0x20
[15908.639535]  [<ffffffff810a9914>] do_rt_tgsigqueueinfo+0xb4/0xc0
[15908.645591]  [<ffffffff810a99f1>] SYSC_rt_tgsigqueueinfo+0x61/0x80
[15908.651851]  [<ffffffff810abb2e>] SyS_rt_tgsigqueueinfo+0xe/0x10
[15908.657946]  [<ffffffff8168a842>] system_call_fastpath+0x16/0x1b
[15908.664036] ---[ end trace 02450728e2526283 ]---


This is apparently a very common thing to hit according to google.

--VSVNCtZB1QZ8vhj+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdMNaAAoJEHZH4aRLwOS6QS8P/0OIYRstuSekSevKYcd/YX20
eq4QM0pZnR4P7u8f0K4gtFt6GrTreT36ss6iSBZN2lvqbBusfQl5NUhH1Kn8Wlx/
jbCps5fAzt5ciwXr3ohA/XzGERhMIp0xYv4CYE7AqIfAqD5I9LUTFMIUhSRQmtg2
xpFBz9nNt9HR+LVtVX605/k/mFcrl8Cd65ktknOW4HlkJ+95QPZU0yca7wBT/wg2
oOuPMYz9fN4Eazma704onQnFPXVt/2vVxPXtJLxkdivtbsi7RjYHwYZURYjWJz6n
9H7VQjXOlYipUxkQT8IB7fkc7ixzzUTZEX8LTJom0AuS2QbycUrfee2q6nGe7M5Y
8bPBAR5d2mnMYXMAyI7BbPtm0nX+mC/713pEy3agXoE58n5TOQhRRfRbRGYTriSc
ARPzcCk6rMH9LGst+HFMIRqqoQFzbbhXiC54DOod71jZJ7m76/g8wdB17B7G0K9+
+GPAiWQdYoNCLzbmWZjCf7OCYIvNwOurDt9G8tfNIdlWh/ArSoHzkgnJZ8HjQeo7
Ga83NziWS8qhz4B11YkcrAGySXAa4R6Y1eVHilPfNU0v1gHihxudrNR0uV1Nt5lJ
qxtoJtAeBPtWhopXBPezGJktO+l7hVEYFh/DaO0pUa9w0J9AjQMz/7Z6F2ya5i3n
v/yk3792GrHxbmH4FY0m
=7i1c
-----END PGP SIGNATURE-----

--VSVNCtZB1QZ8vhj+--
