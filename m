Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbbAKWjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:39:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60188 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbbAKWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:39:21 -0500
Message-ID: <1421015948.19708.34.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16.y-ckt 053/168] ARM: pxa: fix hang on startup with
 DEBUG_LL
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 11 Jan 2015 22:39:08 +0000
In-Reply-To: <1418653622-21105-54-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	 <1418653622-21105-54-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UXI+hxTCkfjayNNgMmmt"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UXI+hxTCkfjayNNgMmmt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-12-15 at 14:25 +0000, Luis Henriques wrote:
> 3.16.7-ckt3 -stable review patch.  If anyone has any objections, please l=
et me know.
>=20
> ------------------
>=20
> From: Robert Jarzmik <robert.jarzmik@free.fr>
>=20
> commit cde7fc879969f933614b1256df2625d6ff637bab upstream.
>=20
> The commit 2111667b4677 ("ARM: pxa: call debug_ll_io_init for
> earlyprintk") triggers in the current kernel the attached backtrace on
> PXA/tosa early in the boot time when DEBUG_LL is enabled.

That was in 3.17-rc1, so I don't think this fix was needed for 3.16.  I
don't know whether it causes any harm to apply it here.

Ben.

> It is due to overlap between uart virtual memory defined in
> DEBUG_UART_VIRT and mapped by debug_ll_io_init() and peripheral bus
> mapped by pxa_map_io at the same address, 0xf2100000.
>=20
> As hinted by Arnd, map early virtual memory for low level debug on
> address 0xf6200000, even if that means 2 virtual mappings will give
> access to the pxa internal UARTs (FFUART, BTUART, STUART, ...).
>=20
> ------------[ cut here ]------------
> kernel BUG at /home/lumag/linux/mm/vmalloc.c:1143!
> Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-00032-g8e0d202-dirty #23
> task: c062a5a8 ti: c0620000 task.ti: c0620000
> PC is at vm_area_add_early+0x54/0x84
> LR is at add_static_vm_early+0xc/0x60
> pc : [<c03e1100>]    lr : [<c03d9ef4>]    psr: 800001d3
> sp : c0621f04  ip : c03efa74  fp : c03edf84
> r10: c0637e98  r9 : 40000001  r8 : c03da57c
> r7 : c3ffcfb0  r6 : 00000000  r5 : c3ffcfb0  r4 : 02000000
> r3 : c3ffcfd8  r2 : f2100000  r1 : f4000000  r0 : c3ffcfb0
> Flags: Nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 00007977  Table: a0004000  DAC: 00000017
> Process swapper (pid: 0, stack limit =3D 0xc06201c8)
> Stack: (0xc0621f04 to 0xc0622000)
> 1f00:          c3ffcfd8 40000001 c3ffcfd8 c03ee08c c03da570 c03db90c c063=
7d24
> 1f20: 00000000 c03ec7cc c066e654 a0700000 000a0700 c03db914 c03db90c c03d=
af84
> 1f40: 00000000 000a0000 c0000000 c03ec7cc 000a0700 c0700000 ffff1000 000a=
3fff
> 1f60: 00001000 00000007 00000000 c03ec7cc c0008000 c03ed748 c0621fd4 c03d=
5d18
> 1f80: 69052d00 a03ec48c 00000000 c03d8ad0 0000006c 00007977 c036c6e8 0000=
0001
> 1fa0: c0621fd4 c03ed744 c0628000 a0004000 69052d00 a03ec48c 00000000 c03d=
68d4
> 1fc0: 00000000 00000000 00000000 00000000 00000000 c03ed748 c0649894 c062=
801c
> 1fe0: c03ed744 c062b2f0 a0004000 69052d00 a03ec48c a0008040 00000000 0000=
0000
> [<c03e1100>] (vm_area_add_early) from [<c03d9ef4>] (add_static_vm_early+0=
xc/0x60)
> [<c03d9ef4>] (add_static_vm_early) from [<c03da570>] (iotable_init.part.6=
+0xa8/0xb4)
> [<c03da570>] (iotable_init.part.6) from [<c03db914>] (pxa25x_map_io+0x8/0=
x24)
> [<c03db914>] (pxa25x_map_io) from [<c03daf84>] (paging_init+0x744/0x8d8)
> [<c03daf84>] (paging_init) from [<c03d8ad0>] (setup_arch+0x354/0x608)
> [<c03d8ad0>] (setup_arch) from [<c03d68d4>] (start_kernel+0xa8/0x3dc)
> [<c03d68d4>] (start_kernel) from [<a0008040>] (0xa0008040)
> Code: e5904008 e0811004 e1520001 2a000005 (e7f001f2)
> ---[ end trace f24b6c88ae00fa9a ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
>=20
> Reported-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> [ luis: backported to 3.16: adjusted context ]
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  arch/arm/Kconfig.debug                    | 2 +-
>  arch/arm/mach-pxa/include/mach/addr-map.h | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 8f90595069a1..1fdb08427db7 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -1118,7 +1118,7 @@ config DEBUG_UART_VIRT
>  	default 0xf1600000 if ARCH_INTEGRATOR
>  	default 0xf1c28000 if DEBUG_SUNXI_UART0
>  	default 0xf1c28400 if DEBUG_SUNXI_UART1
> -	default 0xf2100000 if DEBUG_PXA_UART1
> +	default 0xf6200000 if DEBUG_PXA_UART1
>  	default 0xf4090000 if ARCH_LPC32XX
>  	default 0xf4200000 if ARCH_GEMINI
>  	default 0xf7000000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART0 || \
> diff --git a/arch/arm/mach-pxa/include/mach/addr-map.h b/arch/arm/mach-px=
a/include/mach/addr-map.h
> index bbf9df37ad4b..d28fe291233a 100644
> --- a/arch/arm/mach-pxa/include/mach/addr-map.h
> +++ b/arch/arm/mach-pxa/include/mach/addr-map.h
> @@ -39,6 +39,11 @@
>  #define DMEMC_SIZE		0x00100000
> =20
>  /*
> + * Reserved space for low level debug virtual addresses within
> + * 0xf6200000..0xf6201000
> + */
> +
> +/*
>   * Internal Memory Controller (PXA27x and later)
>   */
>  #define IMEMC_PHYS		0x58000000

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-UXI+hxTCkfjayNNgMmmt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLL7kee/yOyVhhEJAQpnFQ/+OAL+dQ0kq46hydtXjY+AiGAYhgrrAXnR
umaJ9lWP4Q3tEqN5kbFml9I+lkchNHljo8tpICb08eDx3ouXR0Bo2+zWOrguoweO
I0ZNKqcux0p6V0JTYg9Wfl6nZqVhIB9n5x/nusp62iMR9rm/R95QM4dkye6G1PuB
BzWmx/13AIdx/8vJOXVKLHSG1QP/f4KB7ZZ4hx4gG1a4a07q1r1kxyZRYsN5l4n1
DCbkHTQIogouEkMXDljPUal2iwWWhFDRR1pC2A33AN7A3A0uOu9fyfwDFJkMFaAh
NemvgIogxNt+12OSpDwrxN5Yh6U6p6CPH2nRzs6qDYTsNNssIKx+lpUuB43A7/RI
b1t/S4KesbpAeNjILJrnCTV3PovN3NVb5Tndn+6NcQigyDhY8To1ay5kGFLPaiTk
cHDaR/CGSiQdqTZioCgSzDBHZE2NJfMthGtIR+MCfJr1MjcyuIZ75ABbNTjE7ju5
0s7apofjv0vWF9BbdVOmyo4Ch7tEc52VRKiZbCOhDJ9JNpnZZaCk1mEaFk+xwXhR
yHdyNhQEin3BMYTJstmJ+wL3yyHhtYV5gvAzI2VxmFdsbU+bdMicpJZdZXEDLdf5
lI5XcDm7zIyQg6fNAmQVVwDUQQ9Ntm2s28DfYoEgq3WR4L9L92cqh/H97FXrx8Kk
xkWYQ5bLJRo=
=HSfs
-----END PGP SIGNATURE-----

--=-UXI+hxTCkfjayNNgMmmt--
