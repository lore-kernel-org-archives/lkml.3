Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab3DHPHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:07:15 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:41181 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936034Ab3DHPHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:07:13 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 11:07:12 EDT
Date: Mon, 8 Apr 2013 14:57:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
In-Reply-To: <20130330091037.GA31743@gmail.com>
Message-ID: <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com> <1364398359-21990-5-git-send-email-fweisbec@gmail.com> <20130328074507.GC24433@gmail.com> <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com>
 <20130330091037.GA31743@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.08-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we could simplify things quite a bit if we either

1. Add any cpus specified with nohz_full/extended=xxx to
rcu_nocb. No check is then necessary anymore.

or

2. Avoid the setting of cpus entirely? If full nohz mode is desired
then pick one cpu (f.e. the first one or the one that is used for xtime
updates) and then make all other cpus nohz. Set the affinity mask for the
rcuoXXX threads to that cpu.

