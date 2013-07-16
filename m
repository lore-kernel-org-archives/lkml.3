Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3GPN6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:58:51 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:40065 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932484Ab3GPN6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:58:49 -0400
Date: Tue, 16 Jul 2013 09:59:35 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>,
        xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
In-Reply-To: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1307160956370.15153@pianoman.cluster.toy>
References: <20130716015305.GB30569@redhat.com> <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com> <20130716023847.GA31481@redhat.com> <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020207.51E55196.0190,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Linus Torvalds wrote:

> On Mon, Jul 15, 2013 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
> 
> > Interestingly, the 'soft lockups' I was
> > seeing all the time on that box seem to have gone into hiding.
> 
> Honestly, I'm somewhat inclined to blame the whole perf situation, and
> saying that we hopefully got that fixed. In between the silly do_div()
> buglets and all the indications that the time was spent in nmi
> handlers, I'd be willing to just ignore them as false positives
> brought on by the whole switch to the perf irq..

Did the perf soft lockups go away with 3.11-rc1?

734df5ab549ca44f40de0f07af1c8803856dfb18 finally got committed,
and it fixes a major long-standing perf-related NMI soft lockup bug I 
found when fuzzing.

Vince
