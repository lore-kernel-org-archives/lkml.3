Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaHMFWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:22:38 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:48699 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaHMFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:22:37 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Naohiro Aota <naota@elisp.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [BUGFIX] perf probe: Fix --list option to show events only with uprobe events
References: <20140813005055.24360.73553.stgit@kbuild-fedora.novalocal>
Date: Wed, 13 Aug 2014 14:22:35 +0900
In-Reply-To: <20140813005055.24360.73553.stgit@kbuild-fedora.novalocal>
	(Masami Hiramatsu's message of "Wed, 13 Aug 2014 00:50:55 +0000")
Message-ID: <87r40ldkv8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Wed, 13 Aug 2014 00:50:55 +0000, Masami Hiramatsu wrote:
> +	if (kp_fd < 0 && up_fd < 0) {
> +		/* Both kprobes and uprobes are disabled, warn it. */
> +		if (kp_fd == -ENOTSUP && up_fd == -ENOTSUP)
> +			pr_warning("Debugfs is not mounted.\n");
> +		else if (kp_fd == -ENOENT && up_fd == -ENOENT)
> +			pr_warning("Please rebuild kernel with "
> +				   "CONFIG_KPROBE_EVENTS or/and "
> +				   "CONFIG_UPROBE_EVENTS.\n");
> +		else
> +			pr_warning("Failed to open kprobe events: %s.\n" \
> +				   "Failed to open uprobe events: %s.\n",
> +				   strerror(-kp_fd), strerror(-up_fd));

It seems the second strerror() might overwrite the message of the
first.  You'd better using strerror_r() IMHO.

Thanks,
Namhyung


> +		ret = kp_fd;
> +		goto out;
>  	}
>  
> +	if (up_fd >= 0) {
> +		ret = __show_perf_probe_events(up_fd, false);
> +		close(up_fd);
> +	}
> +out:
>  	exit_symbol_maps();
>  	return ret;
>  }
