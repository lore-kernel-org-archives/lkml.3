Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3CEPVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:21:10 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:39016
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755799Ab3CEPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:21:08 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 5 Mar 2013 23:20:44 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: v3.9-rc1: [BUG: swapper/1 still has locks held!]
Message-ID: <20130305152041.GA23742@S2101-09.ap.freescale.net>
References: <20130304025206.GB30431@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130304025206.GB30431@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:52:10AM +0800, Shawn Guo wrote:
> I'm running v3.9-rc1 kernel on an ARM platform (i.MX28) with
> arch/arm/mxs_defconfig and getting the following BUG warning.
> 
git bisect points me to the commit 6aa9707 (lockdep: check that no locks
held at freeze time).

Shawn

> [    5.681034] =====================================
> [    5.685885] [ BUG: swapper/1 still has locks held! ]
> [    5.690885] 3.9.0-rc1 #774 Not tainted
> [    5.694734] -------------------------------------
> [    5.699475] 2 locks held by swapper/1:
> [    5.703323]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<c00d20e0>] prepare_bprm_creds+0x28/0x64
> [    5.712326]  #1:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c00d5350>] lookup_slow+0x2c/0xa0
> [    5.720966]
> [    5.720966] stack backtrace:
> [    5.725528] [<c0013c78>] (unwind_backtrace+0x0/0xf0) from [<c0426f94>] (rpc_wait_bit_killable+0x94/0xb4)
> [    5.735184] [<c0426f94>] (rpc_wait_bit_killable+0x94/0xb4) from [<c044684c>] (__wait_on_bit+0x74/0xb8)
> [    5.744645] [<c044684c>] (__wait_on_bit+0x74/0xb8) from [<c04468f4>] (out_of_line_wait_on_bit+0x64/0x70)
> [    5.754278] [<c04468f4>] (out_of_line_wait_on_bit+0x64/0x70) from [<c0427e38>] (__rpc_execute+0xf4/0x370)
> [    5.763991] [<c0427e38>] (__rpc_execute+0xf4/0x370) from [<c042124c>] (rpc_run_task+0xa4/0xb0)
> [    5.772660] [<c042124c>] (rpc_run_task+0xa4/0xb0) from [<c0421350>] (rpc_call_sync+0x40/0xac)
> [    5.781335] [<c0421350>] (rpc_call_sync+0x40/0xac) from [<c01c2e08>] (nfs3_rpc_wrapper.constprop.6+0x58/0xdc)
> [    5.791406] [<c01c2e08>] (nfs3_rpc_wrapper.constprop.6+0x58/0xdc) from [<c01c2fbc>] (nfs3_proc_lookup+0x88/0xf4)
> [    5.801751] [<c01c2fbc>] (nfs3_proc_lookup+0x88/0xf4) from [<c01b282c>] (nfs_lookup+0xe8/0x18c)
> [    5.810659] [<c01b282c>] (nfs_lookup+0xe8/0x18c) from [<c00d49f8>] (lookup_real+0x20/0x50)
> [    5.819097] [<c00d49f8>] (lookup_real+0x20/0x50) from [<c00d5314>] (__lookup_hash+0x34/0x44)
> [    5.827696] [<c00d5314>] (__lookup_hash+0x34/0x44) from [<c00d5360>] (lookup_slow+0x3c/0xa0)
> [    5.836297] [<c00d5360>] (lookup_slow+0x3c/0xa0) from [<c00d61bc>] (link_path_walk+0x2a4/0x848)
> [    5.845144] [<c00d61bc>] (link_path_walk+0x2a4/0x848) from [<c00d9204>] (path_openat+0x278/0x444)
> [    5.854176] [<c00d9204>] (path_openat+0x278/0x444) from [<c00d96cc>] (do_filp_open+0x2c/0x80)
> [    5.862755] [<c00d96cc>] (do_filp_open+0x2c/0x80) from [<c00d12fc>] (open_exec+0x30/0x10c)
> [    5.871166] [<c00d12fc>] (open_exec+0x30/0x10c) from [<c00d232c>] (do_execve+0x1b8/0x4c4)
> [    5.879500] [<c00d232c>] (do_execve+0x1b8/0x4c4) from [<c0440b54>] (kernel_init+0x80/0xe4)
> [    5.887963] [<c0440b54>] (kernel_init+0x80/0xe4) from [<c000e9c8>] (ret_from_fork+0x14/0x2c)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

