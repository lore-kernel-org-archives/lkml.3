Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3HWVBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:01:37 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:50986 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3HWVBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:01:36 -0400
Date: Fri, 23 Aug 2013 17:08:11 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Borislav Petkov <bp@alien8.de>
cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
In-Reply-To: <20130823193934.GB15521@pd.tnic>
Message-ID: <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
References: <1377180807-12758-1-git-send-email-rric@kernel.org> <1377180807-12758-13-git-send-email-rric@kernel.org> <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy> <20130823091128.GA19548@nazgul.tnic> <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost> <20130823113400.GA20310@nazgul.tnic> <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy> <20130823193934.GB15521@pd.tnic>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Borislav Petkov wrote:

> Maybe this makes it more understandable for you but this is beside the
> point.

Understandability doesn't matter?

> But I have to say the reversed thing above does sound confusing, now
> that I'm looking at the code. Actually, at the time we discussed this,
> my idea was to do it like this:
> 
> 1. we open a perf event and get its file descriptor
> 2. ioctl ATTACH to it so that it is attached to the process.
> 
> ... do some tracing and collecting and fiddling...
> 
> 3. ioctl DETACH from it so that it is "forked in the background" so to
> speak, very similar to a background job in the shell.

Would it make sense to actually fork a kernel thread that "owns" the 
event?  

The way it is now events can "get loose" if either the user
forgets about them or the tool that opened them crashes, and it's
impossible to kill these events with normal tools.  You possibly
wouldn't even know one was running (except you'd have one fewer
counter to work with) unless you poked around under /sys.

> 4. The rest of the code continues and deallocates the event *BUT* (and
> this is the key thing!) the counter/tracepoint remains operational in
> the kernel, running all the time.
> 
> 5. Now, after a certain point, you come back and ioctl ATTACH to this
> already opened event and read/collect its buffers again.

Vince
