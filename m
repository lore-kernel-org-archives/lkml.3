Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935423Ab3DHSP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:15:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58746 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935348Ab3DHSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:15:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187OmWOtdJYM77jlzsF4hv6
Date: Mon, 8 Apr 2013 11:15:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <cbou@mail.ru>, Keerthy <j-keerthy@ti.com>,
        Kyle Manna <kyle@kylemanna.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in
 twl4030_madc_conversion
Message-ID: <20130408181524.GU10155@atomide.com>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
 <201303022323.06091@pali>
 <201303241503.29912@pali>
 <201304041132.21158@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304041132.21158@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130404 02:37]:
> On Sunday 24 March 2013 15:03:29 Pali Rohár wrote:
> > On Saturday 02 March 2013 23:23:05 Pali Rohár wrote:
> > > On Friday 15 February 2013 23:56:49 Pali Rohár wrote:
> > > > Driver twl4030-madc has hardcoded channel types (10 -
> > > > battery current, 1 - battery temperature) and also
> > > > conversation data in variable twl4030_divider_ratios.
> > > > These hardcoded channels are incorrect for Nokia RX-51
> > > > board (where is channel 0 - battery temperature).
> > > > 
> > > > For Nokia RX-51 there is rx51_battery power_supply driver
> > > > which reporting battery information via
> > > > twl4030_madc_conversion. But this driver needs raw values
> > > > (not converted via some hardcoded functions). So this
> > > > patch adding new parameter "raw" to struct
> > > > twl4030_madc_request which tell twl4030-madc driver to
> > > > not convert values, but rather return raw.
> > > > 
> > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > > ---
> > > > 
> > > >  drivers/mfd/twl4030-madc.c       |   14 ++++++++++----
> > > >  include/linux/i2c/twl4030-madc.h |    2 ++
> > > >  2 files changed, 12 insertions(+), 4 deletions(-)
> > > 
> > > Hello, can somebody review this twl4030-madc patch?
> > 
> > Bump.
> > 
> > Can some of mfd maintainers look at this patch and include it
> > to mfd tree? It is needed for rx51_battery power supply
> > driver.
> 
> CCing Tony, can you look at this patch?

Sorry for the delay in replying, I've been going through my
inbox for the merge window and noticed this.

I suggest resend with Peter Ujfalusi cc:d as he is the de-facto
twl/tps maintainer and expert by now.

Regards,

Tony
