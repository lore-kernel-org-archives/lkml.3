Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaGKCZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:25:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33696 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbaGKCZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:25:05 -0400
Message-ID: <1405045492.26540.67.camel@deadeye.wl.decadent.org.uk>
Subject: Interrupt randomness in 3.14.10-rt
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, stable-rt@vger.kernel.org
Date: Fri, 11 Jul 2014 03:24:52 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-F6EKBV5rcERTzsdzPdLI"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F6EKBV5rcERTzsdzPdLI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed this change between 3.14.3-rt5 and 3.14.10-rt7:

--- debian/patches/features/all/rt/random-make-it-work-on-rt.patch      (re=
vision 21522)
+++ debian/patches/features/all/rt/random-make-it-work-on-rt.patch      (wo=
rking copy)
[...]
---- a/kernel/irq/manage.c
-+++ b/kernel/irq/manage.c
-@@ -942,6 +942,12 @@ static int irq_thread(void *data)
-               if (action_ret =3D=3D IRQ_HANDLED)
-                       atomic_inc(&desc->threads_handled);
-=20
-+#ifdef CONFIG_PREEMPT_RT_FULL
-+              migrate_disable();
-+              add_interrupt_randomness(action->irq, 0,
-+                               desc->random_ip ^ (unsigned long) action);
-+              migrate_enable();
-+#endif
-               wake_threads_waitq(desc);
-       }
-=20

(I.e. old patch included these additions, new patch doesn't.)

Evidently this was made in the announced 3.14.10-rt6, not -rt7.  Was it
intentional?  Now irq_desc::random_ip is set but never used.

Ben.

--=20
Ben Hutchings
To err is human; to really foul things up requires a computer.

--=-F6EKBV5rcERTzsdzPdLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU79K+ee/yOyVhhEJAQqVcg/5AeF/OuMeK++33vI+MnUlrhuHbjuoDa3Q
OF4VGVWda501pDb6JonjdYxlUttQV4LEWwv5rxKfU1tO7Da5W0lXpioqdyzKzk1H
9hkZZAlmhXOvjQf6pKwK6bIRDPOnQHWhbLIw3Xa3bLw35lNdVLZt0EJIQQtu1uvg
z0gjLEB7TLoc4eCFPy51OQl19ovMwWpwRatW/tWh7sjhnr2o8DB+r9DWZBAcy/z4
iVPolozW5hobIh11uh8UyPWGQxjdSupyhcE4rqXQIDXB+7Pg5bkplXVI/PxoAP0Y
u8kb83jCduZRK1ARTYtnJTog7vsyvhSh1pku2k2ocZj2XoIyS6YN+TUJRvqrXJZM
4chGS8CMumLR79bF+Hf0FapuDQkbydtroR1BPkNjmhJh9lgSOm9pfARZyIAimjJ2
KwxDdzhQcNHySzJKDUuModcy+nz+5SsrgmPRJGKPxE97TaUELWIjlrCt0fugSIXt
OXxDJqkO5JRq43UjOyJ4D6Fv8/CQdF4V9wHPSBO0AURdXIgul4RZrg/ccVLeOMw4
cBLYu/c/J2jFx+Vz7B8MNLr4HyEwWcYUEB3XYPwhE4LP0rS95hS34VSbSkDHSv5E
CYoCZitCQX0NFkBmOwXKCrLQbH1/PVOS7jBU7iknbkeS44PXwW+MH8+rtuMnEAOd
Ol2vSlAJfyY=
=7wtc
-----END PGP SIGNATURE-----

--=-F6EKBV5rcERTzsdzPdLI--
