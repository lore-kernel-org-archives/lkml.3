Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3H1RdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab3H1RdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:33:15 -0400
Date: Wed, 28 Aug 2013 13:33:04 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vince Weaver <vince@deater.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828173304.GA6776@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vince Weaver <vince@deater.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130828034627.GA30596@redhat.com>
 <20130828103101.3f5679bc@gandalf.local.home>
 <20130828162321.GA14689@redhat.com>
 <alpine.DEB.2.02.1308281245370.6937@pianoman.cluster.toy>
 <20130828125701.1ca6ccd0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828125701.1ca6ccd0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 12:57:01PM -0400, Steven Rostedt wrote:

 > Dave, I'm assuming that trinidy does things as threads, such that it
 > may be two threads calling perf with the same descriptor, and if we
 > don't have the proper locks, things can get bad, right?
 > 
 
close. It does use as many processes as there are cpus (unless you override with -C)
but the fd's created by perf_event_open were only being used within the thread
that created them.  I just committed code to make it also reuse some shared ones
created from the parent process.

	Dave

