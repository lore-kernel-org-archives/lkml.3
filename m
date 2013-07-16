Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3GPPCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab3GPPCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:02:54 -0400
Date: Tue, 16 Jul 2013 11:02:17 -0400
From: Dave Jones <davej@redhat.com>
To: Vince Weaver <vince@deater.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>,
        xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716150217.GA825@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vince Weaver <vince@deater.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>,
	xfs@oss.sgi.com
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
 <alpine.DEB.2.02.1307160956370.15153@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307160956370.15153@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:59:35AM -0400, Vince Weaver wrote:
 > On Mon, 15 Jul 2013, Linus Torvalds wrote:
 > 
 > > On Mon, Jul 15, 2013 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
 > > 
 > > > Interestingly, the 'soft lockups' I was
 > > > seeing all the time on that box seem to have gone into hiding.
 > > 
 > > Honestly, I'm somewhat inclined to blame the whole perf situation, and
 > > saying that we hopefully got that fixed. In between the silly do_div()
 > > buglets and all the indications that the time was spent in nmi
 > > handlers, I'd be willing to just ignore them as false positives
 > > brought on by the whole switch to the perf irq..
 > 
 > Did the perf soft lockups go away with 3.11-rc1?
 > 
 > 734df5ab549ca44f40de0f07af1c8803856dfb18 finally got committed,
 > and it fixes a major long-standing perf-related NMI soft lockup bug I 
 > found when fuzzing.

That could be it. I never got around to trying that commit standalone
when you first pointed it out.

thanks,

	Dave
