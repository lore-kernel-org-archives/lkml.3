Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaJKJlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 05:41:11 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48774 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaJKJlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 05:41:08 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Sat, 11 Oct 2014 11:38:19 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, nsekhar@ti.com,
        t-kristo@ti.com, j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] rtc: omap: fixes and power-off feature
Message-ID: <20141011093819.GA18988@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <20141010175409.GL31348@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010175409.GL31348@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 12:54:22PM -0500, Felipe Balbi wrote:
> HI,
> 
> On Thu, Oct 09, 2014 at 09:06:22PM +0200, Johan Hovold wrote:
> > This series fixes a few issues with the omap rtc-driver, cleans up a bit
> > and finally adds support for the PMIC control feature found in some
> > revisions of this RTC IP block.
> > 
> > Ultimately, this allows for powering off the Beaglebone and waking it up
> > again on RTC alarms.
> > 
> > I noticed yesterday that Lokesh Vutla recently posted some patches to
> > add regulator support to this driver. [1] While that series has some
> > issues that needs to be addressed, I still think it could be a good idea
> > to rebase my pmic_power_en patch on top of it as it adds some long
> > overdue device abstraction. That would be needed anyway in order to
> > support the new power-off infrastructure that's in the pipe in a clean
> > way. [2]
> 
> is this power-off feature "RTC-only mode" ?

Yes, I believe so, at least as long as RTC power is maintained. The
pmic_power_en pin can otherwise still be used to power off. 

On the BeagleBone the PMIC can be configured to enter OFF or SLEEP mode
on power off, where the latter (and default) mode keeps the RTC power
supply enabled.

Thanks for the fast review, Felipe.

Johan
