Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaILGnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:43:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35934 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaILGna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:43:30 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Anton Blanchard <anton@samba.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf symbols: Add path to Ubuntu kernel debuginfo file
References: <20140909091152.2698c0f7@kryten>
Date: Fri, 12 Sep 2014 15:43:28 +0900
In-Reply-To: <20140909091152.2698c0f7@kryten> (Anton Blanchard's message of
	"Tue, 9 Sep 2014 09:11:52 +1000")
Message-ID: <87d2b1mj8v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014 09:11:52 +1000, Anton Blanchard wrote:
> Ubuntu places the kernel debuginfo in /usr/lib/debug/boot/vmlinux-*
>
> Signed-off-by: Anton Blanchard <anton@samba.org>

It seems that you need to rebase it onto current acme/perf/core as
there're little change in this area.  The patch itself looks good to me.

Thanks,
Namhyung


> ---
>
> Index: b/tools/perf/util/symbol.c
> ===================================================================
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1750,7 +1750,7 @@ static int vmlinux_path__init(void)
>  	struct utsname uts;
>  	char bf[PATH_MAX];
>  
> -	vmlinux_path = malloc(sizeof(char *) * 5);
> +	vmlinux_path = malloc(sizeof(char *) * 6);
>  	if (vmlinux_path == NULL)
>  		return -1;
>  
> @@ -1784,6 +1784,12 @@ static int vmlinux_path__init(void)
>  		 uts.release);
>  	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
>  	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
> +		goto out_fail;
> +	++vmlinux_path__nr_entries;
> +	snprintf(bf, sizeof(bf), "/usr/lib/debug/boot/vmlinux-%s",
> +		 uts.release);
> +	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
> +	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
>  		goto out_fail;
>  	++vmlinux_path__nr_entries;
>  
