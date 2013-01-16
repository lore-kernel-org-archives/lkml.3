Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3APWEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:04:50 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56406 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab3APWEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:04:48 -0500
Date: Wed, 16 Jan 2013 23:04:47 +0100
From: Andreas Mohr <andi@lisas.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq_work changes for 3.9
Message-ID: <20130116220447.GA20148@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358345841-29136-1-git-send-email-fweisbec@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> These three patches are general fixes for irq work. The two first
> patches fix tight races on global irq work claiming that prevent the irq work
> subsystem from dropping a work enqueuing attempt because it thinks it's
> already pending while it may be already executing or executed.

Would that one happen to be one that would fix my system dropping
dead on sound output (looping the existing buffer ad infinitum)
every couple idle minutes when using my sound card's
PulseAudio IRQ-less playback patch (to-be-submitted),
and which seems to have started (or got quite a bit worse
so as to let me notice?) once I added my
"quirks: enable APIC De-Assert Message bit for VIA 8235, too."
(to-be-submitted) commit?
(which reduces IRQs from duplicate to single - thereby probably
reducing the opportunities for the system to notice that work is pending)

Of course a lone kick to the mouse always fixes it...

(-rc2 here)

Hell yeah that does sound like a potential candidate to me.

Andreas Mohr
