Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaAaWHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:07:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:56697 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:07:39 -0500
Date: Fri, 31 Jan 2014 23:07:37 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 4/8] rtmutex: use a trylock for waiter lock in trylock
Message-ID: <20140131220737.GF21238@linutronix.de>
References: <20140116015824.201732155@goodmis.org>
 <20140116020324.637491369@goodmis.org>
 <1389841737.5418.14.camel@marge.simpson.net>
 <20140116232228.0f3cfb89@gandalf.local.home>
 <1389935832.5449.23.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389935832.5449.23.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2014-01-17 06:17:12 [+0100]:

>On Thu, 2014-01-16 at 23:22 -0500, Steven Rostedt wrote: 
>> On Thu, 16 Jan 2014 04:08:57 +0100
>> Mike Galbraith <bitbucket@online.de> wrote:
>> 
>> > On Wed, 2014-01-15 at 20:58 -0500, Steven Rostedt wrote:
>> > 
>> > 
>> > > 3.2.53-rt76-rc1 stable review patch.
>> > > If anyone has any objections, please let me know.
>> > 
>> > Not sure this is needed without the tglx don't unconditionally raise
>> > timer softirq patch, and with that patch applied in the form it exists
>> > in 3.12-rt9, as well as this one, you'll still eventually deadlock.
>> 
>> Hmm, I'll have to take a look. This sounds to be missing from all the
>> stable -rt kernels. I'll be pulling in the latest updates from 3.12-rt
>> soon.
>
>Below are the two deadlocks I encountered with 3.12-rt9, which has both
>$subject and timers-do-not-raise-softirq-unconditionally.patch applied.

This patch was introduced because we had a deadlock in
run_local_timers() which took a sleeping lock in hardirq context. This
seem not to be the case in v3.2 therefore I would suggest not to take
this patch here because it does not fix anything.

Mike, do you see these deadlocks with 3.12.*-rt11 as well?

Sebastian
