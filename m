Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaD1APF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 20:15:05 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52237 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaD1APD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 20:15:03 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: xiakaixu <xiakaixu@huawei.com>
Cc: <linux-kernel@vger.kernel.org>, <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Huxinwei <huxinwei@huawei.com>, Genghui <hui.geng@huawei.com>,
        jolsa@redhat.com, bp@alien8.de
Subject: Re: [PATCH] perf tools: Remove extra '/' character in events file path
References: <535B6660.2060001@huawei.com>
Date: Mon, 28 Apr 2014 09:14:58 +0900
In-Reply-To: <535B6660.2060001@huawei.com> (xiakaixu@huawei.com's message of
	"Sat, 26 Apr 2014 15:55:12 +0800")
Message-ID: <87tx9epawt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi xiakaixu,

(Adding Jiri and Boris to CC)

> The array debugfs_known_mountpoints[] will cause extra '/'
> character output.
> Remove it.
>
> pre:
> $ perf probe -l
> /sys/kernel/debug//tracing/uprobe_events file does not exist -
> please rebuild kernel with CONFIG_UPROBE_EVENTS.
>
> post:
> $ perf probe -l
> /sys/kernel/debug/tracing/uprobe_events file does not exist -
> please rebuild kernel with CONFIG_UPROBE_EVENTS.

Looks like all of its callers already provide a '/' after the debugfs
mountpoint, so

  Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

> 	
> Signed-off-by: Xia Kaixu <xiakaixu@huawei.com>
> ---
>  tools/lib/api/fs/debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
> index 7c43479..a74fba6 100644
> --- a/tools/lib/api/fs/debugfs.c
> +++ b/tools/lib/api/fs/debugfs.c
> @@ -12,8 +12,8 @@
>  char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
>
>  static const char * const debugfs_known_mountpoints[] = {
> -	"/sys/kernel/debug/",
> -	"/debug/",
> +	"/sys/kernel/debug",
> +	"/debug",
>  	0,
>  };
>
> -- 1.8.5.5
