Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364Ab3E2JTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:19:55 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38249 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965304Ab3E2JTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:19:53 -0400
Date: Wed, 29 May 2013 11:19:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, david.a.cohen@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] irq/x86/io_apic: Fix number of pre-allocated irqs
Message-ID: <20130529091950.GB25621@gmail.com>
References: <1367364015-12521-1-git-send-email-david.a.cohen@intel.com>
 <tip-8c956b1b935ec98decb470a6abff8c1f8b28e9f0@git.kernel.org>
 <alpine.LFD.2.02.1305291104550.2995@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305291104550.2995@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 28 May 2013, tip-bot for David Cohen wrote:
> 
> > Commit-ID:  8c956b1b935ec98decb470a6abff8c1f8b28e9f0
> > Gitweb:     http://git.kernel.org/tip/8c956b1b935ec98decb470a6abff8c1f8b28e9f0
> > Author:     David Cohen <david.a.cohen@intel.com>
> > AuthorDate: Tue, 30 Apr 2013 16:20:15 -0700
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Tue, 28 May 2013 12:01:29 +0200
> > 
> > irq/x86/io_apic: Fix number of pre-allocated irqs
> > 
> > arch_probe_nr_irqs() has a typo when returning number of
> > preallocated irqs. Instead of returning the calculated value, it
> > returns a constant number NR_IRQ_LEGACY.
> 
> That's not a typo. That's on purpose.
> 
> We don't want to allocate a gazillion of interrupt descriptors for
> nothing. The only ones which must be pre-allocated are the legacy
> ones.
> 
> > This patch makes sure the calculated value is returned intead.
> 
> And therefor defeats the whole purpose of sparse irqs.
> 
> I'll zap that commit.

Oops, I had a sneaking suspicion about this change but did not read the 
code far enough - thanks for correcting my brainfart!

Thanks,

	Ingo
