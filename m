Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab3BZJG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:06:29 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42448 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3BZJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:06:26 -0500
X-AuditID: 9c93016f-b7b46ae000007f43-6d-512c7b1029b9
From: Namhyung Kim <namhyung@kernel.org>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, jolsa@redhat.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf: correct a build error
References: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
	<1361851974-25307-2-git-send-email-lig.fnst@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 18:06:24 +0900
In-Reply-To: <1361851974-25307-2-git-send-email-lig.fnst@cn.fujitsu.com>
	(liguang's message of "Tue, 26 Feb 2013 12:12:53 +0800")
Message-ID: <87txozsaun.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi liguang,

On Tue, 26 Feb 2013 12:12:53 +0800, liguang wrote:
> builtin-annotate.c: In function 'hists__find_annotations':
> builtin-annotate.c:161:4: error: duplicate case value
> builtin-annotate.c:154:4: error: previously used here
>
> it happened when no newt installed

Thanks for fixing this.  Please see my other post on the same problem
reported by Michael Ellerman.

Thanks,
Namhyung

>
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  tools/perf/util/hist.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 3862468..b4436e9 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -208,8 +208,8 @@ static inline int script_browse(const char *script_opt __maybe_unused)
>  	return 0;
>  }
>  
> -#define K_LEFT -1
> -#define K_RIGHT -2
> +#define K_LEFT -2
> +#define K_RIGHT -3
>  #endif
>  
>  #ifdef GTK2_SUPPORT
