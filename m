Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaAGOOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:14:21 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46626 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaAGOOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:14:08 -0500
Date: Tue, 7 Jan 2014 11:14:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 02/16] perf tools: Fix machine initialization
Message-ID: <20140107141400.GB3845@ghostprotocols.net>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
 <1389098853-14466-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389098853-14466-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 07, 2014 at 01:47:19PM +0100, Jiri Olsa escreveu:
> The id_hdr_size field was not properly initialized,
> setting it to zero.

Humm, is there any place where 'machine' doesn't come from calloc/zalloc?

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> ---
>  tools/perf/util/machine.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index a98538d..0130279 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -27,6 +27,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
>  	machine->pid = pid;
>  
>  	machine->symbol_filter = NULL;
> +	machine->id_hdr_size = 0;
>  
>  	machine->root_dir = strdup(root_dir);
>  	if (machine->root_dir == NULL)
> -- 
> 1.8.3.1
