Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab3GaORm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:17:42 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:61490 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3GaORl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:17:41 -0400
Date: Wed, 31 Jul 2013 11:17:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
Message-ID: <20130731141732.GD3614@ghostprotocols.net>
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com>
 <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
> Using the information in mmap events, perf tools can read object
> code associated with sampled addresses.  A test is added that
> compares bytes read by perf with the same bytes read using
> objdump.

So this parses objdump output, and we also already have the annotation
logic that does that too, have you thought about having common routines
for these two cases?

I mean the disasm_line, ins, ins_ops, ins_operands classes, that now
lives in util/annotate.h but could be moved somewhere else,
disconnecting it as much as possible from annotation, because probably
there are more cool things we could do with that... :-)

We could certainly do it incrementally, merging your current patch
series and then working on sharing code on these two use cases, but
perhaps you can do it now?

What do you think?

- Arnaldo
