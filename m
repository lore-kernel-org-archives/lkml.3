Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab3DATxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:53:20 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:19097 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439Ab3DATxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:53:19 -0400
Date: Mon, 1 Apr 2013 21:53:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/27] perf tools: Add automated make test suite
Message-ID: <20130401195318.GB5744@merkur.ravnborg.org>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com> <1364843930-17974-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364843930-17974-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:18:24PM +0200, Jiri Olsa wrote:
> Adding automatd test for testing the build process.
> To run it you needto be in perf directory or specify
> one with PERF variable. It's also possible to specify
> optional Makefile to test via MK variable.
> 
> Whole suite is executed twice, the second time with
> O=/tmp/xxx option added.
> 
> To run the whole suite:
>   $ make -f tests/make
>   MAKE_PURE: cd . && make -f Makefile
>   TEST: test -x ./perf
>   MAKE_DEBUG: cd . && make -f Makefile DEBUG=1
>   TEST: test -x ./perf
>   ...
> 
> You see command line for 'MAKE_PURE' test right away,
> and the output is stored into MAKE_PURE file.
> 
> To run simple test:
>   $ make -f tests/make MAKE_DEBUG
>   MAKE_DEBUG: cd . && make -f Makefile DEBUG=1
>   TEST: test -x ./perf
> 
> At this moment tests checks for succesfull build
> and for existence of several built files. Additional
> after-build checks could be added.

Some nit-picks.
I did not try to find out how this works.

> +
> +MAKE_DEBUG          := DEBUG=1
> +MAKE_NO_LIBPERL     := NO_LIBPERL=1

Why all these ugly UPPERCASE names?
In kbuild files the unwritten rule is that variables
with global scope are upper-case.
And variables with local scope are lower case.

You can find many examples where this is not followed - but this
is the general approach.

> +MAKE_MINIMAL        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1 NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1 NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1

Keeping lines less than 120 chars long is good.
Some people swer to 80 chars.

> +RUN := \
> +	MAKE_PURE \
> +	MAKE_DEBUG \
> +	MAKE_NO_LIBPERL \

RUN += MAKE_PURE
RUN += MAKE_DEBUG
RUN += MAKE_NO_LIBPERL

Is so much more readable.
As a general rule - use \
to continue lines only when you really have to.

	Sam
