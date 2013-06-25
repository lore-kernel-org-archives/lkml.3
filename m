Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FYL4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:56:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49271 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3FYL4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:56:22 -0400
Message-ID: <1372161370.18889.13.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: <balbi@ti.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm@vger.kernel.org>
Date: Tue, 25 Jun 2013 14:56:10 +0300
In-Reply-To: <20130625111234.GJ15407@arwen.pp.htv.fi>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	 <20130625111234.GJ15407@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 14:12 +0300, Felipe Balbi wrote:
> On Tue, Jun 25, 2013 at 11:35:30AM +0300, Luciano Coelho wrote:
> > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > +  following:
> > +	0 = 19.200 MHz
> > +	1 = 26.000 MHz
> > +	2 = 38.400 MHz
> > +	3 = 52.000 MHz
> > +	4 = 16.368 MHz
> > +	5 = 32.736 MHz
> > +	6 = 16.800 MHz
> > +	7 = 33.600 MHz
> 
> DTS files are pre-processed, so you could add defines in a header and
> share the header between DTS and driver. Could help you having:
> 
> tcxoclock = WILINK_19_200MHz;
> 
> instead of
> 
> tcxoclock = 0;

I don't see any .dts file really doing this.  There are some imx*.dtsi
files that include imx*.h files, but I don't see these headers being
included in any source code file.

In fact, we already have all these values defined in
include/linux/wl12xx.h, so it could be nice to reuse.  But the
cross-directory includes would look "funny".  And I think it's a bit
overkill.

These values are actually used by the firmware itself, not only the
driver, so they are also platform independent and not related to the OS.

--
Luca.

