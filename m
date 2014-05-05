Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbaEEM70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:59:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbaEEM7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:59:25 -0400
Date: Mon, 5 May 2014 14:59:22 +0200
From: Borislav Petkov <bp@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 10/10] perf tools: Move ACCESS_ONCE from perf.h header
Message-ID: <20140505125922.GD5667@pd.tnic>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
 <1399293219-8732-11-git-send-email-jolsa@kernel.org>
 <20140505124536.GN26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140505124536.GN26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 02:45:36PM +0200, Peter Zijlstra wrote:
> One could argue its part of the barrier muck, but sure.

Yeah, it might be prudent to put stuff like that in the most fitting
headers from the get-go as it causes trouble otherwise. And for
ACCESS_ONCE, in particular, we have tools/include/linux/compiler.h which
is a subset of include/linux/compiler.h so maybe it should go there.

Btw, why aren't we simply including include/linux/compiler.h
in tools/include/linux/compiler.h and be done with the whole
compiler-related stuff?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
