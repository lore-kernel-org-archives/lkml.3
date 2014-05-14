Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaENF1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:27:48 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52911 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaENF1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:27:47 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/9] perf, tools, test: Add test case for alias and JSON parsing
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
	<1399935074-25167-9-git-send-email-andi@firstfloor.org>
Date: Wed, 14 May 2014 14:27:45 +0900
In-Reply-To: <1399935074-25167-9-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 12 May 2014 15:51:13 -0700")
Message-ID: <87vbt9kjzi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 15:51:13 -0700, Andi Kleen wrote:

[SNIP]
> +int test__aliases(void)

Just a nitpick.  Please use a more descriptive name for the testcase
like test__event_aliases().

> +{
> +	int err;
> +
> +	/* Download JSON files */
> +	/* XXX assumes perf is installed */
> +	/* For now user must manually download */
> +	if (0 && system("perf download > /dev/null") < 0) {
> +		/* Don't error out for this for now */
> +		fprintf(stderr, "perf download failed\n");
> +	}
> +
> +	evlist = perf_evlist__new();
> +	if (evlist == NULL)
> +		return -ENOMEM;
> +
> +	err = pmu_iterate_events(test_event);
> +	fprintf(stderr, " Parsed %d events :", num_events);
> +	if (failed > 0)
> +		fprintf(stderr, " %d events failed", num_events);

s/num_events/failed/ ?

And this kind of detailed information is usually printed when -v option
is given via pr_debug().

Thanks,
Namhyung


> +	perf_evlist__delete(evlist);
> +	return err;
> +}
