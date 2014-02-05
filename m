Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaBEBKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:10:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44983 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaBEBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:10:33 -0500
Date: Wed, 5 Feb 2014 01:10:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
 trace_sched_process_exec
Message-ID: <20140205011028.GM10323@ZenIV.linux.org.uk>
References: <20140204120500.041b5175@gandalf.local.home>
 <CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
 <20140204182852.43ffa442@gandalf.local.home>
 <20140204184208.6f4f22a8@gandalf.local.home>
 <CA+55aFyTC1UGvRgH5vASh-C3M+GqHPMNGsUq3Q1MuynzkiSaEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyTC1UGvRgH5vASh-C3M+GqHPMNGsUq3Q1MuynzkiSaEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 04:57:31PM -0800, Linus Torvalds wrote:
> On Tue, Feb 4, 2014 at 3:42 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > New version that moves all the ugliness into a static inline helper
> > function.
> 
> Ok, that's better, but I really think we should just use "getname()"
> and "putname()".

Umm...  Interactions with aushit might be interesting.  It hooks into
getname() and putname(); I'm not up to doing analysis right now (13 hours
of nearly non-stop {R,Grep}TFS today already and I'm ears-deep in
looking through locking implications of Miklos' stuff at the moment ;-/),
but it's worth looking into; there may be dragons.
