Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab3D3RwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:52:05 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:58605 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760855Ab3D3RwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:52:03 -0400
Message-ID: <1367344318.8833.59.camel@Wailaba2>
Subject: Re: [PATCH 2/3] posix_timers: Defer per process timer stop after
 timers processing
From: Olivier Langlois <olivier@trillion01.com>
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
Date: Tue, 30 Apr 2013 13:51:58 -0400
In-Reply-To: <20130430125423.GB8272@somewhere>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
	 <1366305822-5499-3-git-send-email-fweisbec@gmail.com>
	 <1366345802.2855.38.camel@Wailaba2>
	 <CAFTL4hzTbko=jArO+kFF3icDbXmZzamDr1FJL3Vx+11Q54NABg@mail.gmail.com>
	 <1366950479.7911.22.camel@Wailaba2> <20130430125423.GB8272@somewhere>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > Maybe the condition around the posix_cpu_timer_schedule() block inside
> > cpu_timer_fire() could even be a good candidate for 'unlikely'
> > qualifier.
> 
> Well, cpu_timer_fire() is probably not a fast path. So helping branch
> prediction there probably won't have much measurable effect in practice.
> 
Frederic, I'm totally sure that you are right on the measurable effect.
When I did propose the 'unlikely' qualifier, please note, that I also
had a documentary purpose in mind.

Would you have searched the 'likely' path that does
posix_cpu_timer_schedule() when you did modify the code if the
'unlikely' tag would have been present?

Greetings,
Olivier



