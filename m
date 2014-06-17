Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaFQMNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:13:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaFQMNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:13:43 -0400
Date: Tue, 17 Jun 2014 14:13:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org,
        Drew Richardson <drew.richardson@arm.com>
Subject: Re: [PATCH] perf: Handle compat ioctl
Message-ID: <20140617121328.GO3213@twins.programming.kicks-ass.net>
References: <1402671812-9078-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e4annfiqlsPm5rKd"
Content-Disposition: inline
In-Reply-To: <1402671812-9078-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e4annfiqlsPm5rKd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2014 at 04:03:32PM +0100, Pawel Moll wrote:
> When running a 32-bit userspace on a 64-bit kernel (eg. i386
> application on x86_64 kernel or 32-bit arm userspace on arm64
> kernel) some of the perf ioctls must be treated with special
> care, as they have a pointer size encoded in the command.
>=20
> For example, PERF_EVENT_IOC_ID in 32-bit world will be encoded
> as 0x80042407, but 64-bit kernel will expect 0x80082407. In
> result the ioctl will fail returning -ENOTTY.
>=20
> This patch solves the problem by adding code fixing up the
> size as compat_ioctl file operation.
>=20
> Reported-by: Drew Richardson <drew.richardson@arm.com>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---

This gets me (on my favourite x86_64 .config):

kernel/events/core.c: In function =E2=80=98perf_compat_ioctl=E2=80=99:
kernel/events/core.c:3726:32: error: =E2=80=98compat_uptr_t=E2=80=99 undecl=
ared (first use in this function)
kernel/events/core.c:3726:32: note: each undeclared identifier is reported =
only once for each function it appears in


--e4annfiqlsPm5rKd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJToDDoAAoJEHZH4aRLwOS6zLUP/0My9zndXOOlVykp2rW4msFJ
83k+P0jWawDEpvA0ZmU2Sed4oe7vpxxkbT4elDPeWa80Kin5NnHc/wbbfSZ1z5sT
blLJlRBSu3ATtH0D1bi6qNB42OS3yXBXD4T9KdxvLYwti/4IpbyvRn3plxsDVMRL
oh/pzgVh1tibkKAU4rIeDZekTGOI/I5YSsk6JaJT05UsUk9yJnp99gcJfm6xMmRk
XzBhjk3EuTI8FUgnHBx1BpZfIvr0hVkgusL4SNVexsKTrAT1tIywm6mI4tLDl7F1
BqUNNVGyeuCKV+tofQtijIvSy0sxrkD7k+6ljUvgXIvq9dVRSDC54bLqLkhYuNPx
b0t7xD99guTOKb/GElQ7JBJy43dfmyDIYoQB6MrwXsl3l+ZkZ/kLVA5B6lhxxoyg
dH5UEkGTsV0AtNbpg/4Q+iC0/3tTl2q1PD+bgUQYyUtIUAM1970ml65MzeAG8Rcw
fSL6FPfLf2tNhyyxV/UBluqXwEcxx0fYKrG3b3Q0ORmZYjaBkoWDIWp1/INPgDqR
HFs96YuT6mHK9ufXzBGcPXCHmV0QQGqmETQ+e6pi7T/Tkz3W7TpcOJH4OQD3Wv4R
qxvoKp3JQ3hjSSj2M6wuZKIth019o7dUxflS6FyHsaD2NbdnRQNgRzJx4lQW+ivo
anpecHF/I6f8dVegFw4M
=BH0f
-----END PGP SIGNATURE-----

--e4annfiqlsPm5rKd--
