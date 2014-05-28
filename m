Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaE1U1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:27:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:40170 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaE1U1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:27:03 -0400
Date: Wed, 28 May 2014 22:26:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kirill Tkhai <tkhai@yandex.ru>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [RFC] rtmutex: Do not boost fair tasks each other
In-Reply-To: <1399314660.6978.3.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1405282157100.3952@nanos>
References: <5362122B.8060305@yandex.ru>  <alpine.DEB.2.02.1405032041460.6261@ionos.tec.linutronix.de> <1399314660.6978.3.camel@localhost.localdomain>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1162344849-1401308817=:3952"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1162344849-1401308817=:3952
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2014, Kirill Tkhai wrote:
> В Сб, 03/05/2014 в 20:54 +0200, Thomas Gleixner пишет:
> > Though exercising that code path as much as we can is not a bad thing
> > either. So I'd like to see that made compile time conditional on one
> > of the lock testing CONFIG items.
>  
> +#ifndef CONFIG_RT_MUTEX_BOOST_ALL

No, not another pointless config option. Read what I said. What's
wrong with using an existing config item, e.g DEBUG_RT_MUTEXES?

> +#define heritable_prio(prio)		(rt_prio(prio) || dl_prio(prio))

inheritable please. It's not priority heritance and never will be.

Thanks,

	tglx
--8323329-1162344849-1401308817=:3952--
