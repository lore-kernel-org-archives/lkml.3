Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbaD2PeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:34:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44940 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaD2PeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:34:07 -0400
Date: Tue, 29 Apr 2014 17:34:01 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/16] perf, mmap: Factor out perf_get_fd()
Message-ID: <20140429153401.GK32718@rric.localhost>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <1396883078-25320-5-git-send-email-jean.pihet@linaro.org>
 <20140422142759.GM11182@twins.programming.kicks-ass.net>
 <20140425135413.GE32718@rric.localhost>
 <20140425144301.GI11096@twins.programming.kicks-ass.net>
 <20140425145205.GV13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425145205.GV13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.04.14 16:52:05, Peter Zijlstra wrote:
> But no, I don't think that helps, its still true that the moment you get
> a fd another thread can immediately close(). That would drop the last
> ref and free it, meanwhile perf_event_open() is happily poking at it.
> 
> Now I think you could cure this by adding an extra ref before calling
> your perf_get_fd() and dropping that extra ref at the end, where we used
> to have fd_install().

Yes, right. I have a solution now which increments the event's ref
count before creating the file descriptor using try_get_event()/
put_event().

The patch also does not remove get_unused_fd_flags() and the err_fd
error handler.

Have an update already of a rebase version but still need to test it.

Would it be ok to split the patch set and send in a first step only
the first 4 patches that refactor the perf mmap code?

Thanks,

-Robert
