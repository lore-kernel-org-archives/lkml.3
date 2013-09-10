Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3IJUWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:22:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:14189 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab3IJUWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:22:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,879,1371106800"; 
   d="scan'208";a="393776526"
Date: Tue, 10 Sep 2013 13:22:45 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86: fix uncore PCI fixed counter handling
Message-ID: <20130910202245.GF11427@tassilo.jf.intel.com>
References: <20130909195350.GA17643@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909195350.GA17643@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 12:53:50PM -0700, Stephane Eranian wrote:
> 
> There was a bug in the handling of SNB-EP/IVB-EP uncore PCI
> fixed counters, e.g., IMC. It would cause erratic values to
> be returned for the IMC clockticks event. This was due to
> a bogus hwc->config value which was then written to PCI
> config space. The fixed counter has most fields marked as
> reserved with hw reset values of 0. Yet the kernel was
> defaulting to a hwc->config = ~0 and that was causing
> the issues. The patch sets the hwc->config values for fixed
> uncore event to 0. Now, the values of imc clockticks is
> correct.
>     
> $ perf stat -a -C 0 -e uncore_imc_0/clockticks/ -I 1000 sleep 10

Looks good to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
