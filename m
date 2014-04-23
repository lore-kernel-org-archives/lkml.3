Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaDWMT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:19:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:33669 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752171AbaDWMTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:19:52 -0400
Date: Wed, 23 Apr 2014 08:19:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140423081950.778e1a3a@gandalf.local.home>
In-Reply-To: <1398249425.5910.14.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	<1398249425.5910.14.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 12:37:05 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> On Fri, 2014-04-11 at 20:57 +0200, Sebastian Andrzej Siewior wrote:
> 
> > This -RT series didn't crashed within ~4h testing on my ARM and
> > x86-32.
> > x86-64 crashed after I started hackbench. I figured out that the crash
> > does not happen with lazy-preempt disabled. Therefore the last but one
> > patch in the queue disables lazy preempt on x86-64. With this change the
> > test box survived ~2h without a crash. I look at this later but it looks
> > good now.
> 
> I think the below fixes it (in a more or less minimalist way), but it's
> not very pretty.  Methinks it would be prettier to either clone the x86
> percpu + fold logic, or neutralize that optimization completely when
> PREEMPT_LAZY is enabled.
> 
> x86_32 bit is completely untested, x86_64 hasn't exploded.. yet :) 
> 

This patch makes sense to me.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
