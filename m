Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163AbaH0QXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:23:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:45316 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934491AbaH0QXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,412,1406617200"; 
   d="scan'208";a="473251263"
Date: Wed, 27 Aug 2014 09:22:46 -0700
From: Andi Kleen <ak@linux.intel.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140827162246.GH5803@tassilo.jf.intel.com>
References: <1409106792-22333-1-git-send-email-kan.liang@intel.com>
 <1409106792-22333-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409106792-22333-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> +		list_for_each_entry(alias, &pmu->aliases, list) {
> +			if (!strcmp(pmu->name, "cpu")) {
> +				struct kernel_pmu_event_symbol *p =
> +					kernel_pmu_events_list + len;
> +				char *tmp = strchr(alias->name, '-');
> +
> +				if (tmp != NULL) {
> +					strncpy(p->symbol, alias->name,
> +							tmp - alias->name);

Please use strlcpy(). Otherwise p->symbol may not be zero terminated.

The rest of the patch looks good to me.

-Andi
