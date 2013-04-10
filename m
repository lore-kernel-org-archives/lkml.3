Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936204Ab3DJHOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:14:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47693 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3DJHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:14:29 -0400
Message-ID: <1365578066.30071.14.camel@laptop>
Subject: Re: [PATCH] sched: Fix 32bit race in sched_clock_remote()
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Apr 2013 09:14:26 +0200
In-Reply-To: <20130409145546.GA14231@zhy>
References: <1365179800.2609.135.camel@laptop> <20130409145546.GA14231@zhy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 22:55 +0800, Yong Zhang wrote:
> > +     this_clock = scd_clock_read(my_scd);
> > +     remote_clock = scd_clock_read(scd);
>                        ^^^^^^^^^^^^^^
>                        it doesn't match the declaration:
> scd_read_clock().

Yeah, I'm a moron and forgot to compile test or somesuch :-)

Anyway, Thomas wrote a much better patch which made it in; see
a1cbcaa9ea87b87a96b9fc465951dcf36e459ca2.

