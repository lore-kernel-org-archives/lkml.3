Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3DOK14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:27:56 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52823 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3DOK1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:27:54 -0400
Date: Mon, 15 Apr 2013 12:27:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
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
Message-ID: <20130415102750.GE18024@gmail.com>
References: <20130328074507.GC24433@gmail.com>
 <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com>
 <20130330091037.GA31743@gmail.com>
 <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com>
 <20130411151956.GF15699@somewhere>
 <20130411153721.GA3742@linux.vnet.ibm.com>
 <20130411155349.GA16797@somewhere.redhat.com>
 <0000013df9f8d526-2783fba3-4dc9-44c6-8b02-2c321eb5b37b-000000@email.amazonses.com>
 <20130411170420.GA17129@somewhere.redhat.com>
 <0000013dfef98b2d-ed5980b1-86ff-47de-8aa1-fd7fdd02f034-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013dfef98b2d-ed5980b1-86ff-47de-8aa1-fd7fdd02f034-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 11 Apr 2013, Frederic Weisbecker wrote:
> 
> > It may be too general for a naming. But I don't mind just selecting 
> > CONFIG_RCU_NOCBS_ALL unconditionally. It's easily changed in the future if 
> > anybody complains.
> 
> 
> I like the general nature of that config option since it removes the need to 
> configure all the details. For an average user the current sets of options must 
> look pretty complicated.

Yes.

It's not just complicated but also fragile and time consuming: as new kernel 
options arrive you'd always have to be very careful with 'make oldconfig' and make 
sure you pick up the best options for latency.

Instead what we want is generally a high level knob that documents user preference 
and then the kernel config language can do the rest.

> > > Btw, if CONFIG_RCU_NOCBS_ALL isset, the rcu_nocbs= parameter is ignored, 
> > > right? If you want to keep that direction and not override the Kconfig 
> > > choice, may be warn the user about that if the boot parameter is passed?
> 
> Ok. But all these complicated things would go away if we had an option
> CONFIG_LOWLATENCY and then everything would just follow the best setup
> possible given the hardware. Would remove a lot of guesswork and a lot of
> knobs.

In that sense CONFIG_NO_HZ_FULL is such a flag as well, which, like 
CONFIG_PREEMPT_RT, tries to preconfigure the kernel correctly.

But we have to be careful not to use a too highlevel flag for that. If the user 
meant 'low latency' to mean 'low latency IRQ execution' - then enabling 
CONFIG_NO_HZ_FULL might achieve the opposite, it adds overhead to the IRQ paths.

Thanks,

	Ingo
