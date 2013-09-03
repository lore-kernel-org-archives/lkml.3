Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482Ab3ICScf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:32:35 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38214 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760215Ab3ICScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:32:33 -0400
Date: Tue, 3 Sep 2013 20:32:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130903183229.GB30757@gmail.com>
References: <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
 <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
 <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
 <20130902135033.GA1686@redhat.com>
 <20130902140015.GB2368@swordfish.minsk.epam.com>
 <20130903084306.GA2694@redhat.com>
 <20130903180912.GA2340@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903180912.GA2340@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> On (09/03/13 10:43), Stanislaw Gruszka wrote:
> > Ok, I see now, utime is 0 . This seems to be problem with dynamic ticks
> > as you told that your application is kernel compilation, so we utilize
> > lot of cpu time in user-space.
> > 
> > Anyway we should handle utime == 0 situation on scaling code. We work
> > well when rtime & stime are not big (variables and results fit in
> > 32 bit), otherwise we have that stime bigger than rtime problem. Let's
> > try to handle the problem by below patch. Sergey, does it work for you ?
> 
> checked on -current and -next -- works fine, good job.
> 
> here are my:
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Cool and thanks for the patient reporting and testing!

Stanislaw, mind sending a changelogged, signed off patch with Sergey's 
tags included? It also warrants a -stable backport tag I think.

Thanks,

	Ingo
