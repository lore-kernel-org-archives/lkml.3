Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbaLKTOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:14:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbaLKTOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:14:51 -0500
Date: Thu, 11 Dec 2014 19:11:40 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        brouer@redhat.com
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
Message-ID: <20141211191140.1ebb74a6@redhat.com>
In-Reply-To: <alpine.DEB.2.11.1412111117510.31381@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141211143518.02c781ee@redhat.com>
	<alpine.DEB.2.11.1412110902450.28416@gentwo.org>
	<20141211175058.64a1c2fc@redhat.com>
	<alpine.DEB.2.11.1412111117510.31381@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014 11:18:31 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> On Thu, 11 Dec 2014, Jesper Dangaard Brouer wrote:
> 
> > I was expecting to see at least (specifically) 4.291 ns improvement, as
> > this is the measured[1] cost of preempt_{disable,enable] on my system.
> 
> Right. Those calls are taken out of the fastpaths by this patchset for
> the CONFIG_PREEMPT case. So the numbers that you got do not make much
> sense to me.

True, that is also that I'm saying.  I'll try to figure out that is
going on, tomorrow.

You are welcome to run my test harness:
 http://netoptimizer.blogspot.dk/2014/11/announce-github-repo-prototype-kernel.html
 https://github.com/netoptimizer/prototype-kernel/blob/master/getting_started.rst

Just load module: time_bench_kmem_cache1
 https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_kmem_cache1.c

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
