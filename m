Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3IWNus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab3IWNur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:50:47 -0400
Date: Mon, 23 Sep 2013 15:50:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 4/4] perf tools: Make kmem work for non numa machines
Message-ID: <20130923135031.GD3488@krava.brq.redhat.com>
References: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
 <1379003976-5839-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379003976-5839-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 06:39:36PM +0200, Jiri Olsa wrote:
> The commit '2814eb0 perf kmem: Remove die() calls' disabled
> kmem command for machines without numa support. It made the
> command fail if '/sys/devices/system/node' dir wasn't found.
> 
> Skipping the numa based initialization in case the directory
> is not found and continue execution.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

ping

thanks,
jirka

> ---
>  tools/perf/builtin-kmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index c2dff9c..9b5f077 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -101,7 +101,7 @@ static int setup_cpunode_map(void)
>  
>  	dir1 = opendir(PATH_SYS_NODE);
>  	if (!dir1)
> -		return -1;
> +		return 0;
>  
>  	while ((dent1 = readdir(dir1)) != NULL) {
>  		if (dent1->d_type != DT_DIR ||
> -- 
> 1.7.11.7
> 
