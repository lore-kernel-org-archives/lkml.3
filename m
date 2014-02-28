Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaB1S7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:59:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:5721 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaB1S7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:59:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,563,1389772800"; 
   d="scan'208";a="464379776"
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 11/19] perf, c2c: Add in sort on physid
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
	<1393609388-40489-12-git-send-email-dzickus@redhat.com>
Date: Fri, 28 Feb 2014 10:59:18 -0800
In-Reply-To: <1393609388-40489-12-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Fri, 28 Feb 2014 12:43:00 -0500")
Message-ID: <87ppm7aws9.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:
> +
> +	/*
> +	 * must pass period=weight in order to get the correct
> +	 * sorting from hists__collapse_resort() which is solely
> +	 * based on periods. We want sorting be done on nr_events * weight
> +	 * and this is indirectly achieved by passing period=weight here
> +	 * and the he_stat__add_period() function.
> +	 */

sort.c really must be fixed to support multiple sort keys properly.
Lots of other code has workarounds for this too (e.g. it is a bit
problem for TSX abort weights)

I would suggest to fix that instead of hacking around it.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
