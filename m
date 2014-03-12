Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaCLBSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:18:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57052 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbaCLBSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:18:13 -0400
Date: Wed, 12 Mar 2014 01:18:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312011801.4245384d14d877881c3f5a1e@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_01_18_01_+0000_pTB932psRw0D=/w4"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the usb tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_01_18_01_+0000_pTB932psRw0D=/w4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in  between commit =
22f6a0f0e3549 ("usb: move hub init and LED blink work to power efficient wo=
rkqueue") from the usb tree and commit 77fa83cf747820 ("usb: don't use PREP=
ARE_DELAYED_WORK") from the workqueues tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/usb/core/hub.c
index 5cbf78d0be25,5da5394127e9..000000000000
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@@ -1040,8 -1049,9 +1049,9 @@@ static void hub_activate(struct usb_hu
                 */
                if (type =3D=3D HUB_INIT) {
                        delay =3D hub_power_on(hub, false);
 -                      PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func=
2);
 +                      INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
-                       schedule_delayed_work(&hub->init_work,
+                       queue_delayed_work(system_power_efficient_wq,
+                                       &hub->init_work,
                                        msecs_to_jiffies(delay));
 =20
                        /* Suppress autosuspend until init is done */
@@@ -1194,8 -1204,9 +1204,9 @@@
 =20
                /* Don't do a long sleep inside a workqueue routine */
                if (type =3D=3D HUB_INIT2) {
 -                      PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func=
3);
 +                      INIT_DELAYED_WORK(&hub->init_work, hub_init_func3);
-                       schedule_delayed_work(&hub->init_work,
+                       queue_delayed_work(system_power_efficient_wq,
+                                       &hub->init_work,
                                        msecs_to_jiffies(delay));
                        return;         /* Continues at init3: below */
                } else {

--Signature=_Wed__12_Mar_2014_01_18_01_+0000_pTB932psRw0D=/w4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH7XJAAoJELSic+t+oim9cuMP/0B+Y/YqH9UVP1xef6oNSYBU
ioSxri/SaJEJp0k4mb0RApvsEsG82EXhpUAqlegoY+8wGNJjbaJyxOCCS8kANnsd
ehmhjG51IADRiAasdG55EP1tEWLeoVn8z/NkIfSkS8hCa4EgoIkS15uct/eAY0hR
Jk1SVvr3zSD3MU8J+U2qrSs8FD4laRhk5gSv4xNafWqDusMoRSi8ZEasjlNTfqHP
Ev1FBKqcnYFNIV1RjVy0TZ0nx4rWtCsWwhXE+5/Xb1xLL+mTmRxsm0M30uEj3eyr
GLyLNV/6SaiEw+UZjCAa3XOiyQ/idA3e73gy2SfNwchLpyA10Ekk68PO292lN367
zer6wxvvzqvAFdvLndD1fbqIqCyIx4nZ3apMzwhr7m/zF1fVtEo7BkAmEDg8iDcB
fDkQypTWaWfK2OdelyChbEMXHysTAC3fhl+1376OGcbenDCvFh3vw4waqXls5XkZ
N4z8qzCXU3KVq/13omBV/9L+YHoVrMqr3rUmIKSb6i1WyCesEiwMg75C93mO8r8T
MmmNjbpFC+jXQZLSVk8ODQfc3Q8RIOZzmulvq0WOFX3Deila5ic+YEvDOCZpEuq7
LK20Qa+X34/XMjf5azvXAzc1QMdq7yGXHNlCfCjqpN+86xImWWMyBhrre4gyA6+J
eGcEjfyLU4UWeoK+wixF
=2rr7
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_01_18_01_+0000_pTB932psRw0D=/w4--
