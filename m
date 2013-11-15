Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab3KOMJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:09:09 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:63356 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3KOMJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:09:01 -0500
MIME-Version: 1.0
In-Reply-To: <1384486702-6736-1-git-send-email-dsahern@gmail.com>
References: <1384486702-6736-1-git-send-email-dsahern@gmail.com>
Date: Fri, 15 Nov 2013 13:08:59 +0100
Message-ID: <CAFTL4hzam5NSZPKvh0yxXjZPmPLPGwQ5aMiuJeONUa1nbXWpUw@mail.gmail.com>
Subject: Re: [PATCH] perf script: Print callchains and symbols if they exist
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/15 David Ahern <dsahern@gmail.com>:
> The intent of perf-script is to dump the events and information
> in the file. H/W, S/W and raw events all dump callchains if they
> are present; might as well make that the default for tracepoints
> too.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/builtin-script.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index baf17989a216..6f96f8414047 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -99,7 +99,9 @@ static struct {
>
>                 .fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
>                                   PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
> -                                 PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
> +                                 PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE |
> +                             PERF_OUTPUT_IP | PERF_OUTPUT_SYM |
> +                                 PERF_OUTPUT_DSO,


Right it's important to dump callchains on tracepoint by default.

DSO are not important though because tracepoints always happen in the
kernel anyway. Although there is uprobes now hmm....

Same for ip/sym, most of the time the ip where the event happened is
not that relevant because it's often called from a same helper.
If SYM is required to dump callchains, I suggest that we only enable
SYM when callchains are present. Or have a seperate PERF_OUTPOUT
symbol for that may be.

Thanks.
