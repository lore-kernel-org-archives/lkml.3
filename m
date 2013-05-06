Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab3EFXDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:03:40 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38834 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389Ab3EFXDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:03:37 -0400
Date: Tue, 7 May 2013 01:03:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>
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
Subject: Re: [PATCH 2/3] posix_timers: Defer per process timer stop after
 timers processing
Message-ID: <20130506230332.GA1225@somewhere>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
 <1366305822-5499-3-git-send-email-fweisbec@gmail.com>
 <1366345802.2855.38.camel@Wailaba2>
 <CAFTL4hzTbko=jArO+kFF3icDbXmZzamDr1FJL3Vx+11Q54NABg@mail.gmail.com>
 <1366950479.7911.22.camel@Wailaba2>
 <20130430125423.GB8272@somewhere>
 <1367344318.8833.59.camel@Wailaba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367344318.8833.59.camel@Wailaba2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 01:51:58PM -0400, Olivier Langlois wrote:
> 
> > 
> > > Maybe the condition around the posix_cpu_timer_schedule() block inside
> > > cpu_timer_fire() could even be a good candidate for 'unlikely'
> > > qualifier.
> > 
> > Well, cpu_timer_fire() is probably not a fast path. So helping branch
> > prediction there probably won't have much measurable effect in practice.
> > 
> Frederic, I'm totally sure that you are right on the measurable effect.
> When I did propose the 'unlikely' qualifier, please note, that I also
> had a documentary purpose in mind.
> 
> Would you have searched the 'likely' path that does
> posix_cpu_timer_schedule() when you did modify the code if the
> 'unlikely' tag would have been present?

It's indeed sometimes a good indicator.

But here it's in the end of a batch of conditional blocks, so it sort
of already suggests itself as an unlikely event.

But if you feel the comment can be improved, don't hesitate to send a patch.



> 
> Greetings,
> Olivier
> 
> 
> 
