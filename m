Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3FXPKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:10:37 -0400
Received: from mail.us.es ([193.147.175.20]:50243 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3FXPKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:10:36 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.8/17406. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.8/7.5):. 
 Processed in 1.8104 secs); 24 Jun 2013 15:10:34 -0000
X-Envelope-From: pneira@us.es
Date: Mon, 24 Jun 2013 17:10:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: George Spelvin <linux@horizon.com>, bp@alien8.de, kaber@trash.net,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: v3.10-rc7 oops soon after boot
Message-ID: <20130624151031.GB3917@localhost>
References: <20130624094145.2576.qmail@science.horizon.com>
 <51C816C8.4080709@cn.fujitsu.com>
 <20130624113441.GA2583@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624113441.GA2583@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 01:34:41PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 24, 2013 at 05:52:08PM +0800, Gao feng wrote:
> > On 06/24/2013 05:41 PM, George Spelvin wrote:
> > >> Please try the patch below,
> > >> I think this bug is introduced by me :(
> > >>
> > >> Thanks!
> > > 
> > > Well, you changed it, but it still crashes.
> > > 
> > > It's now at del_timer+0x9/0x58, with the code being:
> > 
> > This one should work.
> > 
> > Thanks for your quickly reply.
> 
> I managed to crash it using a group != 1 (default) and enabling
> batching:
> 
> iptables -I INPUT -j ULOG --ulog-nlgroup 2 --ulog-qthresh 50
> 
> It seems ulog->nlgroup[i] is always left unset.
> 
> I have mangled your patch, find it attached.

> From 79da8ea854c06ca9320decbb2f9d2e8d25b2f7e5 Mon Sep 17 00:00:00 2001
> From: Gao feng <gaofeng@cn.fujitsu.com>
> Date: Mon, 24 Jun 2013 17:04:02 +0800
> Subject: [PATCH] netfilter: ipt_ULOG: fix incorrect setting of ulog timer
> 
> The parameter of setup_timer should be &ulog->nlgroup[i].
> the incorrect parameter will cause kernel panic in
> ulog_timer.
> 
> Bug introducted in commit 355430671ad93546b34b4e91bdf720f3a704efa4
> "netfilter: ipt_ULOG: add net namespace support for ipt_ULOG"
> 
> ebt_ULOG doesn't have this problem.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I have applied the patch that I sent you.
