Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaKQFIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 00:08:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39418 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKQFIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:08:20 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V2 1/3] perf tool: Fix perf diff symble sort issue
References: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
	<1415653280-1374-2-git-send-email-kan.liang@intel.com>
Date: Mon, 17 Nov 2014 14:08:18 +0900
In-Reply-To: <1415653280-1374-2-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Mon, 10 Nov 2014 16:01:18 -0500")
Message-ID: <87k32utnwd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kan,

On Mon, 10 Nov 2014 16:01:18 -0500, kan liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> This patch fixes a bug for perf diff.
> Without mmap2, perf diff fails to find the symbol name. The default
> symbol sort key doesn't work well.
>
> Signed-off-by: Kan Liang <kan.liang@intel.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/builtin-diff.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 25114c9..1ce425d 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -357,6 +357,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
>  static struct perf_tool tool = {
>  	.sample	= diff__process_sample_event,
>  	.mmap	= perf_event__process_mmap,
> +	.mmap2	= perf_event__process_mmap2,
>  	.comm	= perf_event__process_comm,
>  	.exit	= perf_event__process_exit,
>  	.fork	= perf_event__process_fork,
