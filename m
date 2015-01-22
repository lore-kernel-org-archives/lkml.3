Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbbAVJ0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:26:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:26971 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbbAVJ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:26:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,448,1418112000"; 
   d="scan'208";a="665723540"
Message-ID: <1421918770.31903.111.camel@linux.intel.com>
Subject: Re: [PATCH v2 4/4] PMC driver: Add Cherrytrail PMC interface
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: x86@kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Thu, 22 Jan 2015 11:26:10 +0200
In-Reply-To: <54C07641.7090706@linux.intel.com>
References: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1421790603-30097-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <54C07641.7090706@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 12:02 +0800, Li, Aubrey wrote:
> On 2015/1/21 5:50, Andy Shevchenko wrote:
> > The patch adds CHT PMC interface. This exposes all the South IP device power
> > states and S0ix states for CHT. The bit map of FUNC_DIS and D3_STS_0 registers
> > for SoCs are consistent. The D3_STS_1 and FUNC_DIS_2 registers, however, are
> > not aligned. This is fixed by splitting a common mapping on per register basis.
> > 
> Should we define the bit map table completely separate for different
> platforms? My concern is, when D3_STS_0 and FUNC_DIS becomes not
> consistent in a new SoC, the implementation in this patch has to be
> rewritten completely.
> 
> Defining entire bit map table for different platform introduces
> reduplicated bit definitions, but when we add a new platform in future,
> we don't need to consider the existing platforms definition, and no need
> to change code structure any longer.
> 
> Thoughts?
> 

But this what I did by introducing pmc_reg_map structure per SoC.
You may or may not use previous definitions.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

