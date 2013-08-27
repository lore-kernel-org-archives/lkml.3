Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3H0MiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:38:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab3H0MiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:38:24 -0400
Date: Tue, 27 Aug 2013 14:38:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/12] perf, persistent: Add persistent events
Message-ID: <20130827123827.GB5855@x1.alien8.de>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <20130824093826.GB28383@pd.tnic>
 <20130827122721.GF15884@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130827122721.GF15884@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:27:21PM +0200, Robert Richter wrote:
> > > There are ioctl functions to control persistent events that can be
> > > used to detach or attach an event to or from a process. The
> > > PERF_EVENT_IOC_DETACH ioctl call makes an event persistent.
> > 
> > Yeah, we probably want to abstract this a step further by allowing
> > to attach/detach fds to/from events. Then "persistent" is only one
> > incarnation of us always detaching from the event during its lifetime.
> > 
> > If we close an event while it is attached, it gets destroyed - i.e.,
> > current functionality, etc. See the other thread.
> 
> I don't know what you mean here exactly, please explain.

Basically that detaching an event shouldn't make it persistent
explicitly - it simply continues running in the background. When we
reattach to it and die with the event attached, then it gets destroyed
too.

Which means, we can have arbitrary life periods of events, persistency
being only a special case of it.

IOW, as long as an event is detached in the background, it counts.
When something attaches to it and that something exits, the event gets
destroyed too, as part of the process teardown.

And this is probably the most generic way to look at it.

-- 
Regards/Gruss,
Boris.
