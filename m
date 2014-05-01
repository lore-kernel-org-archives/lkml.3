Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaEAUpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:45:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:37871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaEAUpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:45:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,966,1389772800"; 
   d="scan'208";a="426524915"
From: Andi Kleen <andi@firstfloor.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
References: <cover.1398958771.git.jpoimboe@redhat.com>
Date: Thu, 01 May 2014 13:45:33 -0700
In-Reply-To: <cover.1398958771.git.jpoimboe@redhat.com> (Josh Poimboeuf's
	message of "Thu, 1 May 2014 10:52:04 -0500")
Message-ID: <87ppjxcjo2.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Poimboeuf <jpoimboe@redhat.com> writes:
>
> kpatch checks the backtraces of all tasks in stop_machine() to ensure
> that no instances of the old function are running when the new function
> is applied.

How does that work for tail calls? 

      call foo
foo:
      ...
      jmp bar

bar:
      ... code executing ...

When you backtrace you will see foo, but you are running in bar.

Note that tail calls can be indirect, so they cannot be resolved
statically.

CONFIG_DEBUG_INFO usually disables tail calls, but not supporting 
it would seem like a large limitation, as the cost can be high.

It wouldn't surprise me if there are some similar special cases that
can even happen with them disabled.

In theory you could read LBRs, but even that may miss some extreme
cases.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
