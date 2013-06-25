Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3FYIqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:46:10 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51273 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3FYIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:46:07 -0400
Date: Tue, 25 Jun 2013 10:46:00 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 02/14] perf: Add persistent events
Message-ID: <20130625084600.GB21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-3-git-send-email-rric@kernel.org>
 <20130624092807.GM28407@twins.programming.kicks-ass.net>
 <20130624192404.GA24827@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624192404.GA24827@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.13 21:24:04, Borislav Petkov wrote:
> On Mon, Jun 24, 2013 at 11:28:07AM +0200, Peter Zijlstra wrote:
> > I find this patch incomplete for its asymmetric; there a dec, but not an
> > implied inc.
> 
> There's one in perf_mmap_open.
> 
> Basically the idea was to pull up the ->mmap_count decrement (haha,
> sounds like excrement :-)) and not deallocate the ring buffers for a
> persistent event.

The asymmetry comes from rb_alloc() in add_persistent_event_on_cpu()
which is usually implemented in the mmap functions. We might better
improve functions to attach/detach events and buffers for more
symmetric code.

-Robert
