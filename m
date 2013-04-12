Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3DLJS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:18:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DLJSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:18:25 -0400
Message-ID: <1365758303.17140.37.camel@laptop>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Peter Zijlstra <peterz@infradead.org>
To: Olivier Langlois <olivier@trillion01.com>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 11:18:23 +0200
In-Reply-To: <1365608911.707.65.camel@Wailaba2>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:48 -0400, Olivier Langlois wrote:
> If it is important to stop it then the code will require a fix anyway.
> 
> 1.
> As you could start it
> indefinitely with 0 timers if calling posix_cpu_timer_set() does not
> end
> up arming a timer or
> 
> 2.
> 
> Having one periodic timer. The cputimer will be stopped in
> check_process_timers() to be immediatly restarted in
> posix_cpu_timer_schedule() every single time the timer will be fired.

OK, then yes that wants fixing. That was not intended.

The intent was starting the accounting when required and stopping it
when no longer needed.

