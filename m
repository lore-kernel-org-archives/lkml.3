Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3LGE5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 23:57:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126Ab3LGE5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 23:57:37 -0500
Message-ID: <1386392252.5673.31.camel@marge.simpson.net>
Subject: Re: [PATCH] Trace idle entry and exit times
From: Mike Galbraith <bitbucket@online.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, lenb@kernel.org, tglx@linutronix.de,
        peterz@infradead.org
Date: Sat, 07 Dec 2013 05:57:32 +0100
In-Reply-To: <1386377164-2223-1-git-send-email-andi@firstfloor.org>
References: <1386377164-2223-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:buA2JQ3px43uW9GhtIt5KTyNRhwDOygrwYaksURfRkL
 nk9KicR6wlcQfEq8FaTGqjSvvOxyScTQeoBFRLAejnKCsyvsdf
 qBnLB3A0KR+zXD/gzf5ZFLMZFPoJnC2x7OpcEJ88I9S+F1gg6i
 uQXFkQI2P08QT3ZsqTvJ/FTtzwjx0lLDpofUChneWm7R7O3LNU
 s1TN7WdCjE8blHg+mXY6N1Nz19KtRGp4dMPMefmOIwtu4Kfs9j
 S7gLUd6lj8vXkl2EzTbyOatwRzh+M1zkVamR4rFM5yq/8MVGSi
 FF6ffS/q8fATKU1Z13+U9+3mSpIdivr34lSq3Rxvz7eLzXiTcR
 ct0KjBfgVzHgiY12ym+dDk2J9/UA4ZA33qHrmGRk3u5M3GxLVX
 lMdzHzjxHE3aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 16:46 -0800, Andi Kleen wrote: 
> From: Andi Kleen <ak@linux.intel.com>
> 
> This patch creates 4 new trace points: one at the beginning of idle,
> one before entering mwait, one after exiting mwait, and one after
> finishing the idle code. This is useful to trace down any
> additional latencies caused by the ever-growing idle code.
> 
> Idle latencies are a common source of performance problems, so it's
> important to be able to measure them.

You mean stuff like.. oh, say 60 cores doing zero work every 12ms
munching ~20% cpu?

-  97.57%  [kernel]          [k] _raw_spin_lock_irqsave                                                                                                                                                                                    ▒
   - _raw_spin_lock_irqsave                                                                                                                                                                                                                ▒
      - 97.02% clockevents_notify                                                                                                                                                                                                          ◆
           intel_idle                                                                                                                                                                                                                      ▒
           cpuidle_idle_call                                                                                                                                                                                                               ▒
           cpu_idle                                                                                                                                                                                                                        ▒
      - 2.97% tick_broadcast_oneshot_control                                                                                                                                                                                               ▒
           tick_notify                                                                                                                                                                                                                     ▒
           notifier_call_chain                                                                                                                                                                                                             ▒
           clockevents_notify                                                                                                                                                                                                              ▒
           intel_idle                                                                                                                                                                                                                      ▒
           cpuidle_idle_call                                                                                                                                                                                                               ▒
           cpu_idle

C2 is super green, it's hug'n the sh*t outta them trees :)

	-Mike

