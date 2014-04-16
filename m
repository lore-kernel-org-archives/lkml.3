Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaDPTCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:02:21 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44439 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaDPTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:02:20 -0400
Message-ID: <534ED3B8.8050806@gmail.com>
Date: Wed, 16 Apr 2014 13:02:16 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf tools: Fix pmu object compilation error
References: <1397674818-27054-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397674818-27054-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/14, 1:00 PM, Jiri Olsa wrote:
> After applying some patches got another shadowing error:
>
>    CC       util/pmu.o
> util/pmu.c: In function ‘pmu_alias_terms’:
> util/pmu.c:287:35: error: declaration of ‘clone’ shadows a global declaration [-Werror=shadow]
>
> Renaming clone to cloned.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>   tools/perf/util/pmu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 00a7dcb..7a811eb 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -284,17 +284,17 @@ static int pmu_aliases(const char *name, struct list_head *head)
>   static int pmu_alias_terms(struct perf_pmu_alias *alias,
>   			   struct list_head *terms)
>   {
> -	struct parse_events_term *term, *clone;
> +	struct parse_events_term *term, *cloned;
>   	LIST_HEAD(list);
>   	int ret;
>
>   	list_for_each_entry(term, &alias->terms, list) {
> -		ret = parse_events_term__clone(&clone, term);
> +		ret = parse_events_term__clone(&cloned, term);
>   		if (ret) {
>   			parse_events__free_terms(&list);
>   			return ret;
>   		}
> -		list_add_tail(&clone->list, &list);
> +		list_add_tail(&cloned->list, &list);
>   	}
>   	list_splice(&list, terms);
>   	return 0;
>

Acked-by: David Ahern <dsahern@gmail.com>
