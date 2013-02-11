Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab3BKARY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:17:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43621 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3BKARX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:17:23 -0500
Date: Mon, 11 Feb 2013 11:17:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at lib/debugobjects.c:261 debug_print_object()
Message-Id: <20130211111714.5e6fa4c8dc9c0d99cb1c1de1@canb.auug.org.au>
In-Reply-To: <20130208055605.GA7646@localhost>
References: <20130208055605.GA7646@localhost>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_11_17_14_+1100_5mc_=AA4+A3rw5wH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_11_17_14_+1100_5mc_=AA4+A3rw5wH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fengguang,

On Fri, 8 Feb 2013 13:56:05 +0800 Fengguang Wu <fengguang.wu@intel.com> wro=
te:
>
> I got the below oops and the first bad commit is
>=20
> commit 457583af4aef89d5252769ea290a2acc89e2361f
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon Feb 4 18:12:17 2013 +1100
>=20
>     memory-hotplug: common APIs to support page tables hot-remove fix fix
>    =20
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> I see no direct relationship between the change and oops message,
> however I tried two bisects and they both converge to the above
> commit.

Thanks for the report.

Did reverting just that commit fix the problem?  Is it still a problem in
next-20130208?

> [   34.746615] cryptomgr_test (42) used greatest stack depth: 6776 bytes =
left
> [   34.802868] ------------[ cut here ]------------
> [   34.803941] WARNING: at /c/kernel-tests/src/stable/lib/debugobjects.c:=
261 debug_print_object+0x7c/0x8d()
> [   34.804548] Hardware name: Bochs
> [   34.804548] ODEBUG: init active (active state 0) object type: percpu_c=
ounter hint:           (null)
> [   34.804548] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc6-09234-g45758=
3a #40
> [   34.804548] Call Trace:
> [   34.804548]  [<ffffffff8135da31>] ? debug_print_object+0x7c/0x8d
> [   34.804548]  [<ffffffff81059ee7>] warn_slowpath_common+0x79/0x94
> [   34.804548]  [<ffffffff81059f5d>] warn_slowpath_fmt+0x41/0x43
> [   34.804548]  [<ffffffff8135da31>] debug_print_object+0x7c/0x8d
> [   34.804548]  [<ffffffff8135dbe6>] ? __debug_object_init+0x3d/0x333
> [   34.804548]  [<ffffffff8135de91>] __debug_object_init+0x2e8/0x333
> [   34.804548]  [<ffffffff8135def0>] debug_object_init+0x14/0x16
> [   34.804548]  [<ffffffff813665b4>] __percpu_counter_init+0x6a/0xc8
> [   34.804548]  [<ffffffff810ceca3>] bdi_init+0x139/0x1d1
> [   34.804548]  [<ffffffff8284b327>] swap_setup+0x38/0x84
> [   34.804548]  [<ffffffff8284b385>] kswapd_init+0x12/0x77
> [   34.804548]  [<ffffffff8284b373>] ? swap_setup+0x84/0x84
> [   34.804548]  [<ffffffff82830e32>] do_one_initcall+0x7a/0x134
> [   34.804548]  [<ffffffff82830ff7>] kernel_init_freeable+0x10b/0x19a
> [   34.804548]  [<ffffffff82830689>] ? loglevel+0x31/0x31
> [   34.804548]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
> [   34.804548]  [<ffffffff81d42358>] kernel_init+0x9/0xd6
> [   34.804548]  [<ffffffff81d6b37c>] ret_from_fork+0x7c/0xb0
> [   34.804548]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
> [   34.804548] ---[ end trace 4b830e8d096c7c64 ]---
>=20
> git bisect start 457583af4aef89d5252769ea290a2acc89e2361f v3.7 --
> git bisect good b4c582a92f41417154131083127e24b66cc4b31b  #    10  2013-0=
2-08 11:31:44  serial: xilinx_uartps: get clock rate info from dts
> git bisect good 24d32e96c394bb84ca30dc41f8995efb3efa0b2e  #    10  2013-0=
2-08 11:41:36  Merge remote-tracking branch 'sound/for-next'
> git bisect good 86159e4b9bc1270344a890d368ab08d91a373c0b  #    10  2013-0=
2-08 11:50:32  Merge remote-tracking branch 'workqueues/for-next'
> git bisect good 32165b5ad1f88636cf5b7768cbf33cea74989211  #    10  2013-0=
2-08 11:59:39  Merge remote-tracking branch 'char-misc/char-misc-next'
> git bisect good edbbe0c1f464400706358f91d0b9a308e56cf50f  #    10  2013-0=
2-08 12:11:42  Merge remote-tracking branch 'samsung/for-next'
> git bisect good c5ec1c273c49037e833f096c4f591abae8c41c01  #    10  2013-0=
2-08 12:20:33  compat: return -EFAULT on error in waitid()
> git bisect good e4fde7764bf589399a6060596cca195f3fce15ff  #    10  2013-0=
2-08 12:27:14  get_maintainer.pl: find maintainers for removed files
> git bisect good 6710fc9562f4016222677534277ea442ff028ea1  #    10  2013-0=
2-08 12:33:37  hfsplus: add support of manipulation by attributes file
> git bisect good 960468a8cda8ab71a846b668a03e85c08f3543c0  #    10  2013-0=
2-08 12:37:42  wait: add wait_event_hrtimeout()
> git bisect good 29ce58899628f7c1de594b4c51a57129b9d28dae  #    10  2013-0=
2-08 12:41:41  aio-dont-include-aioh-in-schedh-fix-fix
> git bisect good bf5b05d942033ed019a3daef9651ccb172c50a2a  #    10  2013-0=
2-08 12:46:53  block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-f=
ix-fix
> git bisect good 04e0961ab478b63f81d6976e50b5642fcfaf80c9  #    10  2013-0=
2-08 12:54:30  aio: fix aio_read_events_ring() types
> git bisect good ec32b1df9515509c7ced856ea2f687d0ae51fe27  #    10  2013-0=
2-08 12:59:23  kfifo: fix kfifo_alloc() and kfifo_init()
> git bisect good 0e4ef6ad789dc7fedeaf347d013521bffe685480  #    10  2013-0=
2-08 13:03:06  swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
> git bisect good 0e4ef6ad789dc7fedeaf347d013521bffe685480  #    30  2013-0=
2-08 13:15:16  swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
> git bisect  bad 99ae5387e08311e47931836be5136d9df9e94cb2  #     0  2013-0=
2-08 13:18:32  Add linux-next specific files for 20130205

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Feb_2013_11_17_14_+1100_5mc_=AA4+A3rw5wH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGDiKAAoJEECxmPOUX5FEjCYQAJTmu+EhFXY++y1s/wAZ+xCz
diKeirIip7jGaBPPKgDlPHV/OHmpDF9jL8Okve7uun0Q6Ad0xzxBiOB9cw9b9myF
hD4esQafxEuBlp8AAaNQu+X1CSgicPb+G6vQXW/ZVVlIPmyIEK3DXgQxMfW4zkxs
oD0tDr2SP/OEhva0p6CFeCwvokZNOZLw/pW4PRXm+Ch38v62wVmEAr+pds3hmAfj
NEiNcWFIGM9KwKrHLVt7HDk67fgoewThSxNCHnvQbNa2yCPwysc4ADk/4nHagCm+
OV3Gr1cF97x4noL2LjO+6RbRuAOcKg4NDCeduwaueilDMYNvQ0D9RW4ugLOEYrWT
RVuzoAVCE2V+3oB0LuTd8RYJ2PCBuEzcDX4I18IYNwUrmOpoaZrJSRn7SO5HtF8e
UOsXmbPUqNz+m8Fe5MF388TLGgJhE5Ql33DqvyvjBz1kV8F5ucsEIPfRcnaTAd0I
T0Ko1NqOI5GvKCv+HF8rvkF+HduUUq+A04KwoCW3BwM4dPsROnGQFNMgaRLA+KT/
vurIVU1X+z/vhQWdTYNofEL1QvbmGFhiIJWqQFbtZGebaoGcHhdoGxEszm67mvr4
Zudm8b0tZGHXt06YNR6qqL0TpCLwXAzxJ7fMQJQZlU1H+kfbBNaoD6JcLFvk1uDE
o3LXmxxLxvSa8JitScRS
=q2lm
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_11_17_14_+1100_5mc_=AA4+A3rw5wH--
