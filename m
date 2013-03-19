Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3CSK2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:28:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50753 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab3CSK2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:28:21 -0400
Date: Tue, 19 Mar 2013 10:28:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Will Deacon <will@willdeacon.co.uk>, Lokesh Vutla <lokeshvutla@ti.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if
 system supports 'has_ossr'
Message-ID: <20130319102803.GB22452@mudshark.cambridge.arm.com>
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com>
 <51406BA7.8010306@arm.com>
 <51407120.7030709@ti.com>
 <51417E58.5050501@ti.com>
 <20130315050014.GA15706@tiny-lites>
 <5146B972.1010002@ti.com>
 <20130318150724.GC28585@mudshark.cambridge.arm.com>
 <514736D4.4070906@ti.com>
 <20130318170649.GA29585@mudshark.cambridge.arm.com>
 <5148082A.3060503@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5148082A.3060503@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 06:39:38AM +0000, Santosh Shilimkar wrote:
> On Monday 18 March 2013 10:36 PM, Will Deacon wrote:
> > Any chance you could follow up with your firmware/hardware guys about this
> > please? I'd really like to understand how we end up in this state in case we
> > can do something in the architecture to stop it from happening in future.
> > 
> I will check on this part and update you when I hear from them.

Ok, thanks.

Dietmar -- I seem to remember that you thought GDB did actually work with
hardware breakpoints on Pandaboard across low-power states. Can you
confirm/deny this please?

> > Well, we could just add the warn_once prints but that doesn't stop debug
> > from breaking after the first pm/suspend/hotplug operation.
> > 
> Probably we should drop the $subject patch approach and use warn_once
> at least for current rc. Ofcourse it doesn't help to get working
> hw_breakpoint support. Patch end of the email with warn_once.

Yeah, I'll merge that, but it's a real shame that this breaks hardware debug
on one of the few platforms where it was reported to work.

Will
