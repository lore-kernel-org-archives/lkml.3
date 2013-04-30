Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672Ab3D3Ne6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:34:58 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:44384 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759102Ab3D3Ne4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:34:56 -0400
Message-ID: <1367328894.8833.49.camel@Wailaba2>
Subject: Re: [PATCH 06/10] posix-cpu-timers: fix wrong timer initialization
From: Olivier Langlois <olivier@trillion01.com>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 30 Apr 2013 09:34:54 -0400
In-Reply-To: <1367291838-5490-7-git-send-email-kosaki.motohiro@gmail.com>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
	 <1367291838-5490-7-git-send-email-kosaki.motohiro@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 23:17 -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently glibc's rt/tst-cputimer1 testcase is spradically fail because
> a timer created by timer_create() may fire earlier than it's specified.
> 
> posix_cpu_timer_set() uses "val" as current time for three purpose. 1)
> initialize sig->cputimer. 2) calculation "old" val. 3) calculations an
> expires time.
> 
> (1) and (2) should be used only committed time (i.e. without delta_exec)
> because run_posix_cpu_timers() don't care of delta_exec and we need
> consistency. But (3) need exact current time (aka cpu clock time) beucase
> an expires should be "now + timeout" by definition.
> 
> This patch makes separete two kind of "now".
> 
Kosaki,

I must admit that this solution is simpler to what I originally
proposed.

good work!
Olivier



