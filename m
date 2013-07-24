Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3GXCVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:21:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3GXCVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:21:33 -0400
Message-ID: <1374632489.7333.18.camel@marge.simpson.net>
Subject: Re: ptrace(PTRACE_ATTACH)  [no intervering wait]
 ptrace(PTRACE_DETACH) may leave tracee stuck
From: Mike Galbraith <bitbucket@online.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Jul 2013 04:21:29 +0200
In-Reply-To: <20130723155854.GA26211@redhat.com>
References: <1374573914.30532.68.camel@marge.simpson.net>
	 <20130723155854.GA26211@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:AgRqZmkp3zmRIFsBxCwCfNkHQY7iIwmSGyiSqGwF4Nq
 sNdujq6EjDysqvirwqmgauZu13q8ftkBxFngPPrPeAvN+UmCuW
 cBG27ILR5Q4Q6hHTIMh5RS6GM79PKuTTvfgwyzIwu4Uigptfz5
 z8cG2UKNprf8z+5o8RpaMBIFYC4G0tLhIOLRZxZf6/rsQ+gJxw
 d3THs4Dk34B3D+wYaVSzS3exNRkQFbmAZTCS4NTzLMWgwybzU6
 sXcpwxjrnopLIkZdhS29hrF7kdG1W7pYX04FnbBNQLuPgsRF0m
 NZY+7NyGrQ9KBk+bdJbTrxexe36OyiljEQ1iYMyobuI30l/Al8
 cJh6BSbYpd2QbA+kEMdZ0a0d/FN9s7/19aNMuK/sNibzZzraIW
 rlmFX+ki+NLTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 17:58 +0200, Oleg Nesterov wrote: 
> On 07/23, Mike Galbraith wrote:
> >
> > I received a report that glibc:elf/pldd hangs occasionally, and indeed..
> >
> >   for i in `seq 1 1000`; do taskset -c 3 pldd $$ > /dev/null 2>&1; done
> >
> > ..will do so.  Rummage.....
> >
> > ptrace(PTRACE_DETACH) returns -ESRCH when the trap hasn't happened yet,
> > which happens because pldd doesn't wait() before ptrace(PTRACE_DETACH).
> >
> > pldd source:
> >
> [...snip...]
> >
> > Seems this usually works only because cycles expended between attach and
> > detach is usually enough to let trap happen so tracee can set its state
> > to TASK_TRACED as PTRACE_DETACH expects it to be.
> >
> > Is this expected behavior?
> 
> Yes. PTRACE_ATTACH + PTRACE_DETACH is not correct without wait() in
> between, this is expected.

Thanks for confirmation.  The man page was pretty clear (read it after
slogging through source/traces, oh well, educational;) that -ESRCH was
expected, but I wanted to be sure about tracee state thereafter.

-Mike

