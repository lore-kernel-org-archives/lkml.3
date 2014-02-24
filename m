Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaBXESG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 23:18:06 -0500
Received: from ozlabs.org ([203.10.76.45]:49291 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaBXESD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 23:18:03 -0500
Date: Mon, 24 Feb 2014 15:18:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: linux-next: manual merge of the rcu tree with the tip tree
Message-Id: <20140224151801.198f04c4341f449d9eae09d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Feb_2014_15_18_01_+1100_8adA7YqEyM=rd_1F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Feb_2014_15_18_01_+1100_8adA7YqEyM=rd_1F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rcu tree got a conflict in
kernel/rcu/rcutorture.c between commit d277d868dab6 ("rcu: Use MAX_NICE
to replace hardcoding of 19") from the tip tree (where this file is
called kernel/rcu/torture.c) and commit 5ccf60f23d33 ("rcutorture: Rename
PRINTK to TOROUT") from the rcu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/rcu/rcutorture.c
index 219761db1a46,f59d48597dde..000000000000
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@@ -802,10 -693,10 +693,10 @@@ rcu_torture_writer(void *arg
  	struct rcu_torture *rp;
  	struct rcu_torture *rp1;
  	struct rcu_torture *old_rp;
- 	static DEFINE_RCU_RANDOM(rand);
+ 	static DEFINE_TORTURE_RANDOM(rand);
 =20
- 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
+ 	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
 -	set_user_nice(current, 19);
 +	set_user_nice(current, MAX_NICE);
 =20
  	do {
  		schedule_timeout_uninterruptible(1);
@@@ -868,19 -756,19 +756,19 @@@
  static int
  rcu_torture_fakewriter(void *arg)
  {
- 	DEFINE_RCU_RANDOM(rand);
+ 	DEFINE_TORTURE_RANDOM(rand);
 =20
- 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
+ 	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task started");
 -	set_user_nice(current, 19);
 +	set_user_nice(current, MAX_NICE);
 =20
  	do {
- 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
- 		udelay(rcu_random(&rand) & 0x3ff);
+ 		schedule_timeout_uninterruptible(1 + torture_random(&rand)%10);
+ 		udelay(torture_random(&rand) & 0x3ff);
  		if (cur_ops->cb_barrier !=3D NULL &&
- 		    rcu_random(&rand) % (nfakewriters * 8) =3D=3D 0) {
+ 		    torture_random(&rand) % (nfakewriters * 8) =3D=3D 0) {
  			cur_ops->cb_barrier();
  		} else if (gp_normal =3D=3D gp_exp) {
- 			if (rcu_random(&rand) & 0x80)
+ 			if (torture_random(&rand) & 0x80)
  				cur_ops->sync();
  			else
  				cur_ops->exp_sync();
@@@ -986,8 -871,8 +871,8 @@@ rcu_torture_reader(void *arg
  	struct timer_list t;
  	unsigned long long ts;
 =20
- 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
+ 	VERBOSE_TOROUT_STRING("rcu_torture_reader task started");
 -	set_user_nice(current, 19);
 +	set_user_nice(current, MAX_NICE);
  	if (irqreader && cur_ops->irq_capable)
  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 =20
@@@ -1583,8 -1160,8 +1160,8 @@@ static int rcu_torture_barrier_cbs(voi
  	struct rcu_head rcu;
 =20
  	init_rcu_head_on_stack(&rcu);
- 	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
+ 	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task started");
 -	set_user_nice(current, 19);
 +	set_user_nice(current, MAX_NICE);
  	do {
  		wait_event(barrier_cbs_wq[myid],
  			   (newphase =3D

--Signature=_Mon__24_Feb_2014_15_18_01_+1100_8adA7YqEyM=rd_1F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTCsf5AAoJEMDTa8Ir7ZwVVKUP/jjQv5YP5h6II3BUnISWqRQJ
omc95lo25EnQrJrAxSp9A0kfGFsHF0ZJLeo6kY/LTR1R/gAQpc3IN3tC1rRfBDUl
TcjukgiqBOm2P5XgcEknH3G6LxL1CJIZ8iL029UxlEGvqNcT4pTs/fLkAehIHmW8
2odgXecQRruS/FBO9+MsUVOGaCv2KGwZdq7ef/E1OlJOaSmoZT7hewm1kICrXRPp
BPjbLNUmPP45a3D5m4QHFIathRFB5vr/T0euPho16vBF38sEyTXdmHZU69mt/EyP
4V+PSyJEIfn1F9sF7IeCsf7t2jDmu2tNRLcIWQQsvJVTXtH4Ul5bFo+EAGHy4oqQ
ylbXlUeDR8Oq+/L+9H/l3nKW3Z4T7mlppitK+gCviQuTq1cTOeuPTFeAtPy1X/nD
GYBy0IzEL/do6IgD9SKSbyTpl78mY3AIgfxV3Cigb7IpN7o+1xZXWCuEv5zXaRr2
n/jbEcOpMuR6v39ofTxX0MFdxeLbpDQVE+Jv9GZ+ZUZs5XKuuQhqvhW2ndvD3aD8
zJ9IS4ESfuG6GElWnE8O+ni0OJlu9QFvG5h5cpnAvxW0KEl3o/G+P1kuAak5/r6f
3DGkKNC4L8XpzQ7R5gohr/1gbjwvn0P6KrQN1YRCe7ggQWrTyN8P66MF6foey0ZC
f5zUd10oNwNpP6mvFb75
=A94Z
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Feb_2014_15_18_01_+1100_8adA7YqEyM=rd_1F--
