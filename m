Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab3FXKWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:22:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47569 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3FXKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:22:07 -0400
Date: Mon, 24 Jun 2013 12:22:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130624102200.GR28407@twins.programming.kicks-ass.net>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 06:42:26PM +0200, Robert Richter wrote:
> Note that perf tools need to support the 'attr<num>' syntax that is
> added in a separate patch set. With it we are able to run perf tool
> commands to read persistent events, e.g.:

where is this patch? I can't find it.

I also find attr<num>:<bit> a bit weird. So far we've used
<perf_event_attr::fieldname>:<bits>, so while initializing anonymous
unions is a bit difficult with 'older' GCCs and we cannot actually do:

struct perf_event_attr {
	...
	union {
		u64 flags;
		u64 disabled : 1,
		    ...
		    __reserved_1 : X;
	}
	...
};

We could fake it in userspace by allowing things like: flags:23. It
would not be a much worse hack than attr<num>:<bit> I suppose.

