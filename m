Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaE0Qdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbaE0Qde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:33:34 -0400
Date: Tue, 27 May 2014 18:33:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] perf tools: consider header files outside perf directory
 in tags target
Message-ID: <20140527163325.GA26128@krava.brq.redhat.com>
References: <1401207822-8695-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401207822-8695-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 06:23:42PM +0200, Sebastian Andrzej Siewior wrote:
> This fixes lookups like "vi -t event_format"
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  tools/perf/Makefile.perf | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 895edd3..8148992 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -812,15 +812,15 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
>  
>  TAGS:
>  	$(RM) TAGS
> -	$(FIND) . -name '*.[hcS]' -print | xargs etags -a
> +	$(FIND) . ../lib/traceevent -name '*.[hcS]' -print | xargs etags -a ../../include/uapi/linux/perf_event.h
>  
>  tags:
>  	$(RM) tags
> -	$(FIND) . -name '*.[hcS]' -print | xargs ctags -a
> +	$(FIND) . ../lib/traceevent -name '*.[hcS]' -print | xargs ctags -a ../../include/uapi/linux/perf_event.h
>  
>  cscope:
>  	$(RM) cscope*
> -	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
> +	$(FIND) . ../lib/traceevent -name '*.[hcS]' -print | xargs cscope -b ../../include/uapi/linux/perf_event.h

while you are at it, could you please also include:
  ../lib/api/
  ../lib/symbol/

also given that same paths are used on multiple places,
please put them into variable

thanks,
jirka
