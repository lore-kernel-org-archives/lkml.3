Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaEBKJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:09:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:39546 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaEBKJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:09:53 -0400
Date: Fri, 2 May 2014 12:09:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140502100951.GC9178@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
 <1397918766.5436.16.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1397918766.5436.16.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2014-04-19 16:46:06 [+0200]:

>Hi Sebastian,
Hi Mike,

>This hunk in hotplug-light-get-online-cpus.patch looks like a bug.
>
>@@ -333,7 +449,7 @@ static int __ref _cpu_down(unsigned int
>                /* CPU didn't die: tell everyone.  Can't complain. */
>                smpboot_unpark_threads(cpu);
>                cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
>-               goto out_release;
>+               goto out_cancel;
>        }
>        BUG_ON(cpu_online(cpu));

Yes, it looks like it. v3.12-rt did not have this…

Sebastian
