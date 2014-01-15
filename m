Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaAOEtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:49:18 -0500
Received: from ozlabs.org ([203.10.76.45]:55887 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaAOEtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:49:15 -0500
Date: Wed, 15 Jan 2014 15:48:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>, Joe Perches <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-Id: <20140115154855.09736b2b99b44da360b127db@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Jan_2014_15_48_55_+1100_lxsalGKUMKwoG_Y4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jan_2014_15_48_55_+1100_lxsalGKUMKwoG_Y4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the audit tree got a conflict in
include/net/xfrm.h between commit d511337a1eda ("xfrm.h: Remove extern
from function prototypes") from Linus' tree and commit 4440e8548153
("audit: convert all sessionid declaration to unsigned int") from the
audit tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/net/xfrm.h
index cd7c46ff6f1f,f8d32b908423..000000000000
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@@ -714,23 -713,23 +714,23 @@@ static inline void xfrm_audit_helper_us
  		audit_log_task_context(audit_buf);
  }
 =20
 -extern void xfrm_audit_policy_add(struct xfrm_policy *xp, int result,
 -				  kuid_t auid, unsigned int ses, u32 secid);
 -extern void xfrm_audit_policy_delete(struct xfrm_policy *xp, int result,
 -				  kuid_t auid, unsigned int ses, u32 secid);
 -extern void xfrm_audit_state_add(struct xfrm_state *x, int result,
 -				 kuid_t auid, unsigned int ses, u32 secid);
 -extern void xfrm_audit_state_delete(struct xfrm_state *x, int result,
 -				    kuid_t auid, unsigned int ses, u32 secid);
 -extern void xfrm_audit_state_replay_overflow(struct xfrm_state *x,
 -					     struct sk_buff *skb);
 -extern void xfrm_audit_state_replay(struct xfrm_state *x,
 -				    struct sk_buff *skb, __be32 net_seq);
 -extern void xfrm_audit_state_notfound_simple(struct sk_buff *skb, u16 fam=
ily);
 -extern void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family,
 -				      __be32 net_spi, __be32 net_seq);
 -extern void xfrm_audit_state_icvfail(struct xfrm_state *x,
 -				     struct sk_buff *skb, u8 proto);
 +void xfrm_audit_policy_add(struct xfrm_policy *xp, int result, kuid_t aui=
d,
- 			   u32 ses, u32 secid);
++			   unsigned int ses, u32 secid);
 +void xfrm_audit_policy_delete(struct xfrm_policy *xp, int result, kuid_t =
auid,
- 			      u32 ses, u32 secid);
++			      unsigned int ses, u32 secid);
 +void xfrm_audit_state_add(struct xfrm_state *x, int result, kuid_t auid,
- 			  u32 ses, u32 secid);
++			  unsigned int ses, u32 secid);
 +void xfrm_audit_state_delete(struct xfrm_state *x, int result, kuid_t aui=
d,
- 			     u32 ses, u32 secid);
++			     unsigned int ses, u32 secid);
 +void xfrm_audit_state_replay_overflow(struct xfrm_state *x,
 +				      struct sk_buff *skb);
 +void xfrm_audit_state_replay(struct xfrm_state *x, struct sk_buff *skb,
 +			     __be32 net_seq);
 +void xfrm_audit_state_notfound_simple(struct sk_buff *skb, u16 family);
 +void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family, __be32 ne=
t_spi,
 +			       __be32 net_seq);
 +void xfrm_audit_state_icvfail(struct xfrm_state *x, struct sk_buff *skb,
 +			      u8 proto);
  #else
 =20
  static inline void xfrm_audit_policy_add(struct xfrm_policy *xp, int resu=
lt,

--Signature=_Wed__15_Jan_2014_15_48_55_+1100_lxsalGKUMKwoG_Y4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1hNJAAoJEMDTa8Ir7ZwVqswP/jxWynFHSLpKbHVWfU/7gmNJ
NtRuO2xfU4ropZCI9bYkOqzsmzB1dlf0ecNZMJBAF8oG3ErkrTFQfZkWFa/kptD4
P33dftCVIPSom04Jvthsq2+56KcwBi+fxwK/FfnTVmacV3Pjw2IEm5A07D+rfsTh
Q0WF07zA45GLrEEKtiNDOXbDvLPMWkSew5DCV2J6ua3cUnkejqZH/gabyadW/tdm
Mtxpy9pGEyqzIm9Z+5b8aIhLaf/6zBQL31rXJM7Is+k1Zt5y/oiLrpJ6y3WRh1Y6
mYCXiV1iPhRKeC4WocIKJ86TE482+jAx1Z1RNbd/OjzavQBDF7rFt+x1KHrddkUp
JBJr3bd6oNDorz1hBBIJTJVnW1d1I46GTAmE/mpWgyhbEh93tufsGEXAN0g0UVVm
DFZ3Kr16+n/lJheYLkhZBTs1Ireaj/sUE6Cg04BgGpCY9Egao3mRLTcxYQujYYob
JJ88S0FAL8eLtk1tj0yVywpf/FawU5Shm+1QEpwgnApPSq+2h6YgvGLhjR0XV+ba
dmFQAxJVLSFpgi49NmVV/Oi2dgoCr98nXS16sgd/iskq+uY42SpkIhoQ5iVXBZJB
iW19pdDj5Pe9JhkhQDS8H2JoM6PD12Ki+w/3ABPlbHfb9EyrCwEmJmgcnkQh/T2k
q8h8XPPIOApwndXJE88q
=kZg4
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jan_2014_15_48_55_+1100_lxsalGKUMKwoG_Y4--
