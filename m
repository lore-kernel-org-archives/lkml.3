Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaIZOy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:54:57 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60452 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbaIZOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:54:56 -0400
Message-ID: <1411743293.7866.62.camel@x220>
Subject: Re: [PATCHv3 2/7] ARM: at91: introduce basic SAMA5D4 support
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 16:54:53 +0200
In-Reply-To: <20140926141326.GB4408@piout.net>
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
	 <1410797759-18675-3-git-send-email-alexandre.belloni@free-electrons.com>
	 <1411732023.7866.15.camel@x220> <20140926141326.GB4408@piout.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 14:54:54.0476 (UTC) FILETIME=[D50E94C0:01CFD999]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Fri, 2014-09-26 at 16:13 +0200, Alexandre Belloni wrote:
> On 26/09/2014 at 13:47:03 +0200, Paul Bolle wrote :
> > On Mon, 2014-09-15 at 18:15 +0200, Alexandre Belloni wrote:
> > > From: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > 
> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > 
> > This landed in next-20140926, as commit 2dc850b62e5b ("ARM: at91:
> > introduce basic SAMA5D4 support").
> > 
> > > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > > index b11ad54f8d17..7b44db208f10 100644
> > > --- a/arch/arm/Kconfig.debug
> > > +++ b/arch/arm/Kconfig.debug
> > > @@ -101,6 +101,10 @@ choice
> > >  		bool "Kernel low-level debugging on 9263 and 9g45"
> > >  		depends on HAVE_AT91_DBGU1
> > >  
> > > +	config AT91_DEBUG_LL_DBGU2
> > > +		bool "Kernel low-level debugging on sama5d4"
> > > +		depends on HAVE_AT91_DBGU2
> > > +
> > 
> > Why is this Kconfig symbol needed? Nothing in next-20140926 uses it. Are
> > future users perhaps queued somewhere (say, in commits that didn't
> > survive today's rather lively linux-next merges)? 
> 
> There is no user because it conflicts with the previous one that is
> selected by default by the sama5_defconfig. This is for early print and
> it means that you can get earlyprintk either for sama5d3 or sama5d4.
> 
> My guess is that it will never be included in any defconfig.

I missed that this is inside a "choice" (which complicates matters quite
a bit)!

There are a number of cases where one of the configs inside the choice
only serve to _not_ set anything. In those cases the Kconfig symbol is
used nowhere else. I'll have to think about this particular symbol a bit
more to see if it actually makes sense to not use it anywhere else.

Thinking about the "Kernel low-level debugging port" choice is
complicated by the fact that it holds about a gazillion "config"
entries, many of which only show up only if some dependency is met. So
it might take me some time to say anything sensible about it, if I ever
manage to do that at all...

Thanks,


Paul Bolle

