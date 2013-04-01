Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab3DAVLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173Ab3DAVLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:11:17 -0400
Date: Mon, 1 Apr 2013 23:09:47 +0200
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
Subject: Re: [PATCH 01/27] perf tools: Add automated make test suite
Message-ID: <20130401210947.GC20670@krava.redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
 <1364843930-17974-2-git-send-email-jolsa@redhat.com>
 <20130401195318.GB5744@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401195318.GB5744@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:53:18PM +0200, Sam Ravnborg wrote:

SNIP

> > +
> > +MAKE_DEBUG          := DEBUG=1
> > +MAKE_NO_LIBPERL     := NO_LIBPERL=1
> 
> Why all these ugly UPPERCASE names?
> In kbuild files the unwritten rule is that variables
> with global scope are upper-case.
> And variables with local scope are lower case.
> 
> You can find many examples where this is not followed - but this
> is the general approach.

ok, for some reason I'm used to use capitals for makefile
variables ;)


> 
> > +MAKE_MINIMAL        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1 NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1 NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
> 
> Keeping lines less than 120 chars long is good.
> Some people swer to 80 chars.

ok

> 
> > +RUN := \
> > +	MAKE_PURE \
> > +	MAKE_DEBUG \
> > +	MAKE_NO_LIBPERL \
> 
> RUN += MAKE_PURE
> RUN += MAKE_DEBUG
> RUN += MAKE_NO_LIBPERL
> 
> Is so much more readable.
> As a general rule - use \
> to continue lines only when you really have to.

ok

thanks,
jirka
