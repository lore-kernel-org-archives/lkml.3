Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaDAEHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:07:31 -0400
Received: from ozlabs.org ([203.10.76.45]:41548 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaDAEH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:07:28 -0400
Date: Tue, 1 Apr 2014 15:07:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-Id: <20140401150721.1e9d4e6c36660d5411c10f37@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Apr_2014_15_07_21_+1100_kdychD2_Oo/1=j4r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Apr_2014_15_07_21_+1100_kdychD2_Oo/1=j4r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the audit tree got a conflict in
kernel/audit.c between commit aa4af831bb4f ("AUDIT: Allow login in
non-init namespaces") from Linus' tree and commit 5a3cb3b6c3a0 ("audit:
allow user processes to log from another PID namespace") from the audit
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

[Eric: that audit tree commit has no Signed-off-by from you even though
you committed it ... there are a few like that]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/audit.c
index 95a20f3f52f1,ad77d1e80895..000000000000
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@@ -607,20 -607,9 +607,19 @@@ static int audit_netlink_ok(struct sk_b
  {
  	int err =3D 0;
 =20
- 	/* Only support the initial namespaces for now. */
+ 	/* Only support initial user namespace for now. */
 +	/*
 +	 * We return ECONNREFUSED because it tricks userspace into thinking
 +	 * that audit was not configured into the kernel.  Lots of users
 +	 * configure their PAM stack (because that's what the distro does)
 +	 * to reject login if unable to send messages to audit.  If we return
 +	 * ECONNREFUSED the PAM stack thinks the kernel does not have audit
 +	 * configured in and will let login proceed.  If we return EPERM
 +	 * userspace will reject all logins.  This should be removed when we
 +	 * support non init namespaces!!
 +	 */
- 	if ((current_user_ns() !=3D &init_user_ns) ||
- 	    (task_active_pid_ns(current) !=3D &init_pid_ns))
+ 	if ((current_user_ns() !=3D &init_user_ns))
 -		return -EPERM;
 +		return -ECONNREFUSED;
 =20
  	switch (msg_type) {
  	case AUDIT_LIST:

--Signature=_Tue__1_Apr_2014_15_07_21_+1100_kdychD2_Oo/1=j4r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTOjt9AAoJEMDTa8Ir7ZwV+AQP/R4KgK/7Cf9pFmizqhOlyCU1
3Bjs19TEWNKIWWSvoWub9F4iZ+4DkqQOz+gsfRsTOpply0OZMeKNCKHNxvh74KgO
XhCx9UsGf9H11K/RZqctCsZHYzhy+6qa3IffRnQ44LYWNfLOrjKEu/k4mum4BaBi
MJ1CGO/TmnNPcZlrnPWCRaix6bmgDmXrQnARTPBtfkrH7QmOLjvrt0OalOYxttBm
KhUiV5FKfYspRP+gmEYRuoDjXU+nEZ2k87bXK0NNmDp/VewsDlfTBk9NLOEZoM8m
ADjJ9ExbUWb2vVL1SVtLS4CZ8wUHNMqJQASfs0o/RPRzrhZ6RT4ln2nd1Gw7S5YW
Q8zn6SKsuDShAHx8iI/ZXBAIiPiXUuQZnwOwhzsCWszizWsms/CuOC+hn00LSAor
5ptGRnD01VH8IzL1fySOjccl+PagrMTve68ClfpwRW8Hp8wh/3bV+IqEFc6SLOck
Aiozsv/z1vdWzixACDqXZclXivRvsq7phy8T8pxrFu3lDFV5IzjDHOqgzCB+Qp+P
L9ac4MNXB1VYk53AwMZGzE6CpIJnj/PR2qj+7GMhB701lsztFszbiiXLvRRDFFbb
BJwuK48LLXDJKCSoamk5U2y9FfmZ/1S5/rdnX98b3ewwp13SECV2RQc4/0H4moQC
ygT4YS5+hXyD+JTJcIO/
=QolZ
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Apr_2014_15_07_21_+1100_kdychD2_Oo/1=j4r--
