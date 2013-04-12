Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3DLQGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:06:46 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:49291 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab3DLQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:06:45 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Apr 2013 12:06:45 EDT
Date: Fri, 12 Apr 2013 15:59:59 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20130411170420.GA17129@somewhere.redhat.com>
Message-ID: <0000013dfef98b2d-ed5980b1-86ff-47de-8aa1-fd7fdd02f034-000000@email.amazonses.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com> <1364398359-21990-5-git-send-email-fweisbec@gmail.com> <20130328074507.GC24433@gmail.com> <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com> <20130330091037.GA31743@gmail.com>
 <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com> <20130411151956.GF15699@somewhere> <20130411153721.GA3742@linux.vnet.ibm.com> <20130411155349.GA16797@somewhere.redhat.com> <0000013df9f8d526-2783fba3-4dc9-44c6-8b02-2c321eb5b37b-000000@email.amazonses.com>
 <20130411170420.GA17129@somewhere.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.12-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Frederic Weisbecker wrote:

> It may be too general for a naming. But I don't mind just
> selecting CONFIG_RCU_NOCBS_ALL unconditionally. It's easily
> changed in the future if anybody complains.


I like the general nature of that config option since it removes the need
to configure all the details. For an average user the current sets of
options must look pretty complicated.

> > Btw, if CONFIG_RCU_NOCBS_ALL isset, the rcu_nocbs=
parameter > is ignored, right? If you want to keep that direction and not
> override the Kconfig choice, may be warn the user about that
> if the boot parameter is passed?

Ok. But all these complicated things would go away if we had an option
CONFIG_LOWLATENCY and then everything would just follow the best setup
possible given the hardware. Would remove a lot of guesswork and a lot of
knobs.
