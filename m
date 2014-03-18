Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaCRHlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 03:41:10 -0400
Received: from ozlabs.org ([203.10.76.45]:44486 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaCRHlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 03:41:09 -0400
Date: Tue, 18 Mar 2014 18:41:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fariya Fatima <fariyaf@gmail.com>
Subject: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
Message-Id: <20140318184102.63b5780e764ad20670f2cbc0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Mar_2014_18_41_02_+1100_7nYp7sJX7I1Y0Cjv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2014_18_41_02_+1100_7nYp7sJX7I1Y0Cjv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/net/wireless/rsi/rsi_mgmt.h:22:0,
                 from drivers/net/wireless/rsi/rsi_91x_core.c:17:
drivers/net/wireless/rsi/rsi_91x_core.c: In function 'rsi_dbg':
drivers/net/wireless/rsi/rsi_main.h:44:20: error: function 'rsi_dbg' can ne=
ver be inlined because it uses variable argument lists
 static inline void rsi_dbg(u32 zone, const char *fmt, ...)
                    ^

I got quite a few of these.  I am using gcc version 4.8.1 if that matters.

Caused by commit dad0d04fa7ba ("rsi: Add RS9113 wireless driver") from
the wireless-next tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Mar_2014_18_41_02_+1100_7nYp7sJX7I1Y0Cjv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJ/iSAAoJEMDTa8Ir7ZwV/TMP/0sgPpTroU38xCKSGYNZk98K
kUkxAQltb8MlztZTkYNOcTNVa9pCRyF2gogeG1vq8RsIJsI2gqIyu+B1wq4a84Ws
bsD/ZbF7DttxrdOzrSi+cb0eWjznGLFPeeOE/NoySEbo/uwrcEnLw0So4VrQhpA/
VPMWfCigOh2TNsZZO3DudYzvjemRPHPeh8+GKWzb571mQOoalHlK1j9O8rziXAZf
vGxy0LUZNA8KYImiG6Wbdgrd6MP02naQ6KpoPnE84AKildmrCL5Yx+o709lEdQA/
abbwvt6ytSjXv9Vp3ngxrWc3s/yIWjfqQxdYu+GRNgMSubepcdw1IIT3qcxo3rNL
5jbNbD+eSXZlN3Q0sC1W7scF24r7tX5jyguDLZwMvJ1/Oc7e49aSnJlffkYy8IEg
JR/Xi/Q0czj3oYIgYOsIuh6OAZZgE5o1muGKU7X010J2huY5TQEAgEmzwVmqpkRa
B0XBI9FIAtAcGPoaEgZNQZ7yo0lMOZstos/k6Tri4pFuwTbyMm8FjEAmMu/sZmH/
Edd5sr3wBWTEUYwXRvryqqpp0d6+QjwUyr4sNjAQzMdGXAgKlOP3lhc5doQzlpwH
4OcS+/JCdAdC7Dy6Z8DI/CC3OjdRpl+nqufv7K5PQCtOUJnmOK9bDXupfpcoZoK1
VUVynjkLbyt0OJX7/Qvi
=JQLf
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2014_18_41_02_+1100_7nYp7sJX7I1Y0Cjv--
