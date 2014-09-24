Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaIXJv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:51:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:37139 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaIXJvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:51:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,588,1406617200"; 
   d="scan'208";a="596096017"
Date: Wed, 24 Sep 2014 12:50:52 +0300
From: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
To: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
Message-ID: <20140924095052.GZ1786@lahna.fi.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-2-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20140918111705.GM10854@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBDB28B@PGSMSX108.gar.corp.intel.com>
 <20140922092528.GM1786@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBDBA92@PGSMSX108.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B33AC5ED75F74F991980326F1C438D0FBDBA92@PGSMSX108.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:55:07AM +0000, Chang, Rebecca Swee Fun wrote:
> > > The register values are required when it comes to IRQ handling. By
> > > passing in the registers values, we can make full use of the
> > > algorithms without introducing extra/similar algorithms to compute
> > > other register offset values.
> > > For example, we have other offset values to handle such as:-
> > > GTPE	0x0C
> > > GTNE	0x10
> > > GGPE	0x14
> > > GSMI	0x18
> > > GTS	0x1C
> > > CGNMIEN	0x40
> > > RGNMIEN	0x44
> > 
> > Well, can we at least call it something else than sch_gpio_enable()?
> > Perhaps sch_gpio_set_value() or so?
> 
> sch_gpio_set_value() sounds good. After think twice, I intend to merge
> sch_gpio_enable() and sch_gpio_disable() into one functions. Using
> variable "enable" as an indicator, I can control whether to enable or
> disable when calling the function. Here is my draft:

Actually sch_gpio_set_value() is too close to sch_gpio_set() which sets
the GPIO to 1 or 0. How about sch_gpio_register_set() or something along
those lines?

And I don't think it is good idea to add yet another functionality, like
enable there. Please leave sch_gpio_enable()/sch_gpio_disable() as is.
