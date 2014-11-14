Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaKNGgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:36:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbaKNGgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:36:39 -0500
Message-ID: <1415946985.3398.125.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16.y-ckt 009/170] NFS: Fix /proc/fs/nfsfs/servers and
 /proc/fs/nfsfs/volumes
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 14 Nov 2014 06:36:25 +0000
In-Reply-To: <1415704129-12709-10-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
	 <1415704129-12709-10-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/zfgJIy5JClaRz2HcScl"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/zfgJIy5JClaRz2HcScl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-11-11 at 11:06 +0000, Luis Henriques wrote:
> 3.16.7-ckt1 -stable review patch.  If anyone has any objections, please l=
et me know.
>=20
> ------------------
>=20
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>=20
> commit 65b38851a17472d31fec9019fc3a55b0802dab88 upstream.
>=20
> The usage of pid_ns->child_reaper->nsproxy->net_ns in
> nfs_server_list_open and nfs_client_list_open is not safe.
>=20
> /proc for a pid namespace can remain mounted after the all of the
> process in that pid namespace have exited.  There are also times
> before the initial process in a pid namespace has started or after the
> initial process in a pid namespace has exited where
> pid_ns->child_reaper can be NULL or stale.  Making the idiom
> pid_ns->child_reaper->nsproxy a double whammy of problems.
>=20
> Luckily all that needs to happen is to move /proc/fs/nfsfs/servers and
> /proc/fs/nfsfs/volumes under /proc/net to /proc/net/nfsfs/servers and
> /proc/net/nfsfs/volumes and add a symlink from the original location,
> and to use seq_open_net as it has been designed.
>=20
> Cc: Trond Myklebust <trond.myklebust@primarydata.com>
> Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
[...]

This needs a follow-up:

commit 21e81002f9788a3af591416b6dec60d7b67f2fb2
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Sep 8 16:17:55 2014 -0700

    nfs: fix kernel warning when removing proc entry

Ben.

--=20
Ben Hutchings
Never put off till tomorrow what you can avoid all together.

--=-/zfgJIy5JClaRz2HcScl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVGWi7ue/yOyVhhEJAQrdVA/8DLpHi8UKmwCqsQOSKhQYRZ2gOHGfF6Ch
2CCBYZALTlj0eHU3xXA0DTtPThtrtTgLswc1qzkrTyuxqPBGGXNyR4UXKoQ2zCUl
HEoSGzQ44QymNnVAsiLqzcC8ZWQvuAkDMK2D4kx/mjdGIpW60zDi/hmCG4N97c5z
qSJ/9kCz78n/3o+ywfAsegzFO/zQWNe2x6CEmmOj63NNvcpqzEXaNC34SjA7bQVh
BZPQhHZOAwsOQNCToaM+3uNZOevdCb7ELnCUKptKpXrKoOCb1z7L3A7FOEJUkA1S
+fsytOJ/lP4iK9RBIokRbxHnWV5tD0FUVP4DVh8CVdQ2+cTsechbO7/h3v9L+Ntt
2nr4sBhLlGgBNtA3J07ADfyM387tuMVk6oe7HLjXTE7/fgX+Wl8/hHO0JnFCTbyS
x0YWE2rj08NMl4FBPQvxGPUd6FteXNxRf2H7ZSLKL9iVBoEFEmgQqaG9lf0QWrrl
LpHeAFK0/aehORf8lmUeVlOWtL02nSmnD2ZRqf1FTmi9+xQijGWuCkK2Cx06/Oug
KVWk0n7/rfuwE20DkC1FjvaM3cTteQeUykXXVcKFdatjuPg/5rRIOIkPdmF/cYHy
yT6abOHvzpNdiXwAN7fceyQ2keUfHr312k/blXJkl7Byb1E2SGj7twTM6jPRjawq
xOlubCVHPlU=
=muri
-----END PGP SIGNATURE-----

--=-/zfgJIy5JClaRz2HcScl--
