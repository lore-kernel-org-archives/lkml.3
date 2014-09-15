Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaIOP6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:58:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:3053 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbaIOP6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,529,1406617200"; 
   d="scan'208";a="603101070"
Date: Mon, 15 Sep 2014 08:58:37 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        kan.liang@intel.com
Subject: Re: [PATCH] perf/x86/uncore: update support for client uncore IMC PMU
Message-ID: <20140915155837.GR5387@tassilo.jf.intel.com>
References: <20140915143832.GA3264@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915143832.GA3264@quad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:38:32PM +0200, Stephane Eranian wrote:
> 
> This patch restructures the memory controller (IMC) uncore
> PMU support for client SNB/IVB/HSW processors. The main change
> is that it can now cope with more than one PCI device ID per
> processor model. There are many flavors of memory controllers
> for each processor. They have different PCI device ID, yet
> they behave the same w.r.t. the memory controller PMU that
> we are interested in.
> 
> The patch now supports two distinct memory controllers for IVB
> processors: one for mobile, one for desktop.

I haven't investigated yet, but on my Lenovo ULT Haswell laptop
the IMC PCI-ID doesn't exist, so the driver doesn't initialize.

So either it's the BIOS disabling it, or it's a different ID there
too.

BTW any reason you didn't enable the CBOX/ARB PMUs originally for HSW?
At least ARB events are useful for some things.

-Andi
