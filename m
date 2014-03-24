Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaCXGf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:35:58 -0400
Received: from ozlabs.org ([203.10.76.45]:33623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaCXGf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:35:56 -0400
Date: Mon, 24 Mar 2014 17:35:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140324173549.2a542101d6ee893415cb791f@canb.auug.org.au>
In-Reply-To: <20140324172327.b852272309976f61238d3d22@canb.auug.org.au>
References: <20140324172327.b852272309976f61238d3d22@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Mar_2014_17_35_49_+1100_wms=zdcuyTOvz5n7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Mar_2014_17_35_49_+1100_wms=zdcuyTOvz5n7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 24 Mar 2014 17:23:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the akpm-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> In file included from include/linux/mm.h:897:0,
>                  from include/linux/mman.h:4,
>                  from arch/powerpc/kernel/asm-offsets.c:22:
> include/linux/vmstat.h: In function '__count_vm_event':
> include/linux/vmstat.h:36:2: error: implicit declaration of function 'raw=
_cpu_inc' [-Werror=3Dimplicit-function-declaration]
>   raw_cpu_inc(vm_event_states.event[item]);
>   ^
> include/linux/vmstat.h: In function '__count_vm_events':
> include/linux/vmstat.h:46:2: error: implicit declaration of function 'raw=
_cpu_add' [-Werror=3Dimplicit-function-declaration]
>   raw_cpu_add(vm_event_states.event[item], delta);
>   ^
>=20
> Caused by commit "vmstat: use raw_cpu_ops to avoid false positives on
> preemption checks".
>=20
> My kernel (even going back to v3.13) has no reference to
> raw_cpu_inc/add ... missed patch?  Ah, ha percpu-add-raw_cpu_ops.patch
> etc are in the later part of the series :-(
>=20
> I just reverted "vmstat: use raw_cpu_ops to avoid false positives on
> preemption checks" and
> "vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix"
> for today.

I added them back at the end of the akpm tree (as part of the merge
commit, so you can't easily see them :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Mar_2014_17_35_49_+1100_wms=zdcuyTOvz5n7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTL9JJAAoJEMDTa8Ir7ZwVlggP/Rg22ZyQQ02RMY9Vxn7MQvRw
Jh/tnnKsT7RB0gI4M4bHSB+oWxQubkI7CYwDplWezRt0k/KN5YfRy856xTMzhx3r
/g4+Cgv7NJ7lA1kzPHwLaKCqz/SnVbHQA6HaF4TBn6vKJKVF/HyKIJFNe/T2SEVz
Qy++R3e/Y1FyKLLLVHRIxAp5FcMDyS1ONU7xhh5z26wdUGU3/7D5Z8xV7x95ftaG
2RjG6WWrV3AkEOuHlc7vIhzobwHoEPaVskBXBG51sAERVTVz1cF0zri0yHLqaoff
KaUBWJ3H1nyrjs4JmesIENhK3RypZCxP2d5sx8nS5pL4nbHwABdt5Ic7JYG3p8Jy
qnoORu9GugtZs/vZaWawf8s1XKEyIDXesd6zNjZXVN5VTDwZwar+YYdel+JXZEEM
EwX1BCdmKwRG+5/HwK5uHvDWoCKO+NeUdEli0ik3oq099BQfnW5m9/riqgR9gV1Z
lLuAY+zyORfgUlMPo+PQZl4s3jhBs5b/BgfTcIP98xjcO+u9rrjuluGmXmnPQ/7p
3z/ZrzpNl8h45RLeb5gEdNeYtyoTPEyy83JNjCMj8dMJuhgpQIvCnyiTl+iWvf+r
XV8SjWQundvGrgXEYYyzpDpwOiVmsiv1IzVQJNgi0gVclgd/lDT4QE4VFvZFiOsy
FWaAAPwH5yVEP8nrxWkW
=8GKE
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Mar_2014_17_35_49_+1100_wms=zdcuyTOvz5n7--
