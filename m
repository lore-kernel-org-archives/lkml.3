Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3GFP6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 11:58:39 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:55711 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3GFP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:58:38 -0400
Message-ID: <51D83EA7.4060600@gmail.com>
Date: Sat, 06 Jul 2013 09:58:31 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V4 14/21] perf tools: change "machine" functions to set
 thread pid
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com> <1372944040-32690-15-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372944040-32690-15-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/13 7:20 AM, Adrian Hunter wrote:
> Typically tracking events such as mmap events, comm events,
> fork events and exit events, are processed by "machine"
> functions.  Change these functions to put pid in the new
> pid_ member of struct thread.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/machine.c | 21 +++++++++++++++++----
>   tools/perf/util/machine.h |  2 ++
>   2 files changed, 19 insertions(+), 4 deletions(-)
>

---8<---

> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index e49ba01..d986ecf 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -100,6 +100,8 @@ static inline bool machine__is_host(struct machine *machine)
>   }
>
>   struct thread *machine__findnew_thread(struct machine *machine, pid_t tid);
> +struct thread *machine__findnew_thread_ex(struct machine *machine, pid_t pid,
> +					  pid_t tid);
>
>   size_t machine__fprintf(struct machine *machine, FILE *fp);
>
>


Why do you want to add a new API for this? Why not just fix 
findnew_thread and find_thread to take the pid argument? We don't need 2 
apis that do the same thing.

David
