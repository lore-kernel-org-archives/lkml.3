Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3DZGVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:21:18 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:44841 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753564Ab3DZGVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:21:17 -0400
Message-ID: <1366957273.7911.36.camel@Wailaba2>
Subject: Re: [PATCH 2/3] posix_timers: Defer per process timer stop after
 timers processing
From: Olivier Langlois <olivier@olivierlanglois.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 26 Apr 2013 02:21:13 -0400
In-Reply-To: <1366950479.7911.22.camel@Wailaba2>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
	 <1366305822-5499-3-git-send-email-fweisbec@gmail.com>
	 <1366345802.2855.38.camel@Wailaba2>
	 <CAFTL4hzTbko=jArO+kFF3icDbXmZzamDr1FJL3Vx+11Q54NABg@mail.gmail.com>
	 <1366950479.7911.22.camel@Wailaba2>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:olivierlanglois.net} {sentby:smtp auth 173.178.230.31 authed with olivier@olivierlanglois.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> 
> IMO, a more likely scenario, posix_cpu_timer_schedule() will be called
> from dequeue_signal() which will be from from a different context than
> the interrupt context.
> 
I'll be even more explicit. Inside dequeue_signal(),

do_schedule_next_timer() is called which then call
posix_cpu_timer_schedule().



