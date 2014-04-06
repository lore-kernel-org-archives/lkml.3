Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaDFMn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 08:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaDFMnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 08:43:55 -0400
Date: Sun, 6 Apr 2014 14:43:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix feature check for libdw dwarf unwind
Message-ID: <20140406124350.GH1164@krava.brq.redhat.com>
References: <20140403122350.GA15134@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403122350.GA15134@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 08:23:50AM -0400, Josh Boyer wrote:
> When the feature check for libdw dwarf unwind support was added with commit
> 45757895c7, it required LIBDW_DIR to be set before it would work.  However,
> commit 0a4f2b6a3ba implies that the libdw unwinder should be auto-detected
> from the installed libraries and not require LIBDW_DIR to be set.
> 
> The feature check is failing because FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind
> is only being set when LIBDW_DIR is specified.  This causes the feature test
> to be built without -ldw, which causes it to fail.  Fix this by moving the
> endif for the LIBDW_DIR check up.

hi,
Ramkumar was faster ;-)
http://marc.info/?l=linux-kernel&m=139587378628124&w=2

taking his change

thanks,
jirka

> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>  tools/perf/config/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index c23418225c2c..d3e3b7a7d979 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -65,10 +65,10 @@ ifndef NO_LIBELF
>    ifdef LIBDW_DIR
>      LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
>      LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
> +  endif
>  
>      FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
>      FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
> -  endif
>  endif
>  
>  # include ARCH specific config
> -- 
> 1.8.5.3
