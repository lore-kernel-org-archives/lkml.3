Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3JJGn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:43:26 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49805 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JJGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:43:25 -0400
Date: Thu, 10 Oct 2013 08:43:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 28/52] tools/perf/build: Split out feature check:
 'on-exit'
Message-ID: <20131010064321.GB10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-29-git-send-email-mingo@kernel.org>
 <87wqlliri7.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqlliri7.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> > diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
> > new file mode 100644
> > index 0000000..473f1de
> > --- /dev/null
> > +++ b/tools/perf/config/feature-checks/test-on-exit.c
> > @@ -0,0 +1,6 @@
> > +#include <stdio.h>
> > +
> > +int main(void)
> > +{
> > +	return on_exit(NULL, NULL);
> > +}
> 
> Just a nitpick.  The manpage says the on_exit() requires <stdlib.h> 
> header rather than <stdio.h> and _BSD_SOURCE or _SVID_SOURCE defined. So 
> I think we can define _GNU_SOURCE before the header file or pass it 
> through make command line - it'd probably be better for synthesized 
> test-all.c checking.

This was inherited from the original feature-tests.mak:

define SOURCE_ON_EXIT
#include <stdio.h>

int main(void)
{
        return on_exit(NULL, NULL);
}
endef

So it appears to work in practice, but yes, I agree that this could be 
cleaned up.

Thanks,

	Ingo
