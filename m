Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaLRQpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:45:35 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:48687 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaLRQpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:45:33 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid context at mm/slab.c:2849
In-Reply-To: Your message of "Tue, 16 Dec 2014 20:09:54 -0500."
             <2966.1418778594@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <2966.1418778594@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418921116_3517P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2014 11:45:16 -0500
Message-ID: <5444.1418921116@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418921116_3517P
Content-Type: text/plain; charset=us-ascii

On Tue, 16 Dec 2014 20:09:54 -0500, Valdis Kletnieks said:

> Spotted these two while booting single-user on 20141216.  20141208
> doesn't throw these, so it's something in the last week or so..

Gaah!  Turns out that 20141208 *is* susceptible - it had been booting
just fine for several days, but it went around the bend, apparently due
to a userspace or initrd change.

egrep 'BUG|Linux vers' from my syslog:

Dec  9 12:19:53 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec  9 21:19:53 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 10 12:39:45 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 10 20:56:28 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 11 10:46:49 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 11 23:53:10 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 12 11:13:19 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 12 19:26:24 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 12 19:33:32 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 12 19:42:30 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 12 20:00:39 turing-police kernel: [ 1109.635328] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 20:00:43 turing-police kernel: [ 1113.680912] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 20:33:15 turing-police kernel: [ 3062.345461] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 20:37:48 turing-police kernel: [ 3335.788891] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 20:41:57 turing-police kernel: [ 3584.265255] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 20:42:47 turing-police kernel: [ 3633.863552] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 20:51:33 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
Dec 12 21:51:04 turing-police kernel: [ 3587.132867] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 22:20:01 turing-police kernel: [ 5322.313024] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 12 23:06:00 turing-police kernel: [ 8077.463289] BUG: sleeping function called from invalid context at mm/slab.c:2849
Dec 13 00:00:05 turing-police kernel: [11318.405826] BUG: sleeping function called from invalid context at mm/slab.c:2849

I need to figure out what changed around 7:30PM on the 12th.


--==_Exmh_1418921116_3517P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJMEnAdmEQWDXROgAQKvNxAAor6BZKRb4N1EONZaw9sNm2i8V+AWqxQd
dxRGVBqBhY/dhWTfwuuePwhewe76Nf1pfgf/OwQBx0S6CrU+pkmPEbpdTbxL9fAo
svqAQ0Wp0dpvyu0DI6O8ianguOw258u5bysTe1F2p+wv68WzFSC8eBelNywVVvrr
FiDwOK3Ggfu9O426X6FO1EvL6e41eUXbV7slA/JH7+7oSFdZkWlArucf8uD1l34z
DAQ7ywtiV477nkhW511/yAK+Nbz3E8remWNfsu2qTY/RM9coNGkOdlhpq2mGoMAB
HPqJWTujLyS8NzaTB/hzf3mq9jMvDXmfOjizijB/nkykrC0qOJJxWFTAIewWQICz
t2MQMhymBbokehX1J11UISEhuEj2v0dwxzYFB9C/wmedNg7xFzEAUBEY68IbTPZx
naSjHVAU8RVi/mHGHec0us6gZVjC3+M5i/U6+GoFTBAD14fRKnx8q2CDXw5RnmV/
1BLJPuMf4DWK/tvHzO4C09m6dSHilgkeZ1QCxUcpUuKXFTndYfAiUo3AN4Sp7JAk
+80N8ckjA0710BqZ8TVJR1vEg5NuouORKZfAVvreFC+3cL/1D0QQzNRHEo1PTT6/
86vCklSBN2oLmlzI/HBdjl/VgSt4WIAw3b3ocR+YyDUq0TdPV6ebtpxYcCNJC4Dg
/MIgKvOya2Q=
=Tr3z
-----END PGP SIGNATURE-----

--==_Exmh_1418921116_3517P--
