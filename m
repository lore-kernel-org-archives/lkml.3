Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab3B0Nvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:51:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55369 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759904Ab3B0Nvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:51:42 -0500
Date: Thu, 28 Feb 2013 00:51:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Feb 23 [ perf: NULL pointer dereference
 perf_init_event() ]
Message-Id: <20130228005122.329c5ed6fd79f686ee41364e@canb.auug.org.au>
In-Reply-To: <CA+icZUV+et8R7+Z8QBOcTLYaCqy=NpDgqcaHYmP5tfjqPybgpw@mail.gmail.com>
References: <CA+icZUV=e_5qvEs-KyphN7=skmr1-kSSqbiVT5eFsfXbUaT9qQ@mail.gmail.com>
	<CA+icZUUZ8O9Phgv4yuL657DBVQpLThv4p7KHLtYj5oJ6QqDgDg@mail.gmail.com>
	<CA+icZUV+et8R7+Z8QBOcTLYaCqy=NpDgqcaHYmP5tfjqPybgpw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Feb_2013_00_51_22_+1100_a6j4k2oOOe8yOCmk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Feb_2013_00_51_22_+1100_a6j4k2oOOe8yOCmk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Cc'ing Andrew just in case he was going to send the offending patch on
to Linus soon ...]

On Wed, 27 Feb 2013 14:23:51 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>
> On Tue, Feb 26, 2013 at 10:39 AM, Sedat Dilek <sedat.dilek@gmail.com> wro=
te:
> > On Mon, Feb 25, 2013 at 2:44 PM, Sedat Dilek <sedat.dilek@gmail.com> wr=
ote:
> >>
> >> With today's Linux-Next I see multiple call-traces pointing to perf
> >> issues (excerpt, for full dmesg see attachments):
> >>
> >> [    0.093651] Call Trace:
> >> [    0.093656]  [<ffffffff8112a808>] perf_event_alloc+0x358/0x490
> >> [    0.093661]  [<ffffffff810ec230>] ? touch_nmi_watchdog+0x80/0x80
> >> [    0.093666]  [<ffffffff8112ac6e>] perf_event_create_kernel_counter+=
0x2e/0xe0
> >> [    0.093670]  [<ffffffff810ec3ed>] watchdog_enable+0xfd/0x1e0
> >> [    0.093676]  [<ffffffff81087a3c>] smpboot_thread_fn+0x9c/0x170
> >> [    0.093681]  [<ffffffff810879a0>] ? lg_global_lock+0x70/0x70
> >> [    0.093685]  [<ffffffff8107fb80>] kthread+0xc0/0xd0
> >> [    0.093689]  [<ffffffff8107fac0>] ? flush_kthread_worker+0xb0/0xb0
> >> [    0.093694]  [<ffffffff816cc56c>] ret_from_fork+0x7c/0xb0
> >> [    0.093698]  [<ffffffff8107fac0>] ? flush_kthread_worker+0xb0/0xb0
> >> [    0.093700] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18
> >> e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 a2 c9 e2 00
> >> 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ce ab 22 00 48 89 c3
> >> 48 85
> >> [    0.093736] RIP  [<ffffffff8112a3e2>] perf_init_event+0x32/0x100
> >> [    0.093740]  RSP <ffff880119b93d58>
> >> [    0.093742] CR2: 0000000000000000
> >> [    0.093746] ---[ end trace 941ac4690a5bae9e ]---
> >> [    0.104659] Disabled fast string operations
> >> [    0.106781] Brought up 4 CPUs
> >> [    0.106785] BUG: unable to handle kernel NULL pointer dereference
> >> at           (null)
> >> [    0.106790] IP: [<ffffffff8112a3e2>] perf_init_event+0x32/0x100
> >> [    0.106791] PGD 0
> >> [    0.106794] Oops: 0000 [#4] SMP
> >> [    0.106795] Modules linked in:
> >> [    0.106798] CPU 3
> >> [    0.106798] Pid: 22, comm: watchdog/3 Tainted: G      D
> >> 3.8.0-next20130225-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD.
> >> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> >> [    0.106801] RIP: 0010:[<ffffffff8112a3e2>]  [<ffffffff8112a3e2>]
> >> perf_init_event+0x32/0x100
> >> ...
> >>
> >> Regards,
> >> - Sedat -
> >
> > I see the same call-traces with today's Linux-Next (next-20130226)!
> > Any hints/help?
> >
> > - Sedat -
>=20
> [ CC Tejun and Borislav ]
>=20
> This turned out to be a idr issue [1]. Thanks Borislav for his help.
>=20
> Reverting "idr: implement lookup hint" commit [2] makes the call-traces g=
o away.
>=20
> - Sedat -
>=20
> [1] http://marc.info/?l=3Dlinux-kernel&m=3D136197056415722&w=3D2
> [2] http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dc=
ommit;h=3D29cf29e1fbb875019713eb55cf27ec35f1e5fa5e


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Feb_2013_00_51_22_+1100_a6j4k2oOOe8yOCmk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRLg9aAAoJEECxmPOUX5FENj8P/02BlvxxCocrxWiQVCV0aOs+
XrTSgx3JADwMqU8FQtpQhZLevUFQTcRLZfrPkU5QKUdAPyxlLpu6dbnoMWKRMLAV
5+ENTGLX4mew53rgQUEsr0wyouXuatib7i+51eKD+pCzZ+r/Tc2/XlLKAD9kGi9H
eoFYD0yDILMWAPGe8AsFb3RfmKuK1mQH4osTs6689C7hdZuxmCSviCRfTsPv97YH
3cQaXMpaK+gfmyritygcucmC2urFYFzYGL5nImOkZpMpqgGsOEeSGQh/zjAQoxo5
LWQXEYOupSsPS4ZqmeD2b2u7B9SlHraGe2d9R65mtAOOhJ84KRpHThm+wLgnjIGx
5y7yL9iTW0LLTo5hMuvyrtR5vIgzvkYBg3RH0TS/7+q8d29rMJrarXtuJGkj3pLu
vl576H/2RfwfleGEouvq9IllqdiZffb0Dk5fayWlqR8xBPSXXTsqNjw4cgGlecFJ
kDvxd0C7wvz17+wzbaBe+tfbwObBSgXI4YjN/NUJIPCAzDn4KifpjdjGL8o1foaG
V8LtloXZzt067X0IvwxpSJboltJAW41jhDYNPK4vM235hIicb//ae2nL1cFuf4dZ
t/vtwk9STatIQ2mJYpYoK+NXiuyQFDlyA4Za1cDoMEIqjD67mcq7uorTmVNqPZV2
LOayGVZOxprUxnRyIRMO
=mk6B
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Feb_2013_00_51_22_+1100_a6j4k2oOOe8yOCmk--
