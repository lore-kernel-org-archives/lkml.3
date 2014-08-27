Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987AbaH0PPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:15:22 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53716 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934344AbaH0PPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:15:18 -0400
Date: Wed, 27 Aug 2014 17:15:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: kpark3469@gmail.com
Cc: akpm@linux-foundation.org, keun-o.park@windriver.com, hpa@zytor.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com,
        oleg@redhat.com, prarit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
Message-ID: <20140827151504.GA22824@ulmo>
References: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 07:13:36PM +0900, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@windriver.com>
>=20
> Although there are many obs_kernel_param and its names are
> earlyprintk and also EARLY_PRINTK is also enabled, we could not
> see the early_printk output properly until now. This patch
> considers earlycon as well as earlyprintk.
>=20
> Signed-off-by: Sahara <keun-o.park@windriver.com>
> ---
>  init/main.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/init/main.c b/init/main.c
> index bb1aed9..235d248 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -426,7 +426,8 @@ static int __init do_early_param(char *param, char *v=
al, const char *unused)
>  	for (p =3D __setup_start; p < __setup_end; p++) {
>  		if ((p->early && parameq(param, p->str)) ||
>  		    (strcmp(param, "console") =3D=3D 0 &&
> -		     strcmp(p->str, "earlycon") =3D=3D 0)
> +		     ((strcmp(p->str, "earlycon") =3D=3D 0) ||
> +		     (strcmp(p->str, "earlyprintk") =3D=3D 0)))
>  		) {
>  			if (p->setup_func(val) !=3D 0)
>  				pr_warn("Malformed early option '%s'\n", param);

It seems like this patch causes the following warning for me during
boot:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc2-next-20140827 (thierry.reding@ulmo)=
 (gcc version 4.9.0 (GCC) ) #18 SMP PREEMPT Wed Aug 27 17:08:12 CEST 2014
[    0.000000] CPU: ARMv7 Processor [413fc0f3] revision 3 (ARMv7), cr=3D10c=
5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction ca=
che
[    0.000000] Machine model: NVIDIA Tegra124 Jetson TK1
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at /home/thierry.reding/src/kernel/li=
nux-work.git/kernel/printk/printk.c:2402 register_console+0x60/0x37c()
[    0.000000] console 'earlycon0' already registered
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-rc2-next-2014=
0827 #18
[    0.000000] [<c0015fec>] (unwind_backtrace) from [<c0011aac>] (show_stac=
k+0x10/0x14)
[    0.000000] [<c0011aac>] (show_stack) from [<c062b700>] (dump_stack+0x98=
/0xd8)
[    0.000000] [<c062b700>] (dump_stack) from [<c0025ba0>] (warn_slowpath_c=
ommon+0x70/0x8c)
[    0.000000] [<c0025ba0>] (warn_slowpath_common) from [<c0025bec>] (warn_=
slowpath_fmt+0x30/0x40)
[    0.000000] [<c0025bec>] (warn_slowpath_fmt) from [<c00639b8>] (register=
_console+0x60/0x37c)
[    0.000000] [<c00639b8>] (register_console) from [<c0883870>] (setup_ear=
ly_printk+0x20/0x28)
[    0.000000] [<c0883870>] (setup_early_printk) from [<c087f43c>] (do_earl=
y_param+0x6c/0xd0)
[    0.000000] [<c087f43c>] (do_early_param) from [<c003cba0>] (parse_args+=
0x238/0x3d0)
[    0.000000] [<c003cba0>] (parse_args) from [<c087f814>] (parse_early_opt=
ions+0x38/0x40)
[    0.000000] [<c087f814>] (parse_early_options) from [<c087f84c>] (parse_=
early_param+0x30/0x40)
[    0.000000] [<c087f84c>] (parse_early_param) from [<c088206c>] (setup_ar=
ch+0x4b4/0x974)
[    0.000000] [<c088206c>] (setup_arch) from [<c087f8f8>] (start_kernel+0x=
98/0x3a8)
[    0.000000] [<c087f8f8>] (start_kernel) from [<80008074>] (0x80008074)
[    0.000000] ---[ end trace cb88537fdc8fa200 ]---
[    0.000000] cma: Reserved 128 MiB at a7800000
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] On node 0 totalpages: 524032
[    0.000000] free_area_init_node: node 0, pgdat c091cc00, node_mem_map e6=
7b7000
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2574 pages used for memmap
[    0.000000]   HighMem zone: 329472 pages, LIFO batch:31
[    0.000000] PERCPU: Embedded 8 pages/cpu @e6767000 s8832 r8192 d15744 u3=
2768
[    0.000000] pcpu-alloc: s8832 r8192 d15744 u32768 alloc=3D8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 522512
[    0.000000] Kernel command line: console=3DttyS0,115200n8 ignore_logleve=
l rootwait ro earlyprintk ip=3D:::::eth0:dhcp root=3D/dev/nfs nfsroot=3D192=
=2E168.69.100:/srv/nfs/tegra124 drm.debug=3D0xf cma=3D128M

Reverting the patch eliminates the warning. earlyprintk does work fine
for me without this patch.

Thierry

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/fX4AAoJEN0jrNd/PrOhNgwP/A+ASlBprmyMtn/KgNxW8V1K
g4pvZneFk7XwsW0ILWCxlnwdAFcqnhQSej9N+Nbk8qEG/jV7IrpFCzAsEfpi8DUf
OXtdNOL0oZIXRNOMuprmxsuezZhVoHLF70yCZHQyt6WEEMTX6B7+n4gA88S2ZaNB
vgOIieLsXNOawoXIQUfoUyOIa0ipwUX3GAiAhUdhZHf9dONmrI4XQSZHe3fAZuJE
d0L40K70JGgRnxBqYguR50K0UqZ7yhOTfzFlRbUnFMbICZKz0x5f/UpC6XeSgJKi
UDPNtdbLcHKrFKQqeACi93Sj1FJS1srzvinpoMsnofexkR1X+PT5HBzw9WfOY5nH
vofXjJ/nLNchis3GP9uW4QUCK7LVNyp6+4eIIPpIUqKf614SU8cvTA7U847ynSBZ
F/VsOnXfDinuz715ihEsuwfWhUHIxrxFTRHrRrVa4WTqtEOAJQjZta2UOSW+/2j0
nlTgr1M8Rpqu/NOEnHdFtbp/edvMSulRujIr2buNJ86KhgwZszNV1xcEyH/RlSnY
JlxGkXm7irfrcjkfr6/E1V5kUjlntXPy3BfIJ5dHjTOGUhVqYzOBz8U5mPuuxEs+
ZMN17KOkHl2JYIGaTT/4TGTAEalVgxWsRYep8w1VQM2FRnr8qnEkndrqiUt2U8cQ
rRpTzSFnwUNrtZlzvmeA
=95fF
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
