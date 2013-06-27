Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3F0Q6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:58:06 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63882 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3F0Q6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:58:02 -0400
Message-ID: <51CC6F16.40004@gmail.com>
Date: Thu, 27 Jun 2013 10:57:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 15/15] perf tools: fix ppid in thread__fork()
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-16-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372319707-13892-16-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/13 1:55 AM, Adrian Hunter wrote:
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
>

knowledge of the specific thread within the parent that created the 
process can be valuable -- that's what we get now. This change drops 
that information. I'd prefer this stays at thread id -- or save the 
parent thread id in addition to the pid.

David
