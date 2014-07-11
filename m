Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaGKNXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:23:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:41009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaGKNXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:23:14 -0400
Date: Fri, 11 Jul 2014 15:23:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140711132309.GH20603@laptop.programming.kicks-ass.net>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405079782-8139-3-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> When task exits we close:
>   1) all events that are installed in task
>   2) all events owned by task (via file descriptor)
> 
> But we don't close children events of 2) events. Those children
> events stay until the child task exits and are useless with the
> parent being gone, because we have no way to get to values any
> more.
> 
> Plus if the event stays installed in task even with the owner task
> gone, it runs the perf callback any time the task forks, for no
> real reason.
> 
> Closing all children events events when the owner task of the
> parent event is closed.

So I _think_ the reason we didn't do this is because this is potentially
very expensive and keeping them around isn't too much bother, they'll
die eventually.

But I can't really remember. Ingo any recollections / opinions?
