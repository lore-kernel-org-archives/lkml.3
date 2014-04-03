Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaDCF5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 01:57:37 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33136 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbaDCF5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 01:57:34 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com
Subject: Re: [PATCH 3/4] perf, callchain: Add generic report parse callchain callback function
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
	<1395689577-214654-4-git-send-email-dzickus@redhat.com>
Date: Thu, 03 Apr 2014 14:57:32 +0900
In-Reply-To: <1395689577-214654-4-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:32:56 -0400")
Message-ID: <87zjk3x8dv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:32:56 -0400, Don Zickus wrote:
> This takes the parse_callchain_opt function and copies it into the
> callchain.c file.  Now the c2c tool can use it too without duplicating.
>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/util/callchain.c | 83 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/callchain.h |  1 +
>  2 files changed, 84 insertions(+)
>
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 8d9db45..2320678 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -25,6 +25,89 @@
>  
>  __thread struct callchain_cursor callchain_cursor;
>  
> +int
> +report_parse_callchain_opt(const char *arg)

As it eliminated any dependency to the report code, the name can omit
'report' as well.

Thanks,
Namhyung
