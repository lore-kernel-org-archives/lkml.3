Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3CRJjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:39:49 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38417 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3CRJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:39:47 -0400
Date: Mon, 18 Mar 2013 10:39:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] perf cgroup: Add __percpu annotation to perf_cgroup->info
Message-ID: <20130318093943.GA25045@gmail.com>
References: <1363583692-31631-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363583692-31631-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It's a per-cpu data structure but missed the __percpu annotation.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  include/linux/perf_event.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 001a3b64fe61..16116aee9405 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -311,8 +311,8 @@ struct perf_cgroup_info {
>  };
>  
>  struct perf_cgroup {
> -	struct				cgroup_subsys_state css;
> -	struct				perf_cgroup_info *info;	/* timing info, one per cpu */
> +	struct cgroup_subsys_state 	css;
> +	struct perf_cgroup_info __percpu * info;
>  };
>  #endif

Would be nice to have this against tip:master - 'struct perf_cgroup' 
recently moved to kernel/events/, in the development tree.

Thanks,

	Ingo
