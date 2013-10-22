Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3JVNGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:06:23 -0400
Received: from mail-gg0-f175.google.com ([209.85.161.175]:44747 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3JVNGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:06:21 -0400
Date: Tue, 22 Oct 2013 10:06:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/8] perf ui/progress: Add new helper functions for
 progress bar
Message-ID: <20131022130609.GB2124@ghostprotocols.net>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <1381468543-25334-3-git-send-email-namhyung@kernel.org>
 <20131021181324.GA3288@ghostprotocols.net>
 <87wql5jht3.fsf@danjae.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wql5jht3.fsf@danjae.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 22, 2013 at 06:12:40PM +0000, Namhyung Kim escreveu:
> On Mon, 21 Oct 2013 15:13:24 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Oct 11, 2013 at 02:15:37PM +0900, Namhyung Kim escreveu:
> >> From: Namhyung Kim <namhyung.kim@lge.com>

> >> Introduce ui_progress_setup() and ui_progress__advance() to separate
> >> out from the session logic.  It'll be used by other places in the
> >> upcoming patch.

> > Renaming this from 'perf_progress' to 'ui_progress', as the existing
> > method names implies, and also because this is not perf specific at all
> > :-)

> I'm not sure I understood you correctly.  You're talking about the
> struct perf_progree right?  We already have struct ui_progress for
> saving UI-specific function pointers.  Am I missing something?

Yes, the existing 'struct ui_progress' is not a per instance progress
bar class, but a set of operations that an specific UI sets for use
after some init progress, so it is misnamed, it should be, following
kernel examples, ui_progress_ops, and then ui_progress can be used for
what you called perf_progress.

I'll work on that, enjoy Edinburgh! :-)
 
- Arnaldo
