Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaCNUUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:20:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbaCNUUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:20:00 -0400
Date: Fri, 14 Mar 2014 16:19:43 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        a.p.zijlstra@chello.nl
Subject: perf top breakage.
Message-ID: <20140314201943.GB6633@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sasha.levin@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	a.p.zijlstra@chello.nl
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 12:41:41PM -0700, Linus Torvalds wrote:
 > On Fri, Mar 14, 2014 at 12:32 PM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > Hmm. Do you have CONFIG_KALLSYMS enabled?
 > 
 > Just to clarify. KALLSYMS is required to figure out the symbol
 > addresses on a kaslr system. There's no way to look them up in a
 > System.map file or the object file, since the addresses aren't going
 > to match.
 > 
 > Your symptoms really sound like you might not have KALLSYMS enabled.
 > 
 > I wonder if we have a "select KALLSYMS" as part of RANDOMIZE_BASE,
 > since you need it for debug messages too (random hex numbers aren't
 > too useful ;)

Ok, I've figured out the cause. kaslr is a red herring.

This works :

# su - root
$ tools/perf/perf top

This doesn't:

# sudo tools/perf/perf top

Neither does:

# su - root
$ sudo tools/perf/perf top

So somehow sudo+perf broke. fun.

The 3.13 binary works regardless of how I call it.

	Dave

