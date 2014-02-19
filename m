Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaBSPmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:42:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:52307 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaBSPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:42:16 -0500
Message-ID: <5304D0D5.3030802@linutronix.de>
Date: Wed, 19 Feb 2014 16:42:13 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Ulrich Obergfell <uobergfe@redhat.com>
Subject: Re: [PATCH RT] kernel/hrtimer: be non-freezeable in cpu_chill()
References: <20140205115125.3cc950ce@gandalf.local.home>	<20140207113006.GD23668@linutronix.de>	<20140207090834.72774272@gandalf.local.home>	<20140207091313.097f9059@gandalf.local.home>	<20140219115353.GA28909@linutronix.de> <20140219102700.04de1195@gandalf.local.home>
In-Reply-To: <20140219102700.04de1195@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 04:27 PM, Steven Rostedt wrote:

> Hmm, I wonder if this is because msleep() sets the tasks state to
> TASK_UNINTERRUPTIBLE, and hrtimer_nanosleep sets it to
> TASK_INTERRUPTIBLE.

No, it is because freezable_schedule() is called via do_nanosleep() in
hrtimer call path and msleep() calls schedule() without it.

Sebastian
