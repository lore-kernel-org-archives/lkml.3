Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab3C1Hiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:38:55 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50294 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3C1Hix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:38:53 -0400
Date: Thu, 28 Mar 2013 08:38:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4] nohz: Force boot CPU outside full dynticks range
Message-ID: <20130328073849.GA24433@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
 <1364398359-21990-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364398359-21990-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The timekeeping job must be able to run early on boot
> because there may be some pre-SMP (and thus pre-initcalls )
> components that rely on it. The IO-APIC is one such users
> as it tests the timer health by watching jiffies progression.

Btw., while I agree that a conservative mode is probably wise for bootup, 
that IO-APIC assumption could be fixed or even removed.

If the IO-APIC code wants to know whether an interrupt fired, it can take 
a look at the kstat_irqs numbers?

Also, could we restrict the boot CPU's mode only during the early bootup 
stage - i.e. until we are ready to execute user-space init?

Thaks,

	Ingo
