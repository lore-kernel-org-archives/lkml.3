Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab3DAVIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:08:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872Ab3DAVIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:08:48 -0400
Date: Mon, 1 Apr 2013 23:07:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/27] perf tools: Move arch check into config/Makefile
Message-ID: <20130401210733.GB20670@krava.redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
 <1364843930-17974-4-git-send-email-jolsa@redhat.com>
 <20130401195446.GC5744@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401195446.GC5744@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:54:46PM +0200, Sam Ravnborg wrote:

SNIP

> > diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> > new file mode 100644
> > index 0000000..fe317c2
> > --- /dev/null
> > +++ b/tools/perf/config/Makefile
> > @@ -0,0 +1,34 @@
> > +uname_M := $(shell uname -m 2>/dev/null || echo not)
> > +
> > +ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> > +				  -e s/arm.*/arm/ -e s/sa110/arm/ \
> > +				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
> > +				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> > +				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
> 
> this is shared with the top-level kernel Makefile.
> Could we find a way to share this?

right, maybe we could place it under some
scripts/ lib file, I'll check

thanks,
jirka
