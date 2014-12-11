Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbaLKQvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:51:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbaLKQvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:51:22 -0500
Date: Thu, 11 Dec 2014 17:50:58 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        brouer@redhat.com
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
Message-ID: <20141211175058.64a1c2fc@redhat.com>
In-Reply-To: <alpine.DEB.2.11.1412110902450.28416@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141211143518.02c781ee@redhat.com>
	<alpine.DEB.2.11.1412110902450.28416@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014 09:03:24 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> On Thu, 11 Dec 2014, Jesper Dangaard Brouer wrote:
> 
> > It looks like an impressive saving 116 -> 60 cycles.  I just don't see
> > the same kind of improvements with my similar tests[1][2].
> 
> This is particularly for a CONFIG_PREEMPT kernel. There will be no effect
> on !CONFIG_PREEMPT I hope.
> 
> > I do see the improvement, but it is not as high as I would have expected.
> 
> Do you have CONFIG_PREEMPT set?

Yes.

$ grep CONFIG_PREEMPT .config
CONFIG_PREEMPT_RCU=y
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y

Full config here:
 http://people.netfilter.org/hawk/kconfig/config01-slub-fastpath01

I was expecting to see at least (specifically) 4.291 ns improvement, as
this is the measured[1] cost of preempt_{disable,enable] on my system.

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_sample.c
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
