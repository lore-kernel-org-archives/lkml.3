Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3KYMPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:15:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56269 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab3KYMPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:15:33 -0500
Date: Mon, 25 Nov 2013 12:15:29 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "wim@iguana.be" <wim@iguana.be>, "nsekhar@ti.com" <nsekhar@ti.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: Fwd: [PATCH 7/8] watchdog: davinci: add "clocks" property
Message-ID: <20131125121529.GE32081@e106331-lin.cambridge.arm.com>
References: <1383680783-12114-8-git-send-email-ivan.khoronzhuk@ti.com>
 <527A28E8.4010204@ti.com>
 <201311231857.47104.arnd@arndb.de>
 <52932DA1.8040204@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52932DA1.8040204@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:59:45AM +0000, ivan.khoronzhuk wrote:
> On 11/23/2013 07:57 PM, Arnd Bergmann wrote:
> > On Wednesday 06 November 2013, ivan.khoronzhuk wrote:
> >> @@ -7,6 +7,10 @@ Required properties:
> >>   
> >>   - reg : Should contain WDT registers location and length
> >>   
> >> +- clocks: phandle reference to the controller clock.
> >> +         Required only for Keystone arch.
> >> +         See clock-bindings.txt
> >> +
> >>   Optional properties:
> >>   
> >>   - timeout-sec:         Contains the watchdog timeout in seconds
> > 
> > I think it should really be listed under "Optional properties" and the
> > reference to Keystone removed. Note how the binding would need
> > to change otherwise if another platform started to use the clock, which
> > is a little silly.
> > 
> > 	Arnd
> > 
> 
> Ok, I'll move clocks property under "Optional properties" and describe it
> as following:
> 
> Optional properties:
> - timeout-sec : Contains the watchdog timeout in seconds
> - clocks: phandle reference to the controller clock.
> 	  Needed if platform uses clocks.
> 	  See clock-bindings.txt

Nit: clocks aren't just phandles, they have a clock-specifier too (which
might be 0 cells).

Otherwise this looks fine to me.

Mark.
