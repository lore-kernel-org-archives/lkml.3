Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3KZMKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:10:37 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:54494 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3KZMKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:10:32 -0500
Date: Tue, 26 Nov 2013 09:10:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: remove lock_depth from trace_entry
Message-ID: <20131126121026.GD27323@ghostprotocols.net>
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
 <20131022103223.GA29489@stfomichev-desktop>
 <20131125182139.GD20168@ghostprotocols.net>
 <20131126110536.GC3388@stfomichev-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126110536.GC3388@stfomichev-desktop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 26, 2013 at 03:05:36PM +0400, Stanislav Fomichev escreveu:
> > This makes the new tool stop processing old files, can you try the patch
> > attached instead?

> I see two downsides to your approach:

Huh?

> 1) with your patch I'm now required to run 'perf timechart record' and
> 'perf timechart' on the same machine (otherwise, on the 'perf timechart'

No, it should not be required to do that, when processing perf.data
files the tracepoint info should come from perf.data, recorded there at
the 'perf record' time, right? I'm assuming this, will check.

> machine we may have wrong fields definitions that don't match perf.data).
> Currently, it's possible to use 'perf timechart record' on the target and do
> 'perf timechart' on the host (at least I do it this way).

If it is, my assumption is correct, as the evlist must be populated from
perf.data, or is it this way and _only_ when it goes to look at fields
is that it looks at the local machine? Doesn't make sense.

> 2) only root can run 'perf timechart' now (because of permissions on
> /sys/kernel/debug).

Se above, if before this patch the format_field info was obtained from
the perf.data file, why should it now get it from the local machine?
 
> Maybe we can we make some simple version check against the perf.data file and
> just refuse to process the old one (not sure if it's possible)?
> 
> > Its only compile tested tho.
> Ok, I'll test it if we are fine with the new limitations.

Please try. There should be no limitations.

- Arnaldo
