Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbaCEP1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:27:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22439 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755808AbaCEP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:27:04 -0500
Date: Wed, 5 Mar 2014 10:26:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, mingo@redhat.com,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/3] sched: Use clamp() and clamp_val() to make it more
 readable.
Message-ID: <20140305102658.4c7ffe2c@gandalf.local.home>
In-Reply-To: <1394032656.3271.51.camel@joe-AO722>
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
	<0b02fa0f05c9cebca19cadce92cb8c85ee130ce0.1394022835.git.yangds.fnst@cn.fujitsu.com>
	<1394032656.3271.51.camel@joe-AO722>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 07:17:36 -0800
Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-03-05 at 20:36 +0800, Dongsheng Yang wrote:
> > As Kees suggested, I use clamp() function to replace the if and
> > else branch, making it more readable and modular.
> > 
> > Suggested-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> []
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> []
> > @@ -3070,17 +3070,10 @@ SYSCALL_DEFINE1(nice, int, increment)
> >  	 * We don't have to worry. Conceptually one call occurs first
> >  	 * and we have a single winner.
> >  	 */
> > -	if (increment < -40)
> > -		increment = -40;
> > -	if (increment > 40)
> > -		increment = 40;
> > -
> > +	increment = clamp(increment, -40, 40);
> 
> Maybe:
> 
> 	increment = clamp(increment, -(NICE_MAX - NICE_MIN + 1), 
> 				   , NICE_MAX - NICE_MIN + 1)

Ug, that's much harder to read.

> 
> or add yet another define like #define NICE_RANGE
> or #define NICE_MAX_INCREMENT

Sure, if there's a NICE_MAX_INC == 40, then we could do:

	increment = clamp(increment, -NICE_MAX_INC, NICE_MAX_INC);

-- Steve
