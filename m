Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3JDUMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:12:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:10611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3JDUM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="303310506"
Date: Fri, 4 Oct 2013 13:12:28 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        gregkh@linuxfoundation.org, len.brown@intel.com, rjw@sisk.pl,
        arjan@linux.intel.com
Subject: Re: [PATCH v2 6/6] Introduce Intel RAPL power capping driver
Message-ID: <20131004131228.54eb7098@ultegra>
In-Reply-To: <1380910065.2081.117.camel@joe-AO722>
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	<1380904616-17519-7-git-send-email-srinivas.pandruvada@linux.intel.com>
	<1380910065.2081.117.camel@joe-AO722>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Oct 2013 11:07:45 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2013-10-04 at 09:36 -0700, Srinivas Pandruvada wrote:
> > The Intel Running Average Power Limit(RAPL) technology provides
> > platform software with the ability to monitor, control, and get
> > notifications on power usage.
> []
> > diff --git a/drivers/powercap/Makefile b/drivers/powercap/Makefile
> []
> > +/* bitmasks for RAPL MSRs, used by primitive access functions */
> > +#define ENERGY_STATUS_MASK      0xffffffff
> > +
> > +#define POWER_LIMIT1_MASK       0x7FFF
> > +#define POWER_LIMIT1_ENABLE     BIT(15)
> > +#define POWER_LIMIT1_CLAMP      BIT(16)
> > +
> > +#define POWER_LIMIT2_MASK       (0x7FFFULL<<32)
> > +#define POWER_LIMIT2_ENABLE     BIT_ULL(47)
> > +#define POWER_LIMIT2_CLAMP      BIT_ULL(48)
> > +#define POWER_PACKAGE_LOCK      BIT_ULL(63)
> > +#define POWER_PP_LOCK           BIT(31)
> > +
> > +#define TIME_WINDOW1_MASK       (0x7F<<17)
> > +#define TIME_WINDOW2_MASK       (0x7FULL<<49)
> 
> 
> Is there a reason why these masks aren't all ULL?
> 
> 

are you referring to this line below not being ULL?
> > +#define TIME_WINDOW1_MASK       (0x7F<<17)
if this is the case, I did that because it is not more than 32 bit.

Thanks,

Jacob
