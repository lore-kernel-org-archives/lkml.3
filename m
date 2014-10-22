Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaJVQYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:24:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65262 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaJVQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:24:08 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 22 Oct 2014 18:21:04 +0200
From: Johan Hovold <johan@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Johan Hovold <johan@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] rtc: omap: fixes and power-off feature
Message-ID: <20141022162104.GB2381@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <20141010175409.GL31348@saruman>
 <20141011093819.GA18988@localhost>
 <20141011190817.GA20644@atomide.com>
 <20141022110758.GO2113@localhost>
 <20141022152956.GI2542@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022152956.GI2542@atomide.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 08:29:56AM -0700, Tony Lindgren wrote:
> * Johan Hovold <johan@kernel.org> [141022 04:12]:
> > On Sat, Oct 11, 2014 at 12:08:18PM -0700, Tony Lindgren wrote:
> > > * Johan Hovold <johan@kernel.org> [141011 02:42]:
> > > > On Fri, Oct 10, 2014 at 12:54:22PM -0500, Felipe Balbi wrote:
> > > > > 
> > > > > is this power-off feature "RTC-only mode" ?
> > > > 
> > > > Yes, I believe so, at least as long as RTC power is maintained. The
> > > > pmic_power_en pin can otherwise still be used to power off. 
> > > > 
> > > > On the BeagleBone the PMIC can be configured to enter OFF or SLEEP mode
> > > > on power off, where the latter (and default) mode keeps the RTC power
> > > > supply enabled.
> > > > 
> > > > Thanks for the fast review, Felipe.
> > > 
> > > Great :) I assume adding the regulator support to this driver should
> > > also help in the 35xx case?
> > 
> > If I remember correctly both OMAP and Sitara 35xx have no on-chip RTC so
> > they won't be using this driver.
> 
> Sorry I made a typo.. I meanto to ask if adding the regulator
> helps in your 335x case (not 35xx case)?

Ah, sorry, that's what I first read before I noticed you wrote "35xx"
twice. :)

Yes, RTC power can be configured as a regulator on am33xx (e.g. provided
by LDO1 of the PMIC on BBB). I guess you would still need to configure
it as always-on to be able to use the RTC-only mode, though.

Johan
