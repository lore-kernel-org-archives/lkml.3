Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936363Ab3DIOpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:45:55 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:35069 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761532Ab3DIOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:45:54 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2013 10:45:54 EDT
Date: Tue, 9 Apr 2013 14:35:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
In-Reply-To: <5164160D.7080201@windriver.com>
Message-ID: <0000013def390189-5508c590-e421-49e7-9eab-a3924489091a-000000@email.amazonses.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com> <1364398359-21990-5-git-send-email-fweisbec@gmail.com> <20130328074507.GC24433@gmail.com> <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com> <20130330091037.GA31743@gmail.com>
 <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com> <5164160D.7080201@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013, Paul Gortmaker wrote:

> > 2. Avoid the setting of cpus entirely? If full nohz mode is desired
> > then pick one cpu (f.e. the first one or the one that is used for xtime
> > updates) and then make all other cpus nohz. Set the affinity mask for the
> > rcuoXXX threads to that cpu.
>
> I can imagine people with multi socket systems wanting to have
> a system partitioned with one "normal" core per physical socket,
> for timekeeping, RCU threads, etc, but #2 would prevent that.

That is a good point. The kernel needs to run per node threads for I/O and
reclaim which could have their home there. Just had some bad experience
with latency introduced by the block layer redirecting I/O to the first
processor of a node. Maybe we can adopt that convention and relocate
kernel processing as much as possible to the first processor of a
node?


