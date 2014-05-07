Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaEGQoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:44:17 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51819 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaEGQoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:44:14 -0400
Date: Wed, 7 May 2014 18:44:07 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140507164407.GG32718@rric.localhost>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
 <20140506185359.GE25013@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506185359.GE25013@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.05.14 20:53:59, Borislav Petkov wrote:
> On Tue, May 06, 2014 at 02:39:07PM +0200, Robert Richter wrote:
> > Events could also be shared transparently. This means, if there is
> > already an event running with the same attr, it could be reused. Not
> > sure if this makes sense much and is also feasible. Most events are
> > opened with writable buffers and thus can not be shared anyway.
> 
> Well, this is simple: sharing events implicitly says they're read-only -
> you can't share them otherwise. If you want the buffers to be writable,
> then the events cannot be shared.
> 
> I think this is nicely simple.

With transparently I mean that the process even does not know that the
same event is already running by another process. The kernel detects
this and maps the request to that event and buffer. Of course the
event's buffer must be at least readonly to be shared for this.

This could be a mechanism to connect to persistent events. The kernel
detects by type and attr that the requested event is already running
persistent and maps to it.

But at the moment persistent events can only be shared using

 attr.type = PERF_TYPE_PERSISTENT
 attr.config = id

So the above is more an alternative to connect to persistent events
and the question is, which one to use. Presumable the easiest first,
which is the current implementation.

-Robert
