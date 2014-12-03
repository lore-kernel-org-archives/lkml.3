Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaLCULw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:11:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLCULu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:11:50 -0500
Date: Wed, 3 Dec 2014 15:11:12 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203201112.GB3118@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141203190045.GB32005@redhat.com>
 <1417636798.11261.1@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417636798.11261.1@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 02:59:58PM -0500, Chris Mason wrote:
 
 
 > > [  503.692038] Switched to clocksource hpet
 > > [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! 
 > > [trinity-c178:20182]
 > 
 > Neat.  We often see switching to hpet on boxes as they are diving into 
 > softlockup pain, but it's not usually before the softlockups.
 > 
 > Are you configured for CONFIG_NOHZ_FULL?
 

No. I have recollections that I did run with that early on in this, but
I think someone asked me to try without that a few weeks back, and it's
been off since. (made no difference)

 > I'd love to blame the only commit to kernel/smp.c between 3.16 and 3.17
 > 
 > commit 478850160636c4f0b2558451df0e42f8c5a10939
 > Author: Frederic Weisbecker <fweisbec@gmail.com>
 > Date:   Thu May 8 01:37:48 2014 +0200
 > 
 >     irq_work: Implement remote queueing
 > 
 > You've also mentioned a few times where messages stopped hitting the 
 > console?
 >
 > commit 5874af2003b1aaaa053128d655710140e3187226
 > Author: Jan Kara <jack@suse.cz>
 > Date:   Wed Aug 6 16:09:10 2014 -0700
 > 
 >     printk: enable interrupts before calling 
 > console_trylock_for_printk()

Hmm..

	Dave
