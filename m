Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3CLBBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:01:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48513 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3CLBBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:01:03 -0400
Date: Tue, 12 Mar 2013 12:00:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Escande <thierry.escande@linux.intel.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20130312120051.5fade9ddf88c9d169d61c655@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_12_00_51_+1100_Wtln0=9srY38MUxj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_12_00_51_+1100_Wtln0=9srY38MUxj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/nfc/llcp/llcp.c between commit 3536da06db0b ("NFC: llcp: Clean local
timers and works when removing a device") from the wireless tree and
commits d9b8d8e19b07 ("NFC: llcp: Service Name Lookup netlink interface")
and 40213fa8513c ("NFC: llcp: Add cleanup support for unreplied SNL
requests") from the wireless-next tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/nfc/llcp/llcp.c
index b530afa,3361170..0000000
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@@ -188,16 -156,9 +188,19 @@@ static void local_cleanup(struct nfc_ll
  	cancel_work_sync(&local->rx_work);
  	cancel_work_sync(&local->timeout_work);
  	kfree_skb(local->rx_pending);
 +}
 +
 +static void local_release(struct kref *ref)
 +{
 +	struct nfc_llcp_local *local;
 +
 +	local =3D container_of(ref, struct nfc_llcp_local, ref);
 +
 +	list_del(&local->list);
 +	local_cleanup(local, false);
+ 	del_timer_sync(&local->sdreq_timer);
+ 	cancel_work_sync(&local->sdreq_timeout_work);
+ 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
  	kfree(local);
  }
 =20

--Signature=_Tue__12_Mar_2013_12_00_51_+1100_Wtln0=9srY38MUxj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPn5DAAoJEECxmPOUX5FETS0P/RGnrEjRpOQ81FtJOxEqh7S/
IgHrT20pJ2ux/j48Nkn4Ok/qYIJWcnGNLN/BzM//h/bTSHzuX2/ycvNF+K7i/OhY
je6yAILJCNssRDnZBjH9wJ6t3Jc2WO+jryJ3Y71GR/+9UdktsfbIFqONMUb4Gx/i
BgTxYtSXvkCu/OC6tTnuwZ1Sbfo8yW8L11wo9w2EJwykYsklOnvu3w2LNA2cic1H
cCGitFCD3oqGnizQPV2q+Nun9CwyTe1eQ5wLnsOostD7d3J/ufKt8OxglSrtepDk
4HK3I7WFqbtX7axtngMLtKXc1gsouqty/15s96ozG9CabM+kTtrpGIANRZvChekk
9N0HdtvhhfX8zUey6LF/mcW0e5UvVT/QgN6wnJ3PATHvgvPWF28g9dr7fAIGRaZo
GnQA19V+W8+DkNGvX1dufCZRpgdWznr7gEvwkEWvfNDb8tfyegJ1eQK7fCTTW8ce
iqwHxEtq390iYH9yYzvuW1P41GGdF18gNm6eSM6PBSkgXCMD6rv0VuE/q6D/vDRX
a7xuQAMWES/M21ctFavjOZQAoV7DU6N8NN82jHeEXs+7qRUXEPo2AXJ+nE0YygXH
UWDSzMovGPYpxg+xG6x23XUTQFiYOtZDm4VH5i0HmC0peXtyCJf6We7T9WlcxrcA
WfmQS8hkAfAxWgyAf5nT
=TE5j
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_12_00_51_+1100_Wtln0=9srY38MUxj--
