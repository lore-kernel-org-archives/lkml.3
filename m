Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaJ1P6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:58:04 -0400
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:35165 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbaJ1P6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:58:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3873:3874:4321:5007:6261:9038:10004:10400:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12555:12663:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fly63_7fd903741cf63
X-Filterd-Recvd-Size: 2893
Message-ID: <1414511877.6643.12.camel@perches.com>
Subject: Re: [PATCH 7/7] docg3: Fix miuse of seq_printf return value
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Oct 2014 08:57:57 -0700
In-Reply-To: <20141028111301.22481f2a@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
	 <20141022082916.GD16128@brian-ubuntu>
	 <20141028111301.22481f2a@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 11:13 -0400, Steven Rostedt wrote:
> I'm going to be working on changes to remove the return value of
> seq_printf() and friends.

I'm sure you know all of this, but for anyone else:

This doesn't need to be done in a single pass.

The seq_<foo> functions themselves can wait until
all the uses are converted.

Here are files that likely need to change:

$ git grep --name-only -E "[\(=]\s*seq_(vprintf|printf|puts|putc|escape|write|put_decimal_\w+)\s*\("
arch/arm/plat-pxa/dma.c
arch/cris/arch-v10/kernel/fasttimer.c
arch/cris/arch-v32/kernel/fasttimer.c
arch/microblaze/kernel/cpu/mb.c
arch/x86/kernel/cpu/mtrr/if.c
drivers/base/power/wakeup.c
drivers/mfd/ab8500-debugfs.c
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
drivers/parisc/ccio-dma.c
drivers/parisc/sba_iommu.c
drivers/regulator/dbx500-prcmu.c
drivers/staging/lustre/lustre/fid/lproc_fid.c
drivers/staging/lustre/lustre/llite/lproc_llite.c
drivers/staging/lustre/lustre/mdc/lproc_mdc.c
drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
drivers/staging/lustre/lustre/osc/lproc_osc.c
drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
drivers/usb/gadget/udc/goku_udc.c
drivers/usb/gadget/udc/pxa27x_udc.c
drivers/watchdog/bcm_kona_wdt.c
fs/debugfs/file.c
fs/dlm/debug_fs.c
fs/eventfd.c
fs/eventpoll.c
fs/notify/fdinfo.c
fs/proc/base.c
fs/seq_file.c
kernel/trace/trace_seq.c
net/batman-adv/gateway_client.c
net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
net/netfilter/nf_conntrack_standalone.c
net/netfilter/nf_log.c
net/netfilter/xt_hashlimit.c


