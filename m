Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaJORET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:04:19 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37206 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaJORER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:04:17 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 15 Oct 2014 19:06:28 +0200
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
Message-ID: <20141015170628.GA13824@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <20141015165452.GB15770@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015165452.GB15770@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 11:55:02AM -0500, Felipe Balbi wrote:
> Hi,
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
> > 
> > So my suggestion is to merge the first seven patches, rebase Lokesh
> > series on top of that, and then I rebase my final five patches on top
> > of that in turn. Hopefully, the new power-off handler call chain will
> > have stabilised by then.
> 
> BTW, how do you test this series ?

Set a 30 second wakealarm using the sysfs attribute of the rtc class
device and power off the BBB:

	echo +30 >wakealarm; poweroff

Johan
