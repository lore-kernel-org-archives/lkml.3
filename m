Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab3GPTj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:39:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51360 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3GPTjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:39:55 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: mani <manishrma@gmail.com>
Cc: nitingupta910@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: [PATCH] zram percpu implementation
In-Reply-To: Your message of "Wed, 17 Jul 2013 00:27:34 +0530."
             <CAB+TZU-jHQDV9VWnznQiL_i6WE8kjwYgiND2rXwm5BgPgu7Whg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAB+TZU-BXYgrKVH94gw8Wxw8F-L4pgujAjUqKqdxgDZz+h5RWA@mail.gmail.com>
            <CAB+TZU-jHQDV9VWnznQiL_i6WE8kjwYgiND2rXwm5BgPgu7Whg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1374003427_1500P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Jul 2013 15:37:07 -0400
Message-ID: <13570.1374003427@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1374003427_1500P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Jul 2013 00:27:34 +0530, mani said:

> This patch will create a percpu structures compression algo.
> 1. Takes extra memory for workspace buffers.
> I haven't seen any performance gain with this need to find the
> root cause.

My first guess is that the higher-level zram stuff is submitting
its requests sequentially, so there's very few occasions where more
than one page is waiting for (de)compression handling at the same time.

You change the logic of zram_bvec_(read/write) - but what you'd need to
change is the code that *calls* it so that there's multiple bvec_* calls
in flight at the same time.

+    for_each_possible_cpu(cpu) {
+        printk(KERN_EMERG"[%s] Initializing for each core %d\n", cpu);

KERN_EMERG?  No.  Absolutely not.

--==_Exmh_1374003427_1500P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUeWg4wdmEQWDXROgAQJ85g/8DQxn69jvvbyQ7OMS6xNib/vsxKSHvn6R
bnWt1FwMhGf03vilJXvb8fSmlnQgU0FTUr7WabAHJ50X34qg3wpbfc+B6o6RQvZJ
4IjoC7fk/MamYPD/jtt609Or548jG1mNUTclmy1yFSI/YlsMP0U0jCZjfdOvL7TA
3/Vp+fj8k0Beyk6zr32ThFlZS/NTIQimNY0SnzSktTkcDLPwMlOx1aHvKntINmpv
gFtXnR7jlpaS3iovXbJkoNrZg6rB46xI0IQKv9RFBDzP3DZFO1WAP7lK5igXpW37
vJeOluy5tpc5fcAF52+9S8zLN+q97TEJaclzrXnlxLbA0UodxK7XQj8w1GKjHmkM
ZFau73rUkb2kiF9Iivx/iU/DSC5uxcQVHA4YoHSHpW0MjZ5vAO9h56IDrZRl8tCL
kupdT/201JJBHIJsoQ2OcHRJieayZ2A0ch9CttmFZpDyenAZk1/0Ot3JHmKSHZMu
8mAovaTo9tL4GMU7vsTVLyLMYx65AdIoZPwr+sDSzOCsC8bOu3RyeWl8UXJmF3Bx
LsLF4qhKrKB6NIPtfWfPzNDEPyT8prZ2vwHMjcKKsEWIl2E2CDfYubnqhMlaU9LC
/nUDL83DliSxSZzaP5dgfyZWCwR57mEcXusoC/slkEyYGV46INkkN0oM3C1DnghC
5HTzEWr/rHM=
=T5hf
-----END PGP SIGNATURE-----

--==_Exmh_1374003427_1500P--
