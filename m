Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3GTHst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 03:48:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36819 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3GTHss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 03:48:48 -0400
Message-ID: <1374306488.8385.56.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <mturquette@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        <balbi@ti.com>, "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm@vger.kernel.org" <linux-arm-kernel@lists.infradead.org>
Date: Sat, 20 Jul 2013 10:48:08 +0300
In-Reply-To: <1698879.DLaB5pbe5M@avalon>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	 <1372425670.21065.61.camel@cumari.coelho.fi>
	 <1372682370.21065.68.camel@cumari.coelho.fi> <1698879.DLaB5pbe5M@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 01:58 +0200, Laurent Pinchart wrote:
> Hi Luciano,

Hi Laurent,

> On Monday 01 July 2013 15:39:30 Luciano Coelho wrote:
> > The only thing I can come up with is to make a small clock driver (maybe
> > even inside the WiLink module itself) that registers a new type of
> > clock, "ti,wilink-clock" or something.  But this would really be
> > overkill, wouldn't it?
> > 
> > Any other ideas?
> 
> One possibility would be to just call clk_get_rate() on the clock from the 
> WiLink driver, which would return the fixed frequency specified in DT, and 
> configure the WiLink hardware accordingly. This might be a bit hackish though.

The problem is not get the rate itself, the problem is knowing whether
the clock is XTAL or not.  The WiLink chip uses the clock in a slightly
different way if it is XTAL, due to some stabilization time constraints.

--
Luca.

