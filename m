Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3FXJsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:48:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46975 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3FXJsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:48:41 -0400
Date: Mon, 24 Jun 2013 11:48:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130624094830.GP28407@twins.programming.kicks-ass.net>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370968960-22527-4-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 06:42:29PM +0200, Robert Richter wrote:
> +int perf_add_persistent_event_by_id(int id)
> +{
> +	struct perf_event_attr *attr;
> +
> +	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> +	if (!attr)
> +		return -ENOMEM;
> +
> +	attr->sample_period	= 1;
> +	attr->wakeup_events	= 1;
> +	attr->sample_type	= PERF_SAMPLE_RAW;
> +	attr->persistent	= 1;
> +	attr->config		= id;
> +	attr->type		= PERF_TYPE_TRACEPOINT;
> +	attr->size		= sizeof(*attr);
> +
> +	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
> +}

I would call this what it is: perf_add_persistent_tracepoint(), or so
:-)

