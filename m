Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3GJKfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:35:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3GJKfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:35:31 -0400
Date: Wed, 10 Jul 2013 12:34:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mtosatti@redhat.com
Cc: mingo@redhat.com, gleb@redhat.com, glommer@parallels.com,
        tglx@linutronix.de, jeremy@goop.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: sched: add notifier for cross-cpu migrations
Message-ID: <20130710103440.GO25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just stumbled over commit 582b336ec2 and had a massive WTF moment.

The Changelog -- empty!
The Implementation -- complete crap!

fail^2.

A git grep later I find its x86_64 paravirt only.. for this we add
unconditional crap to the scheduler?

At the _very_ least this should have been wrapped in a static_key and the
changelog should have given some clue as to the what and why of this code.

/me grumpy
