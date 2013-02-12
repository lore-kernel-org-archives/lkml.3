Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab3BLRXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:23:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:61010 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915Ab3BLRXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:23:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="261602493"
Date: Tue, 12 Feb 2013 09:23:19 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 0/2] perf stat: add per-core count aggregation
Message-ID: <20130212172319.GB30387@tassilo.jf.intel.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360678168-6974-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 03:09:26PM +0100, Stephane Eranian wrote:
> This patch series contains improvement to the aggregation support
> in perf stat.
> 
> First, the aggregation code is refactored and a aggr_mode enum
> is defined. There is also an important bug fix for the existing
> per-socket aggregation.
> 
> Second, the patch adds a new --aggr-core option to perf stat.

Perhaps it's just me, but the option name is ugly (and sounds
aggressive)

--per-core perhaps?

The idea itself is useful.

> It aggregates counts per physical core and becomes useful on
> systems with hyper-threading. The cores are presented per
> socket: S0-C1, means socket 0 core 1. Note that the core number
> represents its physical core id. As such, numbers may not always
> be contiguous. All of this is based on topology information available
> in sysfs.
> 
> Per-core aggregation can be combined with interval printing:

FWIW this would be much nicer if stat had a Kevents or Mevents mode.
Usually we don't need all the digits.  But that could be added separately

Does it work for multiple events in parallel?
> 
>  # perf stat -a --aggr-core -I 1000 -e cycles sleep 100
>  #           time core         cpus             counts events
>       1.000101160 S0-C0           2      6,051,254,899 cycles                   
>       1.000101160 S0-C1           2      6,379,230,776 cycles                   
>       1.000101160 S0-C2           2      6,480,268,471 cycles                   
>       1.000101160 S0-C3           2      6,110,514,321 cycles                   
>       2.000663750 S0-C0           2      6,572,533,016 cycles                   
>       2.000663750 S0-C1           2      6,378,623,674 cycles                   
>       2.000663750 S0-C2           2      6,264,127,589 cycles                   
>       2.000663750 S0-C3           2      6,305,346,613 cycles                   

-Andi 
