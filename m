Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaAXTuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:50:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:59250 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaAXTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:50:17 -0500
Date: Fri, 24 Jan 2014 20:50:14 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
Cc: paulmck@linux.vnet.ibm.com, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
Message-ID: <20140124195014.GB29981@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
 <1387681647.5412.25.camel@marge.simpson.net>
 <1387702631.5412.101.camel@marge.simpson.net>
 <1387773533.5369.16.camel@marge.simpson.net>
 <20131224193636.GD19211@linux.vnet.ibm.com>
 <1387940854.5373.8.camel@marge.simpson.net>
 <20131225075544.GE19211@linux.vnet.ibm.com>
 <1387993057.5346.17.camel@marge.simpson.net>
 <20140117171441.GG5785@linutronix.de>
 <1390015514.5444.46.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390015514.5444.46.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2014-01-18 04:25:14 [+0100]:

>> ># timers-do-not-raise-softirq-unconditionally.patch
>> ># rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch
>> >
>> >..those two out does seem to have stabilized the thing.
>> 
>> timers-do-not-raise-softirq-unconditionally.patch is on its way out.
>> 
>> rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch confues me.
>> Didn't you report once that your box deadlocks without this patch? Now
>> your 64way box on the other hand does not work with it?
>
>If 'do not raise' is applied, 'use a trylock' won't save you.  If 'do
is this just an observation or you do know why it won't save me?
Currently I think to go back to the version where the waiter_lock was
taken with irqs off. However I would prefer to trigger this myself so I
would know what is going on instead blindly apply patches.

>-Mike

Sebastian
