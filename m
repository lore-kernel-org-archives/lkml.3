Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaBGKlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:41:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:42873 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaBGKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:41:12 -0500
Date: Fri, 7 Feb 2014 11:41:07 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.9-rt13
Message-ID: <20140207104107.GC23668@linutronix.de>
References: <20140203194841.GA17108@linutronix.de>
 <20140205092657.GA21590@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140205092657.GA21590@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-05 10:26:57 [+0100]:

>Sorry - this one causes a build failure with PREEMPT_RT_BASE=y and 
>PREEMPT_RT_FULL not set.

At some point we are going to drop PREEMPT_RT_BASE because it was only
meant for debugging in the beginning. However I don't know when this
will be.

>The patch below fixes this build failure for 3.12.9-rt13.
>
>Not sure what the clean way of resolving this is - this patch proposes to
>move the spin_*_local into linux/locallock.h and map to spin_*lock for
>the "CONFIG_PREEMPT_RT_FULL not set" case.
>
>This was build tested with Preempt none,voluntary,low-lat,base,full and 
>otherweise got only limited testing.
>
>I'm also not sure if putting the rt specific locks into locallock.h in 
>this way is the proper way to deal with this #include dependency.

I think I keep it that way. However I split into two patches and add the
spin_lock_local => rt_spin_lock mapping in the rt-add-rt-locks.patch
where the locks are introduced.

Sebastian
