Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaFZHg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaFZHgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:36:55 -0400
Date: Thu, 26 Jun 2014 09:36:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140626073605.GB1177@krava.brq.redhat.com>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625194254.GC18773@kernel.org>
 <20140625201147.GB13845@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625201147.GB13845@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:11:47PM +0200, Borislav Petkov wrote:
> On Wed, Jun 25, 2014 at 04:42:54PM -0300, Arnaldo Carvalho de Melo wrote:
> > Probably will come in a separate patchkit that is dependent on this,
> > but not strictly related?
> 
> Yeah, so roughly speaking, we want to carve out the code which opens and
> handles events in perf tool so that we can use it in other tools. In the

this functionality is inside evlist/evsel/target(...) objects

> particular example with the ras daemon, we want to be able to open a
> tracepoint in userspace and read from it.

the ras daemon is not in tree yet is it? cant find it..

> 
> We're doing this piecewise because perf tool changes too fast and I've
> done a full conversion patchset a couple of times already only to
> realize that it grows obsolete practically only days after sending it
> out. (Btw, for that it is all your fault, of course :-P). Which makes
> preparing a full patchset almost impossible.
> 
> Does this explanation make sense?

I think we should librarize only stuff we will share. Whats the plan
about the ras daemon (if I did not overlook it) to be put into tools?

thanks,
jirka
