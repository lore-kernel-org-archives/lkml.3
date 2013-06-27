Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3F0LrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:47:14 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:55105 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3F0LrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:47:13 -0400
Date: Thu, 27 Jun 2013 13:47:08 +0200
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix output directory of Documentation/
Message-ID: <20130627114708.GF21788@rric.localhost>
References: <1367865614-30876-1-git-send-email-rric@kernel.org>
 <20130620134154.GC1083@krava.brq.redhat.com>
 <20130620152603.GC4767@ghostprotocols.net>
 <20130621124939.GB11635@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621124939.GB11635@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.06.13 14:50:20, Robert Richter wrote:
> On 20.06.13 12:26:03, Arnaldo Carvalho de Melo wrote:
> > Robert, so this one is with:
> > 
> > 	cd tools/perf
> > 	make install-doc
> > 
> > I tested with:
> > 
> > 	make -C tools/perf O=/tmp/build/perf install-doc
> > 
> > and it works, so it is just the in tree build that fails.
> 
> The patch below fixes this. Thanks for reporting.

Arnaldo, I noticed this fix is not yet merge with:

 79e10cb perf tools: Fix output directory of Documentation/

-Robert

> diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> index 1368e88..5a37a7c 100644
> --- a/tools/perf/Documentation/Makefile
> +++ b/tools/perf/Documentation/Makefile
> @@ -271,7 +271,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
>  
>  $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
>  	$(QUIET_XMLTO)$(RM) $@ && \
> -	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
> +	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
>  
>  $(OUTPUT)%.xml : %.txt
>  	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
