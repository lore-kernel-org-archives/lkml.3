Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaFMTnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:43:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:50239 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaFMTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:43:34 -0400
Date: Fri, 13 Jun 2014 21:43:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch V4 09/10] rtmutex: Cleanup deadlock detector debug
 logic
In-Reply-To: <20140613131928.061636e7@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406132142390.5170@nanos>
References: <20140611182944.108526809@linutronix.de> <20140611183853.644673097@linutronix.de> <20140613131928.061636e7@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Steven Rostedt wrote:
> On Wed, 11 Jun 2014 18:44:08 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > -	rt_mutex_adjust_prio_chain(task, 0, NULL, next_lock, NULL, task);
> > +	rt_mutex_adjust_prio_chain(task, RT_MUTEX_MIN_CHAINWALK, NULL, NULL,
> 
> You dropped next_lock here. Was that intentional? I doubt it.

Definitely not. Thanks for spotting it.
