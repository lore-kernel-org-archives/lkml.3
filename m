Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaGUJhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:37:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:58918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbaGUJhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:37:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,699,1400050800"; 
   d="scan'208";a="546528195"
Message-ID: <1405935426.2455.5.camel@rzhang1-toshiba>
Subject: Re: [PATCH v4 3/6] thermal: Added Bang-bang thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Date: Mon, 21 Jul 2014 17:37:06 +0800
In-Reply-To: <20140721092950.GB10016@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
	 <1405817480-25347-1-git-send-email-peter@piie.net>
	 <1405817480-25347-4-git-send-email-peter@piie.net>
	 <20140721092950.GB10016@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 11:29 +0200, Borislav Petkov wrote:
> On Sun, Jul 20, 2014 at 02:51:17AM +0200, Peter Feuerer wrote:
> > The bang-bang thermal governor uses a hysteresis to switch abruptly on
> > or off a cooling device.  It is intended to control fans, which can
> > not be throttled but just switched on or off.
> > Bang-bang cannot be set as default governor as it is intended for
> > special devices only.  For those special devices the driver needs to
> > explicitely request it.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Andreas Mohr <andi@lisas.de>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Javi Merino <javi.merino@arm.com>
> > Signed-off-by: Peter Feuerer <peter@piie.net>

For thermal related patches, please do cc linux-pm mailing list so that
I can see them in patchwork.

thanks,
rui
> > ---
> >  drivers/thermal/Kconfig         |  10 +++
> >  drivers/thermal/Makefile        |   1 +
> >  drivers/thermal/gov_bang_bang.c | 131 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/thermal/thermal_core.c  |   5 ++
> >  drivers/thermal/thermal_core.h  |   8 +++
> >  5 files changed, 155 insertions(+)
> >  create mode 100644 drivers/thermal/gov_bang_bang.c
> > 
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index f9a1386..cdddf09 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -84,6 +84,16 @@ config THERMAL_GOV_STEP_WISE
> >  	  Enable this to manage platform thermals using a simple linear
> >  	  governor.
> >  
> > +config THERMAL_GOV_BANG_BANG
> > +	bool "Bang Bang thermal governor"
> > +	default y
> 
> Right, this is problematic.
> 
> When people are faced with the new selection after doing oldconfig, they
> can say yes or no.
> 
> However, as acerhdf depends on it now, prompting the user to
> unconditionally says yes is kinda redundant. Especially as this governor
> is not supposed to be default anyway.
> 
> Actually you don't need the Kconfig prompt at all as this is a sort-of
> "internal" governor and devices select it. IOW, it should be "default n"
> and ACERHDF will do "select THERMAL_GOV_BANG_BANG". Something like that
> at least.
> 


