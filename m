Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaGKI1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaGKI1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:27:39 -0400
Date: Fri, 11 Jul 2014 10:27:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 3/4] perf tools: add core support for sampling intr
 machine state regs
Message-ID: <20140711082706.GD31646@krava.redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:15:58AM +0200, Stephane Eranian wrote:
> Add the infrastructure to setup, collect and report the interrupt
> machine state regs which can be captured by the kernel.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/perf.h         |  1 +
>  tools/perf/util/event.h   |  7 +++++++
>  tools/perf/util/evsel.c   | 25 ++++++++++++++++++++++++-
>  tools/perf/util/session.c | 26 ++++++++++++++++++++++++++
>  4 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 510c65f..309d956 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -54,6 +54,7 @@ struct record_opts {
>  	bool	     sample_weight;
>  	bool	     sample_time;
>  	bool	     period;
> +	bool	     sample_intr_regs;

could you please also update tests/sample-parsing.c,
so we get some basic automated testing of this

thanks,
jirka
