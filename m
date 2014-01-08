Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaAHM6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:58:05 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:45666 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaAHM6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:58:03 -0500
Date: Wed, 8 Jan 2014 09:57:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 03/28] perf tools: Remove symbol_conf.use_callchain check
Message-ID: <20140108125755.GC15464@ghostprotocols.net>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
 <1389170793-21926-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389170793-21926-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 08, 2014 at 05:46:08PM +0900, Namhyung Kim escreveu:
> The machine__resolve_callchain() is called only if symbol_conf.
> use_callchain is set so no need to check it again.

Not really it may be called with use_callchain not set, I'm checking if
the logic is needed (doesn't look like).

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/machine.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index a98538dc465a..4dcc89490858 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1313,8 +1313,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  				*root_al = al;
>  				callchain_cursor_reset(&callchain_cursor);
>  			}
> -			if (!symbol_conf.use_callchain)
> -				break;
>  		}
>  
>  		err = callchain_cursor_append(&callchain_cursor,
> -- 
> 1.7.11.7
