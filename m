Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3FYQAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:00:39 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42061 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3FYQAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:00:38 -0400
Message-ID: <51C9BEA1.5000205@gmail.com>
Date: Tue, 25 Jun 2013 10:00:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 15/15] perf tools: fix ppid in thread__fork()
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-16-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372079772-20803-16-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/13 7:16 AM, Adrian Hunter wrote:
> ppid should be assigned to the parents pid.  Note
> 'thread__fork()'s only caller 'machine__process_fork_event()'
> ensures that the parents pid is set.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/thread.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index e3d4a55..93f3eab 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -85,7 +85,7 @@ int thread__fork(struct thread *self, struct thread *parent)
>   		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
>   			return -ENOMEM;
>
> -	self->ppid = parent->tid;
> +	self->ppid = parent->pid_;

Confused. My patch uses parent->pid and that it what I see in acme's 
perf/core branch. When did this become parent->tid?

David

