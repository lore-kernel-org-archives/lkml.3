Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3J2IPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:15:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60636 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3J2IP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:15:28 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-92-526f6e9ebb83
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] perf timechart: group figures and add title with details
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-5-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 29 Oct 2013 17:15:26 +0900
In-Reply-To: <1382439412-23713-5-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Tue, 22 Oct 2013 14:56:50 +0400")
Message-ID: <87li1c5w81.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013 14:56:50 +0400, Stanislav Fomichev wrote:
> Add titles to figures so we can run SVG interactively in Firefox
> and check event details in the tooltips.
> This also aids exploring SVG with Inkscape because when user clicks on
> one part of logical figure, all parts are selected.
> It's also possible to read titles with Inkscape in the object details.

I have a trivial nitpick below, other than that

Acked-by: Namhyung Kim <namhyung@kernel.org>

>
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/builtin-timechart.c |  4 ++--
>  tools/perf/util/svghelper.c    | 54 +++++++++++++++++++++++++++++++++++++++++-
>  tools/perf/util/svghelper.h    |  3 ++-
>  3 files changed, 57 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index c7b30a8c7f3b..4d2ac96b75b1 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -798,9 +798,9 @@ static void draw_process_bars(void)
>  				if (sample->type == TYPE_RUNNING)
>  					svg_sample(Y, sample->cpu, sample->start_time, sample->end_time);

For consistency, wouldn't it be better renaming svg_sample() to
svg_running()?

Thanks,
Namhyung


>  				if (sample->type == TYPE_BLOCKED)
> -					svg_box(Y, sample->start_time, sample->end_time, "blocked");
> +					svg_blocked(Y, sample->cpu, sample->start_time, sample->end_time);
>  				if (sample->type == TYPE_WAITING)
> -					svg_waiting(Y, sample->start_time, sample->end_time);
> +					svg_waiting(Y, sample->cpu, sample->start_time, sample->end_time);
>  				sample = sample->next;
>  			}
