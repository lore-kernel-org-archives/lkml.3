Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3JAOWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:22:00 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:33368 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3JAOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:21:59 -0400
Date: Tue, 1 Oct 2013 16:21:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data file
Message-ID: <20131001142154.GA31298@gmail.com>
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
 <20131001071646.GA20023@gmail.com>
 <524ACD2A.7040902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524ACD2A.7040902@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/1/13 1:16 AM, Ingo Molnar wrote:
> >Just a detail: it would be nice to make all the user facing messages in
> >tools/perf/util/header.c more specific and more structured. For example
> >prefixing it with 'perf header:' would be fine:
> >
> >	WARNING: perf/header: Data size is 0. Was the 'perf record' command properly terminated?
> >
> 
> Why put code references in the messages? The message is all on one
> line so grep finds it quickly for people working on the code.

I'd agree if this was some internal error that should never really trigger 
(so at most developers see it).

But if I understood it correctly this particular message could trigger for 
regular users of perf as well, of the perf record is terminated in some 
unusual fashion. Regular users might not have the perf code handy (and 
might not know about git grep either).

Thanks,

	Ingo
