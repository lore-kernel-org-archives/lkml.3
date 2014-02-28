Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaB1CxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:53:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:33986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaB1CxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:53:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="489645354"
Date: Fri, 28 Feb 2014 08:22:35 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140228025235.GA27921@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-4-git-send-email-jenny.tc@intel.com>
 <20140204113640.GD2450@amd.pavel.ucw.cz>
 <20140220051655.GB2498@jenny-desktop>
 <20140221144529.GB5238@amd.pavel.ucw.cz>
 <20140226025444.GA21449@jenny-desktop>
 <CACRpkdYQuggnUU+3JrxG9oA5_CRnbfT0aVL=L3K0QPrVzZTD-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYQuggnUU+3JrxG9oA5_CRnbfT0aVL=L3K0QPrVzZTD-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:47:07PM +0100, Linus Walleij wrote:
> On Wed, Feb 26, 2014 at 3:54 AM, Jenny Tc <jenny.tc@intel.com> wrote:
> 
> > The idea is to allow pluggable charging algorithms. Currently we have only one
> > charging algorithm proposed, but can have other charging algorithms (like pulse
> > charging, rule based charging etc.). Based on the platform need, the algorithms
> > can be selected. So this should be a user configurable option. I can add more
> > explanation on when to select this option.
> 
> Do you see a generic framework for pluggable algorithms on an abstracted
> level, so that it could be used for the CC/CV charging, measurement and
> temperature check algorithm that is found in e.g.
> drivers/power/abx500_chargalg.c
> drivers/power/ab8500_charger.c etc, or do you envision a set of pluggable
> algorithms for this one hardware?
> 
> I'm asking because these drivers are a massive set of code and we may
> need to start to abstract out and define library functions and frameworks
> already now before it becomes impossible to contain.

The idea of power_supply_charger driver is to move the charging logic outside of
the charger chip driver. This makes the charger chip driver as a  h/w
abstraction layer without  having any charging logic in it. power supply charger
driver invokes charging algorithm to decide the CC, CV and to stop/start
charging on different conditions (based on voltage/temperature ...). Detailed
note on using power supply charger driver can be found in
Documentation/power/power_supply_charger.txt  which is part of patch
power_supply-Introduce-generic-psy-charging-driver.patch
