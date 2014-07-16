Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbaGPIls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:41:48 -0400
Received: from imap.thunk.org ([74.207.234.97]:38134 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072AbaGPIlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:41:44 -0400
Date: Wed, 16 Jul 2014 04:33:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, Thomas Gleixner <tglx@linutronix.de>,
        price@mit.edu
Subject: Re: BUG_ON drivers/char/random.c:986
Message-ID: <20140716083308.GF1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
	Thomas Gleixner <tglx@linutronix.de>, price@mit.edu
References: <5370EBE9.6@oracle.com>
 <20140516153455.GV11096@twins.programming.kicks-ass.net>
 <53763775.3040602@linux.intel.com>
 <20140516162117.GY11096@twins.programming.kicks-ass.net>
 <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com>
 <20140517021840.GA5513@thunk.org>
 <20140715043613.GA18575@redhat.com>
 <1405456150.25863.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405456150.25863.16.camel@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:29:10PM +0200, Hannes Frederic Sowa wrote:
> 
> Looks like an overflow introduced by e33ba5fa7afce1a ("random: fix nasty
> entropy accounting bug"). Ted, what do you think about the following
> fix?

Ah, right.  We're only capping ibytes to be no more entropy in the
pool only in the r->limit case.

LGTM.  Can you send a patch with a description with a description and
a Signed-off-by?

						- Ted
