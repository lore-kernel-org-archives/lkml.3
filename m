Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3F0WKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:10:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:51186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab3F0WKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,955,1363158000"; 
   d="scan'208";a="360732295"
Date: Thu, 27 Jun 2013 15:05:56 -0700
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] watchdog: Kontron PLD watchdog timer driver
Message-ID: <20130627220556.GB16090@wrk>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-5-git-send-email-kevin.strasser@linux.intel.com>
 <20130627182314.GA16090@wrk>
 <20130627214705.GA26192@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130627214705.GA26192@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Thu, Jun 27, 2013 at 11:47:05PM +0200, Samuel Ortiz wrote:
> Hi Kevin,
> 
> On Thu, Jun 27, 2013 at 11:23:15AM -0700, Kevin Strasser wrote:
> > Hi Wim,
> > 
> > This driver hasn't received any further feedback. Are you ready to take it
> > into watchdog-next, or do you still need to review it?
> I applied the watchdog patch to mfd-next and got the following warning:
> 
>  CC [M]  drivers/watchdog/kempld_wdt.o
> drivers/watchdog/kempld_wdt.c: In function ‘kempld_wdt_suspend’:
> drivers/watchdog/kempld_wdt.c:538:3: warning: passing argument 1 of
> ‘kempld_wdt_stop’ from incompatible pointer type [enabled by default]
> drivers/watchdog/kempld_wdt.c:313:12: note: expected ‘struct
> watchdog_device *’ but argument is of type ‘struct platform_device *’
> 
> I fixed it up, but I'd appreciate if you could double check that
> kempld_wdt_suspend() is ok.

Ah, yes you made the appropriate change. This used to be a call to 
kempld_wdt_shutdown, which I changed to kempld_wdt_stop to avoid the
pointless redirection. Somehow I forgot to convert the argument.

Thanks,
Kevin

> 
> Cheers,
> Samuel.
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/
