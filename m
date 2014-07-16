Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbaGPOVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934376AbaGPOVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:21:03 -0400
Date: Wed, 16 Jul 2014 16:20:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 18/41] perf tools: Record whether a dso has data
Message-ID: <20140716142031.GD9441@krava.redhat.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-19-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405332185-4050-19-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:02:42PM +0300, Adrian Hunter wrote:
> Add 'data_status' to record whether a dso has data
> (i.e. an object file) as follows:
> 
> 	dso->data_status	meaning
> 	----------------------------------
> 	0			don't know
> 	-1			no data
> 	1			has data

please add enum for this

> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/dso.c | 5 ++++-
>  tools/perf/util/dso.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index fc006fe..91a4eb4 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -556,8 +556,11 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
>  ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
>  			      u64 offset, u8 *data, ssize_t size)
>  {
> -	if (dso__data_fd(dso, machine) < 0)
> +	if (dso__data_fd(dso, machine) < 0) {
> +		dso->data.data_status = -1;
>  		return -1;
> +	}
> +	dso->data.data_status = 1;

we have more callers to dso__data_fd, so I think we want
to setup dso->data.data_status within dso__data_fd

jirka
