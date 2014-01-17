Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaAQDao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:30:44 -0500
Received: from ozlabs.org ([203.10.76.45]:35484 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaAQDam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:30:42 -0500
Date: Fri, 17 Jan 2014 14:30:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20140117143035.fa787a8203afaa83c64009bb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_14_30_35_+1100__QOP+1tYHMp3DdEI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_14_30_35_+1100__QOP+1tYHMp3DdEI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/clocksource/cadence_ttc_timer.c between commit c1dcc927dae0
("clocksource: cadence_ttc: Fix mutex taken inside interrupt context")
from Linus' tree and commit dfded00902d7 ("clocksource:
cadence_ttc_timer: Switch to sched_clock_register()") from the tip tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/cadence_ttc_timer.c
index a92350b55d32,8c7382bf260c..000000000000
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@@ -308,7 -306,8 +308,8 @@@ static void __init ttc_setup_clocksourc
  	}
 =20
  	ttc_sched_clock_val_reg =3D base + TTC_COUNT_VAL_OFFSET;
- 	setup_sched_clock(ttc_sched_clock_read, 16, ttccs->ttc.freq / PRESCALE);
+ 	sched_clock_register(ttc_sched_clock_read, 16,
 -			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
++			     ttccs->ttc.freq / PRESCALE);
  }
 =20
  static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,

--Signature=_Fri__17_Jan_2014_14_30_35_+1100__QOP+1tYHMp3DdEI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2KPfAAoJEMDTa8Ir7ZwVXtkP/i45vlkm7SuoYqi+SLP++1CD
cXIrBCL+/nrpSCMhjtDSHbsGWP7vkbIPcxWS4xbXjLxeUqEsYrLvFM0cR03J7H9X
gxsOIAZ1cxFlaepIBLOAT/HSxm1SpoA2eaehLWT5weOsp7EszFlnj77ZteVTsVY1
WFOdyJ2fdquCNGncKDOvlJz7q5guAGxlhPlZjPUaNW2sG4wLduKoUzYl/Vc8pIJg
oV6SzLHM6JGuAYS+vvVRCVE2crJrVy4m/UnI5xYXlCoiYv4opYDLQ6NIiqC8KY8w
b24iMuHLzLd1BvLd3ywFS1JcVDoJk5TzTmFvxx3frFGfDxlRFFmGIINnvOe1e8Up
hG/6kwrDHWMg2uRegQvylxAMMTrnTZMjGoGk9daLoskWCy3JxU/GB6SPasj4yYNc
fuNNOcnYw3hRQJYyvt0eiEIX7zcXmfJywKnP4NJVqNdJx2KkOnpzrXR5XdwOdJRD
U3CZZ25VuYg+VAn4gzpI6t8TmfjigCtGrml29WlUFEzRZzBngbwaqEm3wdayimP+
FDqph/usuqwXnizTIdbH4oSKUvPJw/CkXPalmAOdwkKaTuwR4Z+rJxPnkxyDZwUj
A6lOQNs1mFA/0zhA1NS49C6O2fKCf3beEggSWpaVF1Oer9O32FFWqnw53ceJsK9T
tZ8NJgeZcLizMH8EfLEx
=jvFn
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_14_30_35_+1100__QOP+1tYHMp3DdEI--
