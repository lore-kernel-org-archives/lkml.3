Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaFEJ6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:58:42 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:40116 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaFEJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:58:41 -0400
Date: Thu, 5 Jun 2014 11:58:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Differentiate exec() and non-exec() comm events
Message-ID: <20140605095836.GB23641@gmail.com>
References: <1401266704-22572-1-git-send-email-adrian.hunter@intel.com>
 <20140528085538.GR11096@twins.programming.kicks-ass.net>
 <5385A7A9.80702@intel.com>
 <20140528095308.GS11096@twins.programming.kicks-ass.net>
 <20140605095659.GA23641@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605095659.GA23641@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > Nah, I'll frob it. Thanks!
> 
> FYI, this patch breaks pretty much every non-x86 architecture:
> 
> /home/mingo/tip/fs/exec.c: In function 'setup_new_exec':
> /home/mingo/tip/fs/exec.c:1113: error: implicit declaration of function 'perf_event_exec'
> make[2]: *** [fs/exec.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [fs] Error 2
> make[1]: *** Waiting for unfinished jobs....

Sorry, it was another patch that broke things:

Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed May 21 17:32:19 2014 +0200

    perf: Fix perf_event_comm() vs. exec() assumption

Thanks,

	Ingo
