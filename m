Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3KUIPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:15:46 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751833Ab3KUIPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:15:44 -0500
From: Richard Weinberger <richard@nod.at>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: mmotm 2013-11-20-16-13 uploaded (arch/um/kernel/sysrq.c)
Date: Thu, 21 Nov 2013 09:15:38 +0100
Message-ID: <4049956.nmFOrVzcI3@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <528D5935.6070907@infradead.org>
References: <20131121001408.17DC85A41C6@corp2gmr1-2.hot.corp.google.com> <528D5935.6070907@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 20. November 2013, 16:52:05 schrieb Randy Dunlap:
> On 11/20/13 16:14, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2013-11-20-16-13 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> 
> on i386:
> (with um i386 defconfig)
> 
> arch/um/kernel/sysrq.c:22:13: error: expected identifier or '(' before 'do'
> um/kernel/sysrq.c:22:13: error: expected identifier or '(' before 'while'
> 
> 
> so sysrq.c is picking up <linux/stacktrace.h> somehow and not liking it.

um/kernel/sysrq.c has
static void print_stack_trace(unsigned long *sp, unsigned long bp)
and linux/stracktrace.h has
# define print_stack_trace(trace, spaces)               do { } while (0)

So um's print_stack_trace needs to be renamed.
Thanks a lot for reporting!

Thanks,
//richard

