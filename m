Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab3HUNPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:15:32 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:38332 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3HUNPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:15:31 -0400
Date: Wed, 21 Aug 2013 10:15:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v3
Message-ID: <20130821131525.GB21880@ghostprotocols.net>
References: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
 <1376505267-8902-5-git-send-email-andi@firstfloor.org>
 <20130815132637.GE1861@ghostprotocols.net>
 <20130815142925.GG19750@two.firstfloor.org>
 <20130815150150.GB1940@ghostprotocols.net>
 <20130815164203.GJ19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815164203.GJ19750@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 15, 2013 at 06:42:03PM +0200, Andi Kleen escreveu:
> 
> Here's an updated patch.
 
> perf, tools: Add perf stat --transaction v4
> @@ -1419,6 +1559,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  		     "aggregate counts per processor socket", AGGR_SOCKET),
>  	OPT_SET_UINT(0, "per-core", &aggr_mode,
>  		     "aggregate counts per physical processor core", AGGR_CORE),
> +	OPT_BOOLEAN('T', "transaction", &transaction_run,
> +		    "hardware transaction statistics"),
>  	OPT_END()

Clashes with another patch, from you, that is in Ingo's perf/core as
well, that adds -D, so the above hunk doesn't apply:

	OPT_UINTEGER('I', "interval-print", &interval,
		    "print counts at regular interval in ms (>= 100)"),
	OPT_SET_UINT(0, "per-socket", &aggr_mode,
		     "aggregate counts per processor socket", AGGR_SOCKET),
	OPT_SET_UINT(0, "per-core", &aggr_mode,
		     "aggregate counts per physical processor core", AGGR_CORE),
	OPT_UINTEGER('D', "delay", &initial_delay,
		     "ms to wait before starting measurement after program start"),
	OPT_END()
	};

- Arnaldo
