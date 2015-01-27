Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbbA0M6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:58:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:57015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545AbbA0M6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:58:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,474,1418112000"; 
   d="scan'208";a="643227396"
Date: Tue, 27 Jan 2015 14:57:39 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>, Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Message-ID: <20150127125739.GF28539@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
 <20150124235811.GA24665@psi-dev26.jf.intel.com>
 <20150126125503.GB28539@kuha.fi.intel.com>
 <20150126192337.GA13936@psi-dev26.jf.intel.com>
 <20150127092856.GD28539@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127092856.GD28539@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

> I'm only using the init and exit hooks instead of just
> power_on/power_off because I'm not sure which the controllers will
> use. For example, now dwc3 calls phy_init() in it's resume routine and
> not phy_power_on() like I would expect. I know the problem has been
> pointed out by others, so I'm expecting we'll get guidelines for it
> later. But before we do, I see no harm in having both init and
> power_on hooks in this driver.

I'm unable to find the thread where somebody mentioned that, but I
don't actually think there is any reason why we couldn't just call
phy_power_on/off instead of phy_init/exit in dwc3_suspend/resume like
I think we should. I'll add one more patch where I'll change it.

Felipe, is it OK?


Thanks,

-- 
heikki
