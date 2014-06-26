Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaFZJvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:51:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40693 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbaFZJvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:51:07 -0400
Date: Thu, 26 Jun 2014 11:51:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140626095101.GA1284@pd.tnic>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625194254.GC18773@kernel.org>
 <20140625201147.GB13845@pd.tnic>
 <20140626073605.GB1177@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140626073605.GB1177@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:36:05AM +0200, Jiri Olsa wrote:
> this functionality is inside evlist/evsel/target(...) objects

Yep, and that functionality depends on generic stuff which we're trying to
export first. :-)

> the ras daemon is not in tree yet is it? cant find it..

Here's an old version: http://thread.gmane.org/gmane.linux.kernel/1090275

> I think we should librarize only stuff we will share.

You sound just like acme! :-) But yeah, this is what he said at the time
and this is what we want to do - we don't want to do more work than
necessary after all :-)

> Whats the plan about the ras daemon (if I did not overlook it) to be
> put into tools?

I'd say no initially, after the kvmtool explosion last time. Which is
still ok I guess.

If it remains out of tree, we will probably have some issues if the
exported pieces change and we'll have to readjust the external code
which depends on it. We'll see.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
