Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab3HUNpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:45:14 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:59583 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696Ab3HUNpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:45:12 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru B75CC7F483
Date: Wed, 21 Aug 2013 17:44:57 +0400
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: kmemleak in apei_res_add
Message-ID: <20130821134455.GC12595@sanechka.spb.ru>
References: <20130812024556.GB29956@sanechka.spb.ru>
 <CAHkRjk4y06puTL_Gq5RbpoV+kpEp+k32z5aq3HpEu9u3qsS_Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkRjk4y06puTL_Gq5RbpoV+kpEp+k32z5aq3HpEu9u3qsS_Aw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 21 10:38, Catalin Marinas wrote:
> On 12 August 2013 03:45, Alexandra N. Kossovsky
> <Alexandra.Kossovsky@oktetlabs.ru> wrote:
> > When running 3.10.3 with kmemleak enabled, I see following warnings from
> > kmemleak:
> >
> > unreferenced object 0xffff88024d2219a0 (size 32):
> >   comm "swapper/0", pid 1, jiffies 4294894532 (age 26865.180s)
> >   hex dump (first 32 bytes):
> >     58 de 0c 73 02 88 ff ff 58 de 0c 73 02 88 ff ff  X..s....X..s....
> >     18 50 fd 7d 00 00 00 00 3f 50 fd 7d 00 00 00 00  .P.}....?P.}....
> >   backtrace:
> >     [<ffffffff813ddf40>] kmemleak_alloc+0x21/0x3e
> >     [<ffffffff8111cb99>] kmemleak_alloc_recursive.constprop.58+0x16/0x18
> >     [<ffffffff8111efac>] kmem_cache_alloc_trace+0xe6/0x12f
> >     [<ffffffff81278f0e>] apei_res_add+0xb9/0xe8
> >     [<ffffffff81278faa>] collect_res_callback+0x6d/0x7c
> >     [<ffffffff812788ed>] apei_exec_for_each_entry+0x78/0x93
> >     [<ffffffff8127891d>] apei_exec_collect_resources+0x15/0x17
> >     [<ffffffff81b010e5>] erst_init+0x278/0x2a3
> >     [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
> >     [<ffffffff81ac9ee7>] kernel_init_freeable+0x13f/0x1cc
> >     [<ffffffff813db19f>] kernel_init+0x9/0xd6
> >     [<ffffffff813fe5bc>] ret_from_fork+0x7c/0xb0
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Are there any "APEI:" errors in the kernel log? It could be some
> freeing missing on an error path.

No.
dmesg |grep APEI
[    9.602274] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.


-- 
Alexandra N. Kossovsky
OKTET Labs (http://www.oktetlabs.ru/)
e-mail: sasha@oktetlabs.ru
