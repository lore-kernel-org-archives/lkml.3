Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaFLBDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:03:42 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:36176 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaFLBDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:03:41 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf timechart: add more options to IO mode
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
	<1402412694-5996-4-git-send-email-stfomichev@yandex-team.ru>
Date: Thu, 12 Jun 2014 10:03:39 +0900
In-Reply-To: <1402412694-5996-4-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Tue, 10 Jun 2014 19:04:54 +0400")
Message-ID: <87lht39bx0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 19:04:54 +0400, Stanislav Fomichev wrote:
> --io-skip-eagain - don't show EAGAIN errors
> --io-min-time    - make small io bursts visible
> --io-merge-dist  - merge adjacent events
>
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/Documentation/perf-timechart.txt |  9 ++++++
>  tools/perf/builtin-timechart.c              | 49 +++++++++++++++++++++++++++--
>  2 files changed, 56 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
> index ec6b46c7bca0..62c29656ad95 100644
> --- a/tools/perf/Documentation/perf-timechart.txt
> +++ b/tools/perf/Documentation/perf-timechart.txt
> @@ -64,6 +64,15 @@ TIMECHART OPTIONS
>  	duration or tasks with given name. If number is given it's interpreted
>  	as number of nanoseconds. If non-numeric string is given it's
>  	interpreted as task name.
> +--io-skip-eagain::
> +	Don't draw EAGAIN IO events.
> +--io-min-time::
> +	Draw small events as if they lasted min-time. Useful when you need
> +	to see very small and fast IO. Default value is 1ms.

It's in nano-second unit, right?  If so, it's very unconvenient for user
to specify.  Maybe we could support to parse unit (s, ms, us, ...) also.


> +--io-merge-dist::
> +	Merge events that are merge-dist nanoseconds apart.
> +	Reduces number of figures on the SVG and makes it more render-friendly.
> +	Default value is 1us.

Ditto.

Thanks,
Namhyung
