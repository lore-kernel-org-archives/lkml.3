Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3FIKAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:00:14 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:2101
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab3FIKAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:00:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1de2h1dfeh1dffh1155h)
Date: Sun, 9 Jun 2013 17:59:42 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <leoli@freescale.com>, <scottwood@freescale.com>,
        <Priyanka.Jain@freescale.com>
Subject: Re: [PATCH][RFC] kernel/cpu: do not change the cpus_allowed of the
 current task when unplugging cpus
Message-ID: <20130609095942.GA8548@localhost.localdomain>
References: <1368699439-13034-1-git-send-email-chenhui.zhao@freescale.com>
 <20130607090543.GD10280@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130607090543.GD10280@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:05:43AM +0200, Sebastian Andrzej Siewior wrote:
> * Zhao Chenhui | 2013-05-16 18:17:19 [+0800]:
> 
> >We found a problem. When a cpu is brought down using _cpu_down(),
> >the corresponding cpu bit in the cpus_allowed of the current task is
> >cleared. But this bit will not be set when the same cpu is online again.
> >Then, the current task and its child processes will not be allowed to
> >run on this cpu.
> 
> Isn't this what should happen? This also happens on mainline if you
> leave the RT bits out, right? You should be able to put the task back on
> the CPU once the CPU is up again.
> 
> Sebastian
> 

No. _cpu_down() on mainline do not change the cpus_allowed.

The problem is that the task which turned off cpu2 (for instance)
can not run on cpu2 again after cpu2 is turned on, because cpu2 has been
removed from the cpus_allowed of the task.

The task can put himself back on cpu2 throuhg the system call,
but I think applications should not do this work and do not care which cpu
it is running on in most time.

-Chenhui

