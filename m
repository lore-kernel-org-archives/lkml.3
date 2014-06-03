Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaFCMO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:14:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbaFCMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:14:27 -0400
Date: Tue, 3 Jun 2014 14:14:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, bsegall@google.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com
Subject: Re: [RFC PATCH 07/16 v3] Init Workload Consolidation flags in
 sched_domain
Message-ID: <20140603121416.GH30445@twins.programming.kicks-ass.net>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-8-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iogImpl5JeySoxiL"
Content-Disposition: inline
In-Reply-To: <1401431772-14320-8-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iogImpl5JeySoxiL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 02:36:03PM +0800, Yuyang Du wrote:
> Workload Consolidation can be enabled/disabled on the fly. This patchset
> enables MC and CPU domain WC by default.
>=20
> To enable CPU WC (SD_WORKLOAD_CONSOLIDATION=3D0x8000):
>=20
> sysctl -w kernel.sched_domain.cpuX.domainY.flags +=3D 0x8000
>=20
> To disable CPU WC:
>=20
> sysctl -w kernel.sched_domain.cpuX.domainY.flags -=3D 0x8000
>=20
> Signed-off-by: Yuyang Du <yuyang.du@intel.com>
> ---
>  include/linux/topology.h |    6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 7062330..ebc339c3 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -102,12 +102,14 @@ int arch_update_cpu_topology(void);
>  				| 0*SD_SERIALIZE			\
>  				| 0*SD_PREFER_SIBLING			\
>  				| arch_sd_sibling_asym_packing()	\
> +				| 0*SD_WORKLOAD_CONSOLIDATION	\
>  				,					\
>  	.last_balance		=3D jiffies,				\
>  	.balance_interval	=3D 1,					\
>  	.smt_gain		=3D 1178,	/* 15% */			\
>  	.max_newidle_lb_cost	=3D 0,					\
>  	.next_decay_max_lb_cost	=3D jiffies,				\
> +	.consolidating_coeff =3D 0,					\
>  }
>  #endif
>  #endif /* CONFIG_SCHED_SMT */
> @@ -134,11 +136,13 @@ int arch_update_cpu_topology(void);
>  				| 0*SD_SHARE_CPUPOWER			\
>  				| 1*SD_SHARE_PKG_RESOURCES		\
>  				| 0*SD_SERIALIZE			\
> +				| 1*SD_WORKLOAD_CONSOLIDATION	\
>  				,					\
>  	.last_balance		=3D jiffies,				\
>  	.balance_interval	=3D 1,					\
>  	.max_newidle_lb_cost	=3D 0,					\
>  	.next_decay_max_lb_cost	=3D jiffies,				\
> +	.consolidating_coeff =3D 180,					\
>  }
>  #endif
>  #endif /* CONFIG_SCHED_MC */
> @@ -167,11 +171,13 @@ int arch_update_cpu_topology(void);
>  				| 0*SD_SHARE_PKG_RESOURCES		\
>  				| 0*SD_SERIALIZE			\
>  				| 1*SD_PREFER_SIBLING			\
> +				| 1*SD_WORKLOAD_CONSOLIDATION	\
>  				,					\
>  	.last_balance		=3D jiffies,				\
>  	.balance_interval	=3D 1,					\
>  	.max_newidle_lb_cost	=3D 0,					\
>  	.next_decay_max_lb_cost	=3D jiffies,				\
> +	.consolidating_coeff =3D 180,					\
>  }
>  #endif

What tree are you working against, non of that exists anymore. Also, you
cannot unconditionally set this.

--iogImpl5JeySoxiL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjbwYAAoJEHZH4aRLwOS6a1cQAIYcImsuY55lKsziw8F8S7dB
hCJHD0P+Uiq6xPVoZH5jZON5mpXtZb6LyA+ehUu/pLt72RYTrGRHBLhQQgKNlac4
/onIkfPgT5VBKLiS8bgTQvadHDxmGhN+DsFzyFgkF9EMkRi+h4Km9EQ/+NMgBDPG
HvgFeprcCVaaSeJ76hh9/oH5LBMe7Nva4VcryOzsBNsJuWdAa5lqOGmp7cxSCHdr
3Xk1pFlXlprwQmJru6hJNDkcmaZMS2XDCPcbbcwcyyErTl3zxJslgHUN/NsH5b+f
8Ic3p1GjdpWtR6OJ6yZ5T1Zvk4uzcX+tEuVIPuY2L9Pl+CL9k20UIoXDOvZYytQk
FjcL+MVAKZL3yUY2UGQdFryR/sdJx/AQ2cygXyEgKKmJZXuvVvHK1BvsGFK6eVbz
A3hZVRm9uqSseKH4ROEo8np2HJxQEG9tmslcJ7N1H0SatBC+5D64vuKhxfwgWayK
xnwTHrbHjnuNAFzSy9rXMLLdf/otFl+YeWzzPV4H3merINJOcUoPiBKdBJ3yZUgT
m+xAB2x13xet0+gn1xmejcX1sk7NArU8gzrazkRUl+m7F7dX7i/KItv2V0H0OuQf
Vp38Pl3exoct+bVZosLyqzg5Y74R8jf7OTS5JTPGPJMATSKX0ZPdP178QpDe+BJF
F0xS2q9RP6ft89jl7WZ1
=P83/
-----END PGP SIGNATURE-----

--iogImpl5JeySoxiL--
