Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaJGIPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:15:47 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:36494 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaJGIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:15:42 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Yasser Shalabi <yassershalabi@gmail.com>
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf: fix for double free in tools/perf stat
References: <1412437077-13109-1-git-send-email-yassershalabi@gmail.com>
Date: Tue, 07 Oct 2014 17:15:41 +0900
In-Reply-To: <1412437077-13109-1-git-send-email-yassershalabi@gmail.com>
	(Yasser Shalabi's message of "Sat, 4 Oct 2014 11:37:57 -0400")
Message-ID: <871tqkgus2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yasser,

On Sat,  4 Oct 2014 11:37:57 -0400, Yasser Shalabi wrote:
> Fix for double free bug in tools/perf due to dangling thread_map pointer in perf_evlist struct.
> Code path excercised when perf stat -C switch is used but not set and is followed by another switch.
> Example: perf stat -C -e. 
> Signed-off-by: Yasser Shalabi <yassershalabi@gmail.com>
>
> ---
>  tools/perf/util/evlist.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 814e954..09af633 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -845,6 +845,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
>  
>  out_delete_threads:
>  	thread_map__delete(evlist->threads);
> +	evlist->threads = 0;

Nitpick - I think NULL is preferred rather than 0.

Other than that,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>  	return -1;
>  }
