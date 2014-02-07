Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaBGLaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:30:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:43290 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaBGLaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:30:08 -0500
Date: Fri, 7 Feb 2014 12:30:06 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Ulrich Obergfell <uobergfe@redhat.com>
Subject: Re: [PATCH RT] rt: Make cpu_chill() use hrtimer instead of msleep()
Message-ID: <20140207113006.GD23668@linutronix.de>
References: <20140205115125.3cc950ce@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140205115125.3cc950ce@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2014-02-05 11:51:25 [-0500]:

>Ulrich Obergfell pointed out that cpu_chill() calls msleep() which is woken
>up by the ksoftirqd running the TIMER softirq. But as the cpu_chill() is
>called from softirq context, it may block the ksoftirqd() from running, in
>which case, it may never wake up the msleep() causing the deadlock.
>
>I checked the vmcore, and irq/74-qla2xxx is stuck in the msleep() call,
>running on CPU 8. The one ksoftirqd that is stuck, happens to be the one that
>runs on CPU 8, and it is blocked on a lock held by irq/74-qla2xxx. As that
>ksoftirqd is the one that will wake up irq/74-qla2xxx, and it happens to be
>blocked on a lock that irq/74-qla2xxx holds, we have our deadlock.

could you please tell me which two locks are invovled here?

Sebastian
