Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3JJGMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:12:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53523 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3JJGMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:12:18 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-a0-52564540565e
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 28/52] tools/perf/build: Split out feature check: 'on-exit'
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-29-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 15:12:16 +0900
In-Reply-To: <1381227082-22039-29-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:10:58 +0200")
Message-ID: <87wqlliri7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
> new file mode 100644
> index 0000000..473f1de
> --- /dev/null
> +++ b/tools/perf/config/feature-checks/test-on-exit.c
> @@ -0,0 +1,6 @@
> +#include <stdio.h>
> +
> +int main(void)
> +{
> +	return on_exit(NULL, NULL);
> +}

Just a nitpick.  The manpage says the on_exit() requires <stdlib.h>
header rather than <stdio.h> and _BSD_SOURCE or _SVID_SOURCE defined.
So I think we can define _GNU_SOURCE before the header file or pass it
through make command line - it'd probably be better for synthesized
test-all.c checking.

Thanks,
Namhyung
