Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3JDWO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:14:27 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:39146 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752945Ab3JDWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:14:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2901:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:3873:3874:4321:4605:5007:6119:7652:7903:8784:9121:10011:10400:10848:10967:11026:11232:11233:11473:11658:11914:12295:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: chair98_7da595556b157
X-Filterd-Recvd-Size: 2623
Message-ID: <1380924862.2081.118.camel@joe-AO722>
Subject: Re: [PATCH v2 6/6] Introduce Intel RAPL power capping driver
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        gregkh@linuxfoundation.org, len.brown@intel.com, rjw@sisk.pl,
        arjan@linux.intel.com
Date: Fri, 04 Oct 2013 15:14:22 -0700
In-Reply-To: <20131004131228.54eb7098@ultegra>
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1380904616-17519-7-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1380910065.2081.117.camel@joe-AO722> <20131004131228.54eb7098@ultegra>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 13:12 -0700, Jacob Pan wrote:
> On Fri, 04 Oct 2013 11:07:45 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Fri, 2013-10-04 at 09:36 -0700, Srinivas Pandruvada wrote:
> > > The Intel Running Average Power Limit(RAPL) technology provides
> > > platform software with the ability to monitor, control, and get
> > > notifications on power usage.
> > []
> > > diff --git a/drivers/powercap/Makefile b/drivers/powercap/Makefile
> > []
> > > +/* bitmasks for RAPL MSRs, used by primitive access functions */
> > > +#define ENERGY_STATUS_MASK      0xffffffff
> > > +
> > > +#define POWER_LIMIT1_MASK       0x7FFF
> > > +#define POWER_LIMIT1_ENABLE     BIT(15)
> > > +#define POWER_LIMIT1_CLAMP      BIT(16)
> > > +
> > > +#define POWER_LIMIT2_MASK       (0x7FFFULL<<32)
> > > +#define POWER_LIMIT2_ENABLE     BIT_ULL(47)
> > > +#define POWER_LIMIT2_CLAMP      BIT_ULL(48)
> > > +#define POWER_PACKAGE_LOCK      BIT_ULL(63)
> > > +#define POWER_PP_LOCK           BIT(31)
> > > +
> > > +#define TIME_WINDOW1_MASK       (0x7F<<17)
> > > +#define TIME_WINDOW2_MASK       (0x7FULL<<49)
> > 
> > 
> > Is there a reason why these masks aren't all ULL?
> > 
> > 
> 
> are you referring to this line below not being ULL?
> > > +#define TIME_WINDOW1_MASK       (0x7F<<17)
> if this is the case, I did that because it is not more than 32 bit.
> 
> Thanks,
> 
> Jacob

Isn't LIMIT1/WINDOW1 used as ull anyway?
It doesn't hurt to show that the value is also ull.

