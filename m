Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3LKIJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:09:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:43682 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3LKIJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:09:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="448158511"
Date: Wed, 11 Dec 2013 10:09:06 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH RFC 1/4] phy: Add provision for tuning phy.
Message-ID: <20131211080906.GC28456@xps8300>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
 <1386672926-26885-2-git-send-email-gautam.vivek@samsung.com>
 <20131210140142.GB28456@xps8300>
 <CAFp+6iENkrSUT=_iv+uZnVpDSGDQGOzF_oyZ6Dmzr8VcQfjztw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFp+6iENkrSUT=_iv+uZnVpDSGDQGOzF_oyZ6Dmzr8VcQfjztw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 11, 2013 at 12:08:04PM +0530, Vivek Gautam wrote:
> On Tue, Dec 10, 2013 at 7:31 PM, Heikki Krogerus
> > I think "setup" instead of "tune" is much more clear and reusable.
> 
> I think "setup" will look more like first time setting up the phy,
> which is rather served by "init" callback.
> This i thought would serve the purpose of over-riding certain PHY
> parameters, which would not have been
> possible at "init" time.
> Please correct my thinking if i am unable to understand your point here.

OK, sorry I was not clear on this. I'm thinking the same, that this is
something that is called later, for example when the controller is
ready. Some ULPI phys need to be initialized, but since the controller
provides the interface, it's usually not possible during init time.
This hook could be used in that case as well.

All I'm saying is that "tune" is a poor expression. You will need to
add a comment explaining what the hook does in any case, so you'll
have something like "this is something that is called when the
controller is ready" or something similar. That will make it clear
what it's meant for.

Thanks,

-- 
heikki
