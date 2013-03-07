Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3CGTR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:17:28 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47614 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab3CGTR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:17:27 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [procfs] BUG: sleeping function called from invalid context at mm/slub.c:925
In-Reply-To: Your message of "Thu, 07 Mar 2013 22:12:24 +0800."
             <20130307141224.GA6506@localhost>
From: Valdis.Kletnieks@vt.edu
References: <20130307141224.GA6506@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1362683738_1857P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Mar 2013 14:15:38 -0500
Message-ID: <3041.1362683738@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.5138E75B.0199,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1362683738_1857P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Mar 2013 22:12:24 +0800, Fengguang Wu said:

> I got the below dmesg and the first bad commit is
>
> commit a21813be23329e2788164eab532e79cb0e513cfc
> Author: Nathan Zimmer <nzimmer@sgi.com>
> Date:   Sat Mar 2 15:25:37 2013 +1100
>
>     procfs: improve scaling in proc

> [   78.994163] atkbd: probe of serio1 rejects match -19
> [   79.196148] Freeing unused kernel memory: 664k freed
> [   80.786460] BUG: sleeping function called from invalid context at /c/kernel-tests/src/tip/mm/slub.c:925

I'm seeing a very similar issue on SLAB in next-20130306.
x86_64 on a 2-core Dell Latitude laptop.  Haven't bisected yet.

[    9.295661]   #0: HDA Intel at 0xf6fdc000 irq 50
[    9.324345] Freeing unused kernel memory: 968k freed
[    9.350431] Write protecting the kernel read-only data: 10240k
[    9.377094] Freeing unused kernel memory: 20k freed
[    9.404963] Freeing unused kernel memory: 412k freed
[    9.439653] BUG: sleeping function called from invalid context at mm/slab.c:3056
[    9.505448] in_atomic(): 0, irqs_disabled(): 0, pid: 1, name: systemd
[    9.531235] 2 locks held by systemd/1:
[    9.557046]  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8115dc2a>] rcu_read_lock+0x0/0x6c
[    9.583626]  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8115dc2a>] rcu_read_lock+0x0/0x6c
[    9.609793] Pid: 1, comm: systemd Not tainted 3.9.0-rc1-next-20130306 #63
[    9.636291] Call Trace:
[    9.662218]  [<ffffffff81056435>] __might_sleep+0x19e/0x1a5
[    9.687970]  [<ffffffff810ff5f5>] cache_alloc_debugcheck_before.isra.40+0x1d/0x1f
[    9.713908]  [<ffffffff81100576>] kmem_cache_alloc_trace+0x35/0xec
[    9.740070]  [<ffffffff81164d8f>] ? cmdline_proc_open+0x17/0x17
[    9.765894]  [<ffffffff81125cb3>] ? single_open+0x8f/0x8f
[    9.791251]  [<ffffffff81125c50>] single_open+0x2c/0x8f
[    9.816509]  [<ffffffff81164d8d>] cmdline_proc_open+0x15/0x17
[    9.841728]  [<ffffffff8115ded7>] proc_reg_open+0xcb/0x143
[    9.866926]  [<ffffffff81164d78>] ? proc_tty_unregister_driver+0x2d/0x2d
[    9.891936]  [<ffffffff8115de0c>] ? proc_reg_release+0x157/0x157
[    9.917044]  [<ffffffff81106a0f>] do_dentry_open+0x1d2/0x2ff
[    9.941631]  [<ffffffff81106b9e>] finish_open+0x62/0x74
[    9.966347]  [<ffffffff81114cc0>] do_last+0x9aa/0xb79
[    9.990594]  [<ffffffff81114f94>] path_openat+0x105/0x45e
[   10.014748]  [<ffffffff810ffa05>] ? ac_get_obj.constprop.59+0x38/0x1b6
[   10.038753]  [<ffffffff811160b0>] do_filp_open+0x37/0xc8
[   10.062789]  [<ffffffff815ef027>] ? _raw_spin_unlock+0x58/0x64
[   10.086744]  [<ffffffff8112173a>] ? __alloc_fd+0x175/0x187
[   10.110608]  [<ffffffff81107833>] do_sys_open+0x81/0x129
[   10.134379]  [<ffffffff811078f4>] SyS_open+0x19/0x1b
[   10.158447]  [<ffffffff815f5592>] system_call_fastpath+0x16/0x1b
[   10.182213]




--==_Exmh_1362683738_1857P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUTjnWgdmEQWDXROgAQLGqA/+I+2u7Tr5Yxi+Pj+rqe22wXNtw/Y0Chjf
MWeS7k2irlTQBj3VnoqcuuBjkGTCaNRd3vOw4CPR7d2rDNMrnLtkS+ir/h3WNo+v
ovtvkrDDmchUMAZldRoDuOzKRwM8knSd1CDifPMC9R/z3uXuDF6wBGQAHV4Ln5sy
/AQ5mXpZv6jKfVkY4mLcV8urC1SYPzVdyHNike7fiYyrA3LmnT30qv265kOblM9j
fHieLuTtUe9Q4q62AEbChdLaVMAztoWiJzbnYuHyp6iQe6sydPZ5dxPDVNLDrTVP
5hIlknglVfG7og4TZ/mwgFdk9B7pcY4ZVWOOb5RYHGMvh+MtwEmjxaFw227uOfEV
JkdDMOyIOlWdsCA9vSd5Z5wJuEUx3pQIVY0heoF/gHJ60o143jc7UrPpbMabfBXb
LaCzOZPdGkJ1rpqtg4UOEHS/1MC5N8ifc+dCzlhS+XpDNJ0vf/mTKoHlEvwzMoRk
nnDvowSPgsJq2tEWu16szvfNWBFewi8VKaLNYPO1fgt4r7ogiI2wrHyb3Jf6xRWg
3M1pUngcCfgqVIQFZJbKmc/gpS/HAIdWvkkZddLNN8AIrQZ0NYRd1kB/eTpUEZre
LJSnfyAkmZKWAA0py/l858qirS56wloc3DZHeAxlTTasAjj2VjHmOdVuUEqZwFe+
PUyfRDe2owQ=
=1sYe
-----END PGP SIGNATURE-----

--==_Exmh_1362683738_1857P--

