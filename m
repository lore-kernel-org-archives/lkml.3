Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaIZONb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:13:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34831 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754412AbaIZON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:13:29 -0400
Date: Fri, 26 Sep 2014 16:13:27 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/7] ARM: at91: introduce basic SAMA5D4 support
Message-ID: <20140926141326.GB4408@piout.net>
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410797759-18675-3-git-send-email-alexandre.belloni@free-electrons.com>
 <1411732023.7866.15.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411732023.7866.15.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/2014 at 13:47:03 +0200, Paul Bolle wrote :
> On Mon, 2014-09-15 at 18:15 +0200, Alexandre Belloni wrote:
> > From: Nicolas Ferre <nicolas.ferre@atmel.com>
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> This landed in next-20140926, as commit 2dc850b62e5b ("ARM: at91:
> introduce basic SAMA5D4 support").
> 
> > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > index b11ad54f8d17..7b44db208f10 100644
> > --- a/arch/arm/Kconfig.debug
> > +++ b/arch/arm/Kconfig.debug
> > @@ -101,6 +101,10 @@ choice
> >  		bool "Kernel low-level debugging on 9263 and 9g45"
> >  		depends on HAVE_AT91_DBGU1
> >  
> > +	config AT91_DEBUG_LL_DBGU2
> > +		bool "Kernel low-level debugging on sama5d4"
> > +		depends on HAVE_AT91_DBGU2
> > +
> 
> Why is this Kconfig symbol needed? Nothing in next-20140926 uses it. Are
> future users perhaps queued somewhere (say, in commits that didn't
> survive today's rather lively linux-next merges)?
> 

There is no user because it conflicts with the previous one that is
selected by default by the sama5_defconfig. This is for early print and
it means that you can get earlyprintk either for sama5d3 or sama5d4.

My guess is that it will never be included in any defconfig.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
