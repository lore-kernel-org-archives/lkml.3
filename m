Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3AMInp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 03:43:45 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42773 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3AMIno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 03:43:44 -0500
Subject: Re: [PATCH 07/10] perf sort: Check return value of strdup()
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20130111051745.GF3054@ghostprotocols.net>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
	 <1356599507-14226-8-git-send-email-namhyung@kernel.org>
	 <20130111051745.GF3054@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jan 2013 17:43:37 +0900
Message-ID: <1358066617.1594.10.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

2013-01-11 (금), 02:17 -0300, Arnaldo Carvalho de Melo:
> Em Thu, Dec 27, 2012 at 06:11:44PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > When setup_sorting() is called, 'str' is passed to strtok_r() but it's
> > not checked to have a valid pointer.  As strtok_r() accepts NULL
> > pointer on a first argument and use the third argument in that case,
> > it can cause a trouble since our third argument, tmp, is not
> > initialized.
> 
> Ok, but calling exit from here? Better to check it at the callers and
> propagate the error, letting things like TUI/gui exit routines to
> execute.

That's fine to me too, but currently setup_sorting() exits through
usage_with_options() if sort_dimension__add() fails and I followed the
convention here.  Making it to return will require changes to every
callsites of the function.

If you think it's better to change, I can do it as well.

Thanks,
Namhyung


