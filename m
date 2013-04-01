Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab3DAGTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:19:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60975 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab3DAGTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:19:30 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-e2-515926f04f2a
From: Namhyung Kim <namhyung@kernel.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix bug in isupper() and islower()
References: <20130329192950.GA9312@us.ibm.com>
Date: Mon, 01 Apr 2013 15:19:28 +0900
In-Reply-To: <20130329192950.GA9312@us.ibm.com> (Sukadev Bhattiprolu's message
	of "Fri, 29 Mar 2013 12:29:50 -0700")
Message-ID: <876206hixb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sukadev,

On Fri, 29 Mar 2013 12:29:50 -0700, Sukadev Bhattiprolu wrote:
> From fd349681226bf7b27c9d0f72b0f3941b5aa94f78 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Fri, 29 Mar 2013 12:14:43 -0700
> Subject: [PATCH] perf: fix bug in isupper() and islower()
>
> One of the reasons 'perf test' is failing on Power appears to be due to
> a bug in isupper().
>
> isupper(c) and islower(c) should be checking 'c' against the mask 0x20.
> Instead they are checking sane_ctype[c] which causes isupper() to be true
> for lower case letters.

Indeed!

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  tools/perf/util/util.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 09b4c26..2795ef6 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -219,8 +219,8 @@ extern unsigned char sane_ctype[256];
>  #define isalpha(x) sane_istest(x,GIT_ALPHA)
>  #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
>  #define isprint(x) sane_istest(x,GIT_PRINT)
> -#define islower(x) (sane_istest(x,GIT_ALPHA) && sane_istest(x,0x20))
> -#define isupper(x) (sane_istest(x,GIT_ALPHA) && !sane_istest(x,0x20))
> +#define islower(x) (sane_istest(x,GIT_ALPHA) && (x & 0x20))
> +#define isupper(x) (sane_istest(x,GIT_ALPHA) && !(x & 0x20))
>  #define tolower(x) sane_case((unsigned char)(x), 0x20)
>  #define toupper(x) sane_case((unsigned char)(x), 0)
