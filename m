Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaINJty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:49:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:41983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaINJtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:49:52 -0400
Date: Sun, 14 Sep 2014 11:41:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@cloudius-systems.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Jan Stancek <jstancek@redhat.com>
Subject: Re: [BUG] perf tools: Demangle kernel and kernel module symbols too
Message-ID: <20140914094112.GT346@worktop.programming.kicks-ass.net>
References: <20140906184631.GA6059@krava.brq.redhat.com>
 <5413BB4D.10606@cloudius-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5413BB4D.10606@cloudius-systems.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 06:34:37AM +0300, Avi Kivity wrote:

> It's not a simple matter of updating the test: the demangler interprets name
> beginning with __vt as C++ mangles names, which of course they aren't.

Oh, that'll give cute 'problems' in a mixed C/C++ project that just
happens to have __vt names in. Now of course I'm aware that C/C++
'reserve' the __ prefix, which I suppose that makes it less likely in
practise.

> The only way I see to proceed is to make the demangling optional, default
> off.

Seems like a good way out, we could think about adding a language
heuristic that tries and guess the target language and auto enables when
it guesses C++, but that needs to have overrides as well.
