Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEBPb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:31:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:42328 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEBPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:31:57 -0400
Date: Fri, 2 May 2014 17:31:53 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RT 1/3] rt: Move migrate_disable up in trylocks
Message-ID: <20140502153153.GG9178@linutronix.de>
References: <20140501004757.583708392@goodmis.org>
 <20140501005004.241785945@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140501005004.241785945@goodmis.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2014-04-30 20:47:58 [-0400]:

>From: Steven Rostedt <rostedt@goodmis.org>
>
>The changes to move the migrate_disable() down in the trylocks()
>caused race conditions to appear in the cpu hotplug code. The
>migrate disables must be done before any of the rtmutexes are
>taken, otherwise a lock may be held that prevents hotplug from
>moving forward.
>
>Link: http://lkml.kernel.org/r/20140429201308.63292691@gandalf.local.home

Okay. I am taking a modified version (so it applies) of this into v3.14
tree. Mike also suggested to drop
migrate_disable-pushd-down-in-atomic_dec_and_spin_lo.patch because we
which is basicaly the some thing. And then we have
migrate_disable-pushd-down-in-rt_spin_trylock_irqsav.patch which we
could drop as well for the same reason.

Sebastian
