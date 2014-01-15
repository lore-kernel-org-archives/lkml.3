Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaAOSjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:39:05 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:63700 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaAOSjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:39:02 -0500
Date: Wed, 15 Jan 2014 15:38:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf probe: Build error with missing libraries
Message-ID: <20140115183856.GD9750@ghostprotocols.net>
References: <20140113180400.GD5318@ghostprotocols.net>
 <20140113181458.GE5318@ghostprotocols.net>
 <52D495D1.5080505@hitachi.com>
 <20140114130907.GA29798@ghostprotocols.net>
 <87sisq9fa5.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sisq9fa5.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 15, 2014 at 10:58:58AM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Tue, 14 Jan 2014 10:09:07 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Jan 14, 2014 at 10:41:37AM +0900, Masami Hiramatsu escreveu:
> >> (2014/01/14 3:14), Arnaldo Carvalho de Melo wrote:
> >> > Jiri, this is something else for the give-me-more-ponies list for
> >> > tests/make: build it on freshly provisioned systems with multiple mixes
> >> > of devel packages installed ;-)
> >  
> >> I think we can change makefile to get some combinations of config options
> >> when building perf tools.
> >
> > This is what:
> >
> >  make -C tools/perf -f tests/make
> >
> > does, and we use it already, many config combos are tested, but that
> > kinda expects that all optional devel libs be installed.
> 
> I've been thinking that the above should look like below.
> 
>   make build-test (-C tools/perf)
> 
> 
> Maybe something like this?

Haven't tested, but I think it is worth to make this a shortcut, care to
test (if not yet) and resubmit with proper S-O-B, etc?

- Arnaldo
 
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index eefb9fb0c02f..e110c2a2ade1 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -75,6 +75,12 @@ clean:
>  	$(make)
>  
>  #
> +# The build-test target is not really parallel, don't print the jobs info:
> +#
> +build-test:
> +	@$(MAKE) -f tests/make --no-print-directory
> +
> +#
>  # All other targets get passed through:
>  #
>  %:
> 
> -- 
> Thanks,
> Namhyung
