Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3EPJvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:51:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:12243 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3EPJvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,683,1363158000"; 
   d="scan'208";a="338532855"
Message-ID: <1368698060.15764.195.camel@sauron.fi.intel.com>
Subject: Re: BUG: spinlock lockup suspected on CPU#0, flush-ubifs_0_0/844
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@newflow.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        adrian.hunter@intel.com, lkml <linux-kernel@vger.kernel.org>
Date: Thu, 16 May 2013 12:54:20 +0300
In-Reply-To: <517A8A6F.2030104@newflow.co.uk>
References: <517A8A6F.2030104@newflow.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 15:08 +0100, Mark Jackson wrote:
> I've encountered a lockup on ubifs ... any ideas ?
> 
> # ifup eth1
> [ 3451.254040] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [ 3451.262627] pgd = cf468000
> [ 3451.265489] [00000000] *pgd=8f48c831, *pte=00000000, *ppte=00000000
> [ 3451.272146] Internal error: Oops: 80000007 [#2] ARM
> [ 3451.277312] CPU: 0    Tainted: G      D       (3.9.0-rc8-00020-g6e8f1be-dirty #210)
> [ 3451.285411] PC is at 0x0
> [ 3451.288105] LR is at pagevec_lru_move_fn+0x90/0xe4
> [ 3451.293172] pc : [<00000000>]    lr : [<c00a00b8>]    psr: 600000b3
> [ 3451.293172] sp : cf479df4  ip : 00000040  fp : 00000000
> [ 3451.305311] r10: c05d8ebc  r9 : c0d09e00  r8 : 0000030c
> [ 3451.310834] r7 : c05b72e8  r6 : 60000013  r5 : 00000002  r4 : c05d8ebc
> [ 3451.317736] r3 : 00000001  r2 : cf478000  r1 : c05d90f0  r0 : c0d09e00
> [ 3451.324639] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA Thumb  Segment user
> [ 3451.332460] Control: 10c5387d  Table: 8f468019  DAC: 00000015
> [ 3451.338535] Process sh (pid: 913, stack limit = 0xcf478238)
> [ 3451.344427] Stack: (0xcf479df4 to 0xcf47a000)

No idea, may be a memory corruption, for example. Is this reproducible?

-- 
Best Regards,
Artem Bityutskiy

