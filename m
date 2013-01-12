Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3ALMw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 07:52:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:16180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3ALMwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 07:52:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,456,1355126400"; 
   d="scan'208";a="271271684"
Date: Sat, 12 Jan 2013 04:28:26 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@linux.jf.intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 01/16] dw_dmac: call .probe after we have a
 device in place
Message-ID: <20130112122825.GW19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1357719435-29955-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130109134757.GN19691@intel.com>
 <CAHp75VfFyX=Pz3xRt15n6ffP=v0pa413BFF2zHGoiQowG1kKVg@mail.gmail.com>
 <20130109153848.GT19691@intel.com>
 <20130109180427.GA13897@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109180427.GA13897@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 08:04:28PM +0200, Mika Westerberg wrote:
> 
> If the platform device is not yet created (like it might be when it is
> enumerated from ACPI for example), the probe fails completely. Certainly
> not the situation we want.
> 
> Calling platform_driver_register() handles both cases properly.
Yes this is fix for that kind of problem. But the main issue I am concerned
about is that devices should have created much before drivers started loading.
Obviosuly due to SPI/DMA dependencies we have to do this.

--
~Vinod
