Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaDNXia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:38:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:50399 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaDNXi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:38:29 -0400
Date: Tue, 15 Apr 2014 01:38:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 00/38] tick cleanups and bugfixes
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1404150116130.22697@ionos.tec.linutronix.de>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014, Viresh Kumar wrote:
> Hi Thomas,
> 
> These are separate cleanups from the timers/hrtimers ones I did. I was waiting
> for the merge window to close in order to send these and by the time it
> happened, I got a long pending list.
> 
> These are mostly cleanups, reorders for better readability or efficiency, and
> few bugfixes.

And that's wrong to begin with.

Bugfixes first and then all other stuff. We dont want dependencies of
bugfixes on cleanups, reordering of code ...

I'm not applying a wholesale checkpatch.pl patch which creates noise
for no value.

I don't mind if you cleanup stuff while doing other changes, but
definitely not as a stand alone starter of a large patch queue with
bugfixes which depend on that.

Now looking at the thing some more, it contains gems like this:

-               printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
-                      "offline CPU #%d\n", *oncpu);
+               printk(KERN_ERR "tick-broadcast: ignoring broadcast for offline CPU #%d\n",
+                      *oncpu);

If you fix that checkpatch.pl line wrap issue, why do you not change
printk(KERN_ERR) to pr_err() as well?

checkpatch.pl is happy, right?

I'm tired of this, really.

Please send me the next series in the following way:

- send a bug fix series, which does nothing else than fixing bugs.

  when that is applied, then

- send a small batch of improvements for a particular issue and not a
  mixed bag of random patches.

Thanks,

	tglx
