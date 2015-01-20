Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbbATPMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:12:13 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57560 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752925AbbATPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:12:11 -0500
Date: Tue, 20 Jan 2015 16:12:08 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] ARM: at91: stop using HAVE_AT91_DBGUx
Message-ID: <20150120151208.GI5014@piout.net>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421359100-8930-9-git-send-email-alexandre.belloni@free-electrons.com>
 <54BE2F4D.2080800@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE2F4D.2080800@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2015 at 11:34:53 +0100, Nicolas Ferre wrote :
> Le 15/01/2015 22:58, Alexandre Belloni a écrit :
> > In order to remove SOC_SAM9xxx options, stop using HAVE_AT91_DBGUx.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >  arch/arm/Kconfig.debug     |  6 +++---
> >  arch/arm/mach-at91/Kconfig | 19 -------------------
> >  2 files changed, 3 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > index e34d24949c6a..42a38731da99 100644
> > --- a/arch/arm/Kconfig.debug
> > +++ b/arch/arm/Kconfig.debug
> > @@ -117,17 +117,17 @@ choice
> >  	config AT91_DEBUG_LL_DBGU0
> >  		bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10, 9rl, 9x5, 9n12"
> >  		select DEBUG_AT91_UART
> > -		depends on HAVE_AT91_DBGU0
> > +		depends on SOC_AT91RM9200 || SOC_AT91SAM9
> >  
> >  	config AT91_DEBUG_LL_DBGU1
> >  		bool "Kernel low-level debugging on 9263, 9g45 and sama5d3"
> >  		select DEBUG_AT91_UART
> > -		depends on HAVE_AT91_DBGU1
> > +		depends on SOC_AT91SAM9 || SOC_SAMA5
> >  
> >  	config AT91_DEBUG_LL_DBGU2
> >  		bool "Kernel low-level debugging on sama5d4"
> >  		select DEBUG_AT91_UART
> > -		depends on HAVE_AT91_DBGU2
> 
> These values are used below in the file: in:
> "
> default "debug/at91.S" if AT91_DEBUG_LL_DBGU0 || AT91_DEBUG_LL_DBGU1 || \
>                        AT91_DEBUG_LL_DBGU2
> 
> "
> 
> So I guess there is a little patch missing: I answer to the
> message "[PATCH 5/7] ARM: at91: move debug-macro.S into the common space" by fixing this.
> Please tell me if it's okay.
> 

Your correction was right. The patch correcting that was not part of the
last rebase.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
