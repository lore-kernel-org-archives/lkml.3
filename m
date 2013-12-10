Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3LJRaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:30:39 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25661 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3LJRah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:30:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.236.217
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/uDh1x8rrHrDl4FEDl4/KH
Date: Tue, 10 Dec 2013 09:30:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>, Joel F <joelf@ti.com>
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: add fail hook for runtime_pm
 when bad data is detected
Message-ID: <20131210173033.GJ13171@atomide.com>
References: <1386121153-32351-1-git-send-email-nm@ti.com>
 <20131205190343.GI26766@atomide.com>
 <87mwka80vu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwka80vu.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@linaro.org> [131209 08:07]:
> Tony Lindgren <tony@atomide.com> writes:
> 
> > * Nishanth Menon <nm@ti.com> [131203 17:40]:
> >> Due to the cross dependencies between hwmod for automanaged device
> >> information for OMAP and dts node definitions, we can run into scenarios
> >> where the dts node is defined, however it's hwmod entry is yet to be
> >> added. In these cases:
> >> a) omap_device does not register a pm_domain (since it cannot find
> >>    hwmod entry).
> >> b) driver does not know about (a), does a pm_runtime_get_sync which
> >>    never fails
> >> c) It then tries to do some operation on the device (such as read the
> >>   revision register (as part of probe) without clock or adequate OMAP
> >>   generic PM operation performed for enabling the module.
> >> 
> >> This causes a crash such as that reported in:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=66441
> >> 
> >> When 'ti,hwmod' is provided in dt node, it is expected that the device
> >> will not function without the OMAP's power automanagement. Hence, when
> >> we hit a fail condition (due to hwmod entries not present or other
> >> similar scenario), fail at pm_domain level due to lack of data, provide
> >> enough information for it to be fixed, however, it allows for the driver
> >> to take appropriate measures to prevent crash.
> >
> > Kevin, any comments on this one?
> 
> Looks like a good approach to catch these corner cases.
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>

Kevin, care to apply this directly?

Acked-by: Tony Lindgren <tony@atomide.com> 
