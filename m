Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbaJ2P5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:57:33 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:43616 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934240AbaJ2P5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:57:30 -0400
Date: Wed, 29 Oct 2014 16:54:22 +0100
From: Johan Hovold <johan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Johan Hovold <johan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141029155422.GI2265@localhost>
References: <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
 <20141028131257.GS2006@localhost>
 <20141028151610.GA12379@n2100.arm.linux.org.uk>
 <20141029123418.GB2265@localhost>
 <5450E9A8.1060506@roeck-us.net>
 <20141029133526.GE2265@localhost>
 <20141029153641.GB20565@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029153641.GB20565@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:36:41AM -0700, Guenter Roeck wrote:
> On Wed, Oct 29, 2014 at 02:35:26PM +0100, Johan Hovold wrote:
> > On Wed, Oct 29, 2014 at 06:20:40AM -0700, Guenter Roeck wrote:
> > > On 10/29/2014 05:34 AM, Johan Hovold wrote:

> > > > And what about any power-off latencies? Should this always be dealt with
> > > > in the power-off handler?
> > > >
> > > > Again, if it's predictable and high, as in the OMAP RTC case, it should
> > > > go in the handler. But what if it's just normal bus latencies
> > > > (peripheral busses, i2c, or whatever people may come up with)?
> > > >
> > > > Should there always be a short delay before calling the next handler?
> > > 
> > > That delay would depend on the individual power-off handler, so I think
> > > the current implementation works just fine (where power-off handlers
> > > implement the delay).
> > 
> > Some don't, and could possibly unknowingly have been relying on the fact
> > that they could return to user space and be powered off at some later
> > time. With systemd that would have caused a panic.
>
> Agreed, but there are two cases to consider: What should be the delay
> before the next power-off handler is called, and what should the system
> do if all power-off handlers fail (or if there are none). The current
> behavior isn't exactly well defined. Ok, with systemd that results in
> a crash, but I am not really sure if one can or should blame systemd
> for that. The discussion about systemd and its philosophy should not
> cloud the fact that power-off behavior isn't exactly well defined.

Sounds like we pretty much agree. See my response to your last mail.

> > Also consider generic power-off handlers such as gpio-poweroff. It
> > currently hard-codes a three-second delay but the actual delay would
> > really be board specific.
> > 
> A configurable delay would address that. The actually required delay
> could be provided in platform data or as devicetree property.

Yep, see mail mentioned above.

Johan
