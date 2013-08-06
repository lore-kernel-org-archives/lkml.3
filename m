Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3HFN7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3HFN7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:59:53 -0400
Date: Tue, 6 Aug 2013 15:59:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v2 1/2] perf tools: Add support for pinned modifier
Message-ID: <20130806135937.GB1068@krava.brq.redhat.com>
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:28:05PM +1000, Michael Ellerman wrote:

SNIP

>  
>  	while (*p) {
> @@ -812,6 +818,9 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
>  		evsel->attr.exclude_guest  = mod.eG;
>  		evsel->exclude_GH          = mod.exclude_GH;
>  		evsel->sample_read         = mod.sample_read;
> +
> +		if (evsel->leader == evsel)
> +			evsel->attr.pinned = mod.pinned;

nitpick, we have perf_evsel__is_group_leader for this check

jirka
