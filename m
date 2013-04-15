Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3DOQSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:18:06 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:46083 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359Ab3DOQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:18:04 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2013 12:18:04 EDT
Date: Mon, 15 Apr 2013 16:11:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
In-Reply-To: <20130415102750.GE18024@gmail.com>
Message-ID: <0000013e0e7759a3-5b08a307-9a47-49de-b1cf-d00306df0f6d-000000@email.amazonses.com>
References: <20130328074507.GC24433@gmail.com> <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com> <20130330091037.GA31743@gmail.com> <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com> <20130411151956.GF15699@somewhere>
 <20130411153721.GA3742@linux.vnet.ibm.com> <20130411155349.GA16797@somewhere.redhat.com> <0000013df9f8d526-2783fba3-4dc9-44c6-8b02-2c321eb5b37b-000000@email.amazonses.com> <20130411170420.GA17129@somewhere.redhat.com>
 <0000013dfef98b2d-ed5980b1-86ff-47de-8aa1-fd7fdd02f034-000000@email.amazonses.com> <20130415102750.GE18024@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.15-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Ingo Molnar wrote:

> > Ok. But all these complicated things would go away if we had an option
> > CONFIG_LOWLATENCY and then everything would just follow the best setup
> > possible given the hardware. Would remove a lot of guesswork and a lot of
> > knobs.
>
> In that sense CONFIG_NO_HZ_FULL is such a flag as well, which, like
> CONFIG_PREEMPT_RT, tries to preconfigure the kernel correctly.

It is too specific. Switching off HZ is one in a set of measures that one
woiuld take. F.e. the page allocator will want to do reclaim on the
sacrificial processor, the vmstatistics would run their monitoring thread
there etc etc.

> But we have to be careful not to use a too highlevel flag for that. If the user
> meant 'low latency' to mean 'low latency IRQ execution' - then enabling
> CONFIG_NO_HZ_FULL might achieve the opposite, it adds overhead to the IRQ paths.

Hmm.... Looks too specific for my taste. What the user wants is less OS
noise (or maybe some other terms that describes that the user wants
minimal disturbances for his code).

	CONFIG_OS_NOISE_REDUCTION

?

