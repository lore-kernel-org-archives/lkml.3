Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaGKMCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaGKMCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:02:53 -0400
Date: Fri, 11 Jul 2014 14:02:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/5] perf: Fix tracepoint events permissions check
Message-ID: <20140711120238.GD21557@krava.redhat.com>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:56:17PM +0200, Jiri Olsa wrote:
> hi,
> sending fix for bug reported by Alexander Yarygin in here:
>   http://marc.info/?l=linux-kernel&m=140475133707722&w=2
> 
> The main problem was, that the event_init tracepoint callback
> checked permission of the 'current' task instead of the event
> owner task.
> 
> While this is ok for perf_event_open syscall check, it is wrong
> once event_init is called during fork to create child events.
> In this case the permission of the forked task is checked instead
> of the owner task of the parent event.

also available in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_perm

jirka
