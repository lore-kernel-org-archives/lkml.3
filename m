Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbaCSAx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:53:58 -0400
Received: from ozlabs.org ([203.10.76.45]:44279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758493AbaCSAx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:53:56 -0400
Date: Wed, 19 Mar 2014 11:53:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: linux-next: build failure after merge of the drm-intel tree
Message-Id: <20140319115350.7860f102a804a9975ba6e93d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Mar_2014_11_53_50_+1100_W_fezqPkiOkRfn2t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Mar_2014_11_53_50_+1100_W_fezqPkiOkRfn2t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the drm-intel tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/trace/define_trace.h:90:0,
                 from drivers/gpu/drm/i915/i915_trace.h:520,
                 from drivers/gpu/drm/i915/i915_trace_points.c:12:
drivers/gpu/drm/i915/./i915_trace.h: In function 'ftrace_raw_event_i915_gem=
_evict_vm':
drivers/gpu/drm/i915/./i915_trace.h:246:22: error: 'dev' undeclared (first =
use in this function)
       __entry->dev =3D dev->primary->index;
                      ^
include/trace/ftrace.h:574:4: note: in definition of macro 'DECLARE_EVENT_C=
LASS'
  { assign; }       \
    ^
include/trace/ftrace.h:36:9: note: in expansion of macro 'PARAMS'
         PARAMS(assign),         \
         ^
drivers/gpu/drm/i915/./i915_trace.h:236:1: note: in expansion of macro 'TRA=
CE_EVENT'
 TRACE_EVENT(i915_gem_evict_vm,
 ^
drivers/gpu/drm/i915/./i915_trace.h:245:6: note: in expansion of macro 'TP_=
fast_assign'
      TP_fast_assign(
      ^
drivers/gpu/drm/i915/./i915_trace.h:246:22: note: each undeclared identifie=
r is reported only once for each function it appears in
       __entry->dev =3D dev->primary->index;
                      ^
include/trace/ftrace.h:574:4: note: in definition of macro 'DECLARE_EVENT_C=
LASS'
  { assign; }       \
    ^
include/trace/ftrace.h:36:9: note: in expansion of macro 'PARAMS'
         PARAMS(assign),         \
         ^
drivers/gpu/drm/i915/./i915_trace.h:236:1: note: in expansion of macro 'TRA=
CE_EVENT'
 TRACE_EVENT(i915_gem_evict_vm,
 ^
drivers/gpu/drm/i915/./i915_trace.h:245:6: note: in expansion of macro 'TP_=
fast_assign'
      TP_fast_assign(
      ^
In file included from include/trace/define_trace.h:90:0,
                 from drivers/gpu/drm/i915/i915_trace.h:520,
                 from drivers/gpu/drm/i915/i915_trace_points.c:12:
drivers/gpu/drm/i915/./i915_trace.h: In function 'perf_trace_i915_gem_evict=
_vm':
drivers/gpu/drm/i915/./i915_trace.h:246:22: error: 'dev' undeclared (first =
use in this function)
       __entry->dev =3D dev->primary->index;
                      ^
include/trace/ftrace.h:708:4: note: in definition of macro 'DECLARE_EVENT_C=
LASS'
  { assign; }       \
    ^
include/trace/ftrace.h:36:9: note: in expansion of macro 'PARAMS'
         PARAMS(assign),         \
         ^
drivers/gpu/drm/i915/./i915_trace.h:236:1: note: in expansion of macro 'TRA=
CE_EVENT'
 TRACE_EVENT(i915_gem_evict_vm,
 ^
drivers/gpu/drm/i915/./i915_trace.h:245:6: note: in expansion of macro 'TP_=
fast_assign'
      TP_fast_assign(
      ^

Caused by commit a25ca17c1eac ("drm/i915: Do not dereference pointers
from ring buffer in evict event").

I have used the drm-intel tree from next-20140318 for today.

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Wed__19_Mar_2014_11_53_50_+1100_W_fezqPkiOkRfn2t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKOqiAAoJEMDTa8Ir7ZwVpbkP/0l5E0DrRiVzB29v2qquy/jp
XzeQFFd18qnF6/nXig12ECkx7QJ7ETzXGErV/lNuXsocdKczU/2NFIH2p/Y/KyXC
a+OwVltzT+faHeb+BXJy1xex1hy06BmBFVluxchBM4eSGbijbDn8weavpMZbYUZO
N4TUcR3d+wiEz0kyGgoFTatmcdMhkxuhPWQD0QYelE43CpPj11TyJVSQL6DaoUBE
tJLadv+jQGUSWUZGvZrHE1tvZlFo9VGjoK7P8gWbtq3egKp0uxYU4+zn9dVc/PdL
y6dY8x8JVDHr2s9Q4vNjVRAk/BfoDP/PQUkkHY5eXxIPiICK2CKvpPK+qO4b65Kl
iV0f2dsIgL1w8a1DLWrHOG+y6PlrEl79qBfdfHyTrBrsBoZpSx8PEd/+VQBkrrpo
hBgfgfmv8kt50uDPzbswFRyrru+fb20Gm0/HHGwth7q4m6UR3zdhFstE/4ImGdsR
CgR14OaJ2nFSKcOv0W5j8Extekq4K/HCSAOXtui/6QTv16YHao7H3LK9phg9css1
5KjIy8JYb7UJi+fUvp2AW/LsjXPNz35bIT4yAywgc70n1Hirx5uoNlTU6cg5VF4w
EqLfUrPBe6OjAFGunZ5IHFGQD9OGVhXBGxVCZVE7lhdj8uOsec0YrPQWFniIl8oK
BGR+61GXyhAp5BRCUcxD
=8bCS
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Mar_2014_11_53_50_+1100_W_fezqPkiOkRfn2t--
