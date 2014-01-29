Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaA2F2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 00:28:19 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63586 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaA2F2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 00:28:16 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-da-52e8916d8b2d
From: Namhyung Kim <namhyung@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, raistlin@linux.it,
        juri.lelli@gmail.com, clark.williams@gmail.com, mingo@redhat.com,
        rostedt@goodmis.org
Subject: Re: [PATCH 1/3] sched: Move the priority specific bits into a new header file.
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
	<f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com>
Date: Wed, 29 Jan 2014 14:28:13 +0900
In-Reply-To: <f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com>
	(Dongsheng Yang's message of "Mon, 27 Jan 2014 17:15:37 -0500")
Message-ID: <87fvo75pci.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dongsheng,

On Mon, 27 Jan 2014 17:15:37 -0500, Dongsheng Yang wrote:
> Some bits about priority are defined in linux/sched/rt.h, but
> some of them are not only for rt scheduler, such as MAX_PRIO.
>
> This patch move them all into a new header file, linux/sched/prio.h.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  include/linux/sched.h      |  4 ++++
>  include/linux/sched/prio.h | 23 +++++++++++++++++++++++
>  include/linux/sched/rt.h   | 21 +++------------------
>  3 files changed, 30 insertions(+), 18 deletions(-)
>  create mode 100644 include/linux/sched/prio.h
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 68a0e84..ba1b732 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -3,6 +3,10 @@
>  
>  #include <uapi/linux/sched.h>
>  
> +#ifndef _SCHED_PRIO_H
> +#include <linux/sched/prio.h>
> +#endif /* #ifndef _SCHED_PRIO_H */

It seems you don't need to use #ifndef-#endif pair to include a header
file?

Thanks,
Namhyung
