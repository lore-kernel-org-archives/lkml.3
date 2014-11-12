Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaKLVVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:21:21 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11701 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307AbaKLVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:21:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/vIG7/iqfmfjAsGkUyfApf
Date: Wed, 12 Nov 2014 13:20:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141112212027.GK26481@atomide.com>
References: <20141102180756.GH31454@atomide.com>
 <5458D29E.50908@compulab.co.il>
 <20141104154231.GP31454@atomide.com>
 <CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
 <515E660B-B65D-41EF-97F5-74E4DE8FDD13@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515E660B-B65D-41EF-97F5-74E4DE8FDD13@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dr. H. Nikolaus Schaller <hns@goldelico.com> [141112 12:28]:
> Am 12.11.2014 um 16:45 schrieb Grazvydas Ignotas <notasas@gmail.com>:
> > On Tue, Nov 4, 2014 at 5:42 PM, Tony Lindgren <tony@atomide.com> wrote:
> > 
> > Pandora does, as well as GTA04 AFAIK,
> 
> Yes. The trick is that the power level that turns on the device is a little higher
> and the battery provides enough energy for approx. 30 seconds until it drained
> to a level where it turns off. Depending on general setup (WIFI must remain
> powered off after boot) this is enough to boot into Linux and start full charging.
> Another trick is to modify MLO and U-Boot to raise the charging current.

Depending on the device and the boot-up speed this seems to work only when
connected to a Linux PC though. AFAIK Windows PCs enforce the 100mA USB power
limit until the device is enumerated which can keep the device in an eternal
reboot loop not being able to ever get the charging going :)
 
> > guess.. At least pandora was booting up on charger connect up until
> > now.
> 
> Same for GTA04.

See the comments I posted earlier today. Have you guys tried the $subject
patch with v3.18-rc series?

It sounds like these comments are based on just reading the patch. Or
else I'm missing something related to some other regression that's
probably unrelated to the $subject patch?

> >> We could consider exporting a function for the charger driver to
> >> configure the poweron mask. And we could also consider passing a
> >> mask in ti,use_poweroff = 0xff.
> 
> Yes, exporting these masks would be fine - if a board needs a non-default
> setup.
 
It seems we've been missing all kind of things. We probably should
first power off any the board specific GPIO regulators. Then configure
the power-up sequence for the board. And then finally call the
twl4030_power_off().

Regards,

Tony
