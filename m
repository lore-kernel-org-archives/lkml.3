Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbaLKVtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:49:46 -0500
Received: from zucker2.schokokeks.org ([178.63.68.90]:37003 "EHLO
	zucker2.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134AbaLKVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:49:45 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2014 16:49:45 EST
Date: Thu, 11 Dec 2014 22:45:01 +0100
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org
Subject: VDSO randomization not very random
Message-ID: <20141211224501.2292cdee@pc>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-28094-1418334279-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-28094-1418334279-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

I already reported this into your bugzilla, however Greg KH told me it
might be a better idea to post it here:

With current Linux kernels it seems the address randomization for
loading the vdso library is not that random and can easily be
bruteforced.

This can easily be demonstrated. Get libvdso address from one
executable:
$ ldd /usr/bin/less|grep vdso
	linux-vdso.so.1 (0x00007fff73bfe000)

Now run ldd mutliple times and check if the same address appears:
c=3D0; while (true); do let c=3Dc+1; ldd /usr/bin/less|grep
0x00007fff73bfe000; [ "$?" =3D=3D 0 ] && echo $c; done

It usually takes only a few seconds and around 1000-2000 tries until
the loading address is repeated (note that results may vary, it seems
the randomization is biased, some values repeat more often than others).

This information is mostly from this blog entry:
http://v0ids3curity.blogspot.in/2014/12/return-to-vdso-using-elf-auxiliary.=
html
And here's a thread on oss-security discussing the issue:
http://www.openwall.com/lists/oss-security/2014/12/09/10

The latest version of paxtest added a check for this that guesses the
randomness of vdso:
https://grsecurity.net/~spender/paxtest-0.9.13.tar.gz $ ./randvdso=20
VDSO randomisation test                  : 11 quality bits (guessed)

Bugzilla entry:
https://bugzilla.kernel.org/show_bug.cgi?id=3D89591

cu,
--=20
Hanno B=C3=B6ck
http://hboeck.de/

mail/jabber: hanno@hboeck.de
GPG: BBB51E42

--=_zucker.schokokeks.org-28094-1418334279-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJUihBdAAoJEKWIAHK7tR5CdtgP/AgZE8yyjKDKVm8DzdD/T9UR
JjuqYUw5FWkowbooyJnuzO5zUnsypHm8C+mCvSJ0z7SdQJgTPSMfkRJ1l/W3mOeH
60NP2FqPzDlrRPbAa0EZDZ3Myv/u8SCP953tM/JWEoypvdZLQ6PjIAliTZsmtZ8k
ecSKBgzASMKhgYN8YpMp1XThbxHvCdtiLca17kZLGy8EMxVE9yZs5Ag6rHM9Djsr
AH4ZayGKxZtPuf5APfmdowFv5ccFjn+M6Cd+AJR1MhCcWreXnxJGy659MtSH2Zp6
I1sq8wgpYly3rL6HU7f4t2wM5Ur0K3rRg3/NMahvUUS4hX5gXAyEDAkSbqKbhOmi
4SYjFEFEHYmtbTaguAbZ8uubylim3Mysn5pN4IXwpjlE9R0Rsk7vx4VTrbNPpLqw
cXQnUu+se0GpDyQ4BIYTZCP4tr/hS0R0qCBEpnRisH74yQsPWpflfoLD5xvILH8+
efrftS2u8OfAChX2pD3Iys1A7mDhF8MSguxfwKwL4pl8jmRYMtFtvYkwN90H/aQN
PEZRSKT6kwXdP3fOQpTSIIV4uvz+l4JA6K73GCmphAGAbHfluxO3eUF/EpgW24j1
uptO/YNu95uYn1n5quj7Jr/dpKUknT8Zu+qjETGOxFk7rvbka9LHqIu0x494qevE
V/zWYET+sgckxzyZezjZ
=BYmJ
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-28094-1418334279-0001-2--
