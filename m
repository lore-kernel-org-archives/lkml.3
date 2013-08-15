Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3HOK0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:26:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3HOK0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:26:37 -0400
Date: Thu, 15 Aug 2013 12:26:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com,
        dsahern@gmail.com
Subject: Re: [PATCH v1 1/2] perf: add attr->mmap2 attribute to an event
Message-ID: <20130815102620.GN24092@twins.programming.kicks-ass.net>
References: <1376394957-31691-1-git-send-email-eranian@google.com>
 <1376394957-31691-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376394957-31691-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 01:55:56PM +0200, Stephane Eranian wrote:

> @@ -638,6 +639,25 @@ enum perf_event_type {
>  	 */
>  	PERF_RECORD_SAMPLE			= 9,
>  
> +	/*
> +	 * The MMAP2 records are an augmented version of MMAP, they add
> +	 * maj, min, ino numbers to be used to uniquely identify each mapping
> +	 *
> +	 * struct {
> +	 *	struct perf_event_header	header;
> +	 *
> +	 *	u32				pid, tid;
> +	 *	u64				addr;
> +	 *	u64				len;
> +	 *	u64				pgoff;
> +	 *	u32				maj;
> +	 *	u32				min;
> +	 *	u64				ino;
> +	 *	char				filename[];

Did you forget the sample_id stuff?

		struct sample_id		sample_id;

> +	 * };
> +	 */
> +	PERF_RECORD_MMAP2			= 10,
> +
>  	PERF_RECORD_MAX,			/* non-ABI */
>  };
