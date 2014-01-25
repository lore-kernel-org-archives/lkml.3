Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaAYFUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 00:20:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaAYFUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 00:20:38 -0500
Message-ID: <1390627226.3625.18.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 25 Jan 2014 06:20:26 +0100
In-Reply-To: <20140124194642.GA29981@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
	 <1387702631.5412.101.camel@marge.simpson.net>
	 <1387773533.5369.16.camel@marge.simpson.net>
	 <1387775559.5369.20.camel@marge.simpson.net>
	 <20140124194642.GA29981@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Thvqj5GM/vpgIDwbwlpoCOudJEY2RO1nLGZf1BjvMpE
 v4EeA8YWyRDvfbODY0YZSlB2jul4M706GgaHhsoIjSgdhGVqwc
 +5nPqP2ycr8o15PBNsp6G6PgWULHxzs01GVh4GvW/5Hg+JQ0Ta
 C/eZ75F/DEd//FsQAhXvT5cepLJ/KEh9DwHJNrFdy5QB2CJoc+
 1S9a0sy/fC2bsYpQ/3jK6DIDDbk1sy/0MvkKnTT/wiutRWMlOu
 7tAAym+hojq2i0RYl5U/s8VDnJbb2KUM2Bxfx290d+pN36yhla
 g7m3zYmL5zl+Lqy45qLkiy90p1GBdzGSTJovwCgNlk65UmY4p4
 J1ToxDQqRJTg2IV5Je+9zlNkHfJPNOR0PaXB5HsISbvBUNdSGA
 nEXaXDcjzkxQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 20:46 +0100, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2013-12-23 06:12:39 [+0100]:
> 
> >P.S.
> >
> >virgin -rt7 doing tbench 64 + make -j64
> >
> >[   97.907960] perf samples too long (3138 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> >[  103.047921] perf samples too long (5544 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
> >[  181.561271] perf samples too long (10318 > 10000), lowering kernel.perf_event_max_sample_rate to 13000
> >[  184.243750] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 1.084 msecs
> >[  248.914422] perf samples too long (19719 > 19230), lowering kernel.perf_event_max_sample_rate to 7000
> >[  382.116674] NOHZ: local_softirq_pending 10
> This is block
> 
> >[  405.201593] perf samples too long (36824 > 35714), lowering kernel.perf_event_max_sample_rate to 4000
> >[  444.704185] NOHZ: local_softirq_pending 08
> >[  444.704208] NOHZ: local_softirq_pending 08
> >[  444.704579] NOHZ: local_softirq_pending 08
> >[  444.704678] NOHZ: local_softirq_pending 08
> >[  444.705100] NOHZ: local_softirq_pending 08
> >[  444.705980] NOHZ: local_softirq_pending 08
> >[  444.705994] NOHZ: local_softirq_pending 08
> >[  444.708315] NOHZ: local_softirq_pending 08
> >[  444.710348] NOHZ: local_softirq_pending 08
> 
> and this is RX. Is your testcase heavy disk-io or heavy disk-io +
> network?

Yeah.

-Mike

