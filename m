Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3JNOGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:06:24 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:58072 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3JNOGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:06:23 -0400
Date: Mon, 14 Oct 2013 16:06:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 12/14] sched: make dl_bw a sub-quota of rt_bw
Message-ID: <20131014140618.GA26604@gmail.com>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-13-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381747426-31334-13-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Juri Lelli <juri.lelli@gmail.com> wrote:

> +#ifdef CONFIG_SMP
> +		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
> +#else
> +		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
> +#endif

> +#ifdef CONFIG_SMP
> +		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
> +#else
> +		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
> +#endif

Btw., this kind of SMP/UP assymetry pattern really sucks. Why not make UP 
use the SMP data structure, even if it's degenerate?

Thanks,

	Ingo
