Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaFEHzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:55:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFEHzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:55:11 -0400
Date: Thu, 5 Jun 2014 09:55:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Liu ShuoX <shuox.liu@intel.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Zhang Yanmin <yanmin.zhang@intel.com>,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] perf: fix kernel panic when parsing user space CS saved
 in pt_regs
Message-ID: <20140605075507.GA6758@twins.programming.kicks-ass.net>
References: <20140605023610.GA12905@lskakaxi-intel>
 <20140605071919.GD3213@twins.programming.kicks-ass.net>
 <20140605073321.GA14869@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20140605073321.GA14869@lskakaxi-intel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 03:33:21PM +0800, Liu ShuoX wrote:
> On Thu  5.Jun'14 at  9:19:19 +0200, Peter Zijlstra wrote:
> >On Thu, Jun 05, 2014 at 10:36:10AM +0800, Liu ShuoX wrote:
> >>From: Zhang Yanmin <yanmin.zhang@intel.com>
> >>
> >>We hit a kernel panic when running perf to collect some performance data.
> >>kenel is x86_64 and user space apps are 32bit.
> >>
> >>[   71.965351, 1] [       Binder_2] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> >>[   71.965360, 1] [       Binder_2] IP: [<ffffffff82012091>] get_segment_base+0x71/0xc0
> >>[   71.965367, 1] [       Binder_2] PGD 6c65f067 PUD 0
> >>[   71.965375, 1] [       Binder_2] Oops: 0000 [#1] PREEMPT SMP
> >>[   71.965413, 1] [       Binder_2] Modules linked in: ddrgx snd_merr_dpcm_wm8958 snd_intel_sst snd_soc_sst_platform snd_soc_wm8994 snd_soc_wm_hubs lm3559 imx1x5 atomisp_css2401a0_v21 libmsrlisthelper rmi4 bcm_bt_lpm videobuf_vmalloc videobuf_core fps_throttle hdmi_audio pn544(O) tngdisp bcm4335(O) cfg80211
> >>[   71.965420, 1] [       Binder_2] CPU: 1 PID: 304 Comm: Binder_2 Tainted: G        W  O 3.10.20-263902-g184bfbc-dirty #14
> >>[   71.965426, 1] [       Binder_2] task: ffff8800764dc300 ti: ffff88006c6e8000 task.ti: ffff88006c6e8000
> >>[   71.965439, 1] [       Binder_2] RIP: 0010:[<ffffffff82012091>]  [<ffffff?f82012091>] get_segment_base+0x71/0xc0
> >                                                                             ^
> >>[   71.965<44, 1] [       Binder_2] RSP: 0018:ffff^X8007ea87b98  EFLAGS: 00010092
> >           ^                                       ^
> >>[   71.965447, 1] [      !Binder_2] RAX: 0000000000000024 RBX: 0000000000000000 RCX: 0000000000000000
> >                          ^
> >>[   71.965450, 1] [       Binder_2] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
> >>[   71.965454, 1] [       Binder_2] RBP: ffff88007ea87ba8 R08: ffffffff83143b3c R09: ffffffff831848a8
> >>[   71.965458, 1] [       Binder_2] R10: 0000000000000000 R11: 00000000001bf2d8 R12: 0000000000000000
> >>[   71.965462, 1] [       Binder_2] R13: ffff88006c6e9fd8 R14: ffff88006c6e9f58 R15: ffff8800764dc300
> >>[   71.965468, 1_ [       Binder_2] FS:  0000000000000000(0000) GS:ffff88007ea80000(006b) knlGS:00000000f704add0
> >                 ^
> >
> >Are you suffering some serious corruption?
> The log captured by pstore after rebooting, so there are some
> corruption. Please ignore those.

Why does pstore cause corruption? I thought that stuff was supposed to
be 'good' ?

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkCJbAAoJEHZH4aRLwOS6MG8QAIWV6mo6By3V7yYjKDii7vCZ
y/34qt7X/2+CvAMDUSkFri98h66RaYMSLZMjXBJq9M+mE06M9rquNgCgtnDns4/W
BS3Z83oLy8Sz01qIKUwLzdkx5EOmw9+ka35OdgmnnmwmslFuGT3BSH5K7Jeuf66F
PMeILT6ir+0ZJj/G+lB5irv4rM7PTZy95cODOtm0m6U1xlu/zLeUlLh+VByZb74j
l84HACHogR/zw+sHl0eMHS66PeKn2fALfZ79fYNoFD/5f4xvOmyugnvx2a7b52Hb
dxyYIXcpiP7ic4Rn2uhrIQbNypJW7Fr5dDSj4gZCv5PSCQB/VExjSOnduYuS1+Xi
/gDJmi68YCza9dQ3Rli2+bYxwj3WvXke2cDKTc1iNOb78JgjKR63SqzTVC+VNMmJ
kYGlDA9xr3uXfoss9TrSGgttv+TPrx2aoTixu8c9oIt4sKi4HsJVgCOODR9TN7yD
LmNdorV/ffTbK3sjU8yEXB3/nCuDLpAe1FoSMoWr8KRcNGut3AYpfBDetSn8VeBu
PfiGJuOQLVvE9tjkRZZropCSM3P8XlZqU3VDeMorxk/eCahSDPWnjfOV++VtodMM
BHw9XLv4dvcDFf7fiYXFDlpDNrNeB8GC4TL0TFNoup9YDc9YNnRQQyjdFvBiGFkj
CmgmDzfBlBmL/Uzwg7SV
=D1wJ
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
