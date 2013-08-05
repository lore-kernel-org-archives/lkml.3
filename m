Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3HEQcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:32:54 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:63438 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3HEQcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:32:52 -0400
Date: Mon, 5 Aug 2013 13:32:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
Message-ID: <20130805163244.GD3228@ghostprotocols.net>
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com>
 <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
 <20130731141732.GD3614@ghostprotocols.net>
 <51FD095F.8060208@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FD095F.8060208@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 03, 2013 at 04:45:03PM +0300, Adrian Hunter escreveu:
> On 31/07/2013 5:17 p.m., Arnaldo Carvalho de Melo wrote:
> >Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
> >>Using the information in mmap events, perf tools can read object
> >>code associated with sampled addresses.  A test is added that
> >>compares bytes read by perf with the same bytes read using
> >>objdump.

> >So this parses objdump output, and we also already have the annotation
> >logic that does that too, have you thought about having common routines
> >for these two cases?
 
> The annotation logic strips out the bytes (--no-show-raw) whereas
> the test extracts only the bytes, so they are not currently
> compatible.

Yeah, they are not, suggestion was to make it so at some point, as there
are many possible use cases that would use one, the other or both info.
 
> >I mean the disasm_line, ins, ins_ops, ins_operands classes, that now
> >lives in util/annotate.h but could be moved somewhere else,
> >disconnecting it as much as possible from annotation, because probably
> >there are more cool things we could do with that... :-)

> >We could certainly do it incrementally, merging your current patch
> >series and then working on sharing code on these two use cases, but
> >perhaps you can do it now?

> >What do you think?
 
> I expect replacing objdump with library calls will end up being the
> way forward.

Yes, and the recent work from Vitillo/Namhyung shows promise, but then
making it work with existing structs created from parsing the objdump
output shuld be ok.

At some point just dropping the parsing would then be transparent to
users of such structs.

But I should try it myself and see how it goes, to show what I mean :-)

- Arnaldo
