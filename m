Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaIXCbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 22:31:13 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42872 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaIXCbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 22:31:10 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list:PERFORMANCE EVENT...)
Subject: Re: [PATCH] perf: Use ACCESS_ONCE() instead of volatile cast
References: <1411484109-10442-1-git-send-email-bobby.prani@gmail.com>
Date: Wed, 24 Sep 2014 11:31:07 +0900
In-Reply-To: <1411484109-10442-1-git-send-email-bobby.prani@gmail.com>
	(Pranith Kumar's message of "Tue, 23 Sep 2014 10:55:08 -0400")
Message-ID: <87zjdpkavo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Tue, 23 Sep 2014 10:55:08 -0400, Pranith Kumar wrote:
> Use ACCESS_ONCE() instead of the cast to volatile and read. This is just a style
> change which is reader friendly.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/session.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 8dd41ca..ffb4404 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -126,5 +126,5 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
>  
>  extern volatile int session_done;
>  
> -#define session_done()	(*(volatile int *)(&session_done))
> +#define session_done()	ACCESS_ONCE(session_done)
>  #endif /* __PERF_SESSION_H */
