Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaAXTqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:46:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:59219 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaAXTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:46:47 -0500
Date: Fri, 24 Jan 2014 20:46:42 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
Message-ID: <20140124194642.GA29981@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
 <1387681647.5412.25.camel@marge.simpson.net>
 <1387702631.5412.101.camel@marge.simpson.net>
 <1387773533.5369.16.camel@marge.simpson.net>
 <1387775559.5369.20.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1387775559.5369.20.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2013-12-23 06:12:39 [+0100]:

>P.S.
>
>virgin -rt7 doing tbench 64 + make -j64
>
>[   97.907960] perf samples too long (3138 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>[  103.047921] perf samples too long (5544 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
>[  181.561271] perf samples too long (10318 > 10000), lowering kernel.perf_event_max_sample_rate to 13000
>[  184.243750] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 1.084 msecs
>[  248.914422] perf samples too long (19719 > 19230), lowering kernel.perf_event_max_sample_rate to 7000
>[  382.116674] NOHZ: local_softirq_pending 10
This is block

>[  405.201593] perf samples too long (36824 > 35714), lowering kernel.perf_event_max_sample_rate to 4000
>[  444.704185] NOHZ: local_softirq_pending 08
>[  444.704208] NOHZ: local_softirq_pending 08
>[  444.704579] NOHZ: local_softirq_pending 08
>[  444.704678] NOHZ: local_softirq_pending 08
>[  444.705100] NOHZ: local_softirq_pending 08
>[  444.705980] NOHZ: local_softirq_pending 08
>[  444.705994] NOHZ: local_softirq_pending 08
>[  444.708315] NOHZ: local_softirq_pending 08
>[  444.710348] NOHZ: local_softirq_pending 08

and this is RX. Is your testcase heavy disk-io or heavy disk-io +
network?

Sebastian
