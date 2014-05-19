Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaESIN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:13:26 -0400
Received: from ozlabs.org ([103.22.144.67]:41834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaESINX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:13:23 -0400
Date: Mon, 19 May 2014 18:13:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: linux-next: build warning after merge of the akpm tree
Message-ID: <20140519181314.1b92c548@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1GYj_T+i9QUSP4Ekhm.Mi/P"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1GYj_T+i9QUSP4Ekhm.Mi/P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (arm
multi_v7_defconfig) produced these warnings:


ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [=
enabled by default]
ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.r=
wsem') [enabled by default]
ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [=
enabled by default]
ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.r=
wsem') [enabled by default]

and many more in other files ...

Presumably a result of commit fe2038c57c03 ("rwsem: Support optimistic
spinning").

I reverted that commit (and
"rwsem-support-optimistic-spinning-checkpatch-fixes") for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/1GYj_T+i9QUSP4Ekhm.Mi/P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTeb0gAAoJEMDTa8Ir7ZwVHfwP/Rsc9lTL9dbwBbhFYnnr1XBD
gdFDM0yKSwzG9C0QOCLzqYBg5mYsxD9NU9zyXjxMSTeQkPukBw8C83b22M9Q0kSS
OuBAe3KBVbOvBWCns78ADj8synYWFgjpb+z/xbB+L7edlmVZDjtaBUv08QoVuUL1
2xToip8x80VMHBlnkmvYHTAd+OgGCqN/NeAbFt5nWv6NOydes0BjxAQdnNY085BU
HIZjySe6cycFt0dRsqfGlqsFyQonTZeRk9T9N8l4xQhcURSNU4Qu9Kbi984vtOQw
PykN98rdIfG2+JbqoAEwFzoa35KbL1QzUtR5bg420qtGOPe+hmqmOagwq2ckF0nD
pPO8yJfKEJdmDh8YQ2u7ieO9q0TjS+rGSZU+1yyT21sjkT+7ebWcxgKsRJlpF4Nf
sAKZqqqaCYZ2UsSL3bl++2pkhvQbd62VI0fKeKJyebnM2XH9ppLwEisnJVWY/Es/
7zLN56scQIDVLI/MjqlyXUVgCrfti75rOcSF/Z6tqT9mE+OWoYeJJ4in6C6jmf2J
TADIPXfZi5oQhxmtnZEnA9ztavy12kRXPrnqp0pUbshTwNxeNLxW115JLNRM92qg
jzXpR7pFaF1M5QahI0hLXPeZ6XmFei2bAshB5Iq220jqQmEV7Giuns/r5SkUe3sB
dbPejhTbfL61YKgeks25
=T5Ib
-----END PGP SIGNATURE-----

--Sig_/1GYj_T+i9QUSP4Ekhm.Mi/P--
