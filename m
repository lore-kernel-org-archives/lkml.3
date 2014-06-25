Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaFYBEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:04:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:33889 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaFYBEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:04:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Howard Cochran <hcochran@lexmark.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: event-parse.c:  Fix a risk for doing free on uninitialized pointer
References: <1403608150-13037-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 25 Jun 2014 10:04:47 +0900
In-Reply-To: <1403608150-13037-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Tue, 24 Jun 2014 13:09:10 +0200")
Message-ID: <87oaxh6bps.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On Tue, 24 Jun 2014 13:09:10 +0200, Rickard Strandqvist wrote:
> Fix a risk of doing free on an uninitialized pointer.
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/lib/traceevent/event-parse.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index b83184f..857675e 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -2390,7 +2390,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
>  {
>  	struct print_arg *field;
>  	enum event_type type;
> -	char *token;
> +	char *token = NULL;
>  
>  	memset(arg, 0, sizeof(*arg));
>  	arg->type = PRINT_FLAGS;
> @@ -2443,7 +2443,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
>  {
>  	struct print_arg *field;
>  	enum event_type type;
> -	char *token;
> +	char *token = NULL;
>  
>  	memset(arg, 0, sizeof(*arg));
>  	arg->type = PRINT_SYMBOL;
> @@ -2482,7 +2482,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
>  {
>  	struct print_arg *field;
>  	enum event_type type;
> -	char *token;
> +	char *token = NULL;
>  
>  	memset(arg, 0, sizeof(*arg));
>  	arg->type = PRINT_HEX;
