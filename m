Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134Ab3JPUwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:52:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37195 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761501Ab3JPUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:52:20 -0400
Date: Wed, 16 Oct 2013 22:52:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131016205207.GE10651@twins.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-2-git-send-email-treding@nvidia.com>
 <20131016200645.GD10651@twins.programming.kicks-ass.net>
 <20131016201410.GA26785@twins.programming.kicks-ass.net>
 <20131017073100.2cab1ffa@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017073100.2cab1ffa@notabene.brown>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Neil;

it looks like its one of your patches isn't it?

http://www.spinics.net/lists/raid/msg44100.html
http://www.spinics.net/lists/raid/msg44101.html

Given that I can't find them in a lkml archive means nobody's ever seen
those patches.

Anyway; has that 3/3 patch ever been ran with lockdep enabled? 

Stuff like:

+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		spin_lock_init(conf->hash_locks + i);

And:

+static void __lock_all_hash_locks(struct r5conf *conf)
+{
+	int i;
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		spin_lock(conf->hash_locks + i);
+}

Tends to complain real loud.

This leaves one to wonder... 
  'fancy' locking scheme:1, validation effort:0


