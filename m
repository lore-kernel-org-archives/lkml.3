Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104Ab3E2R6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:58:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:65231 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934764Ab3E2R6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:58:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>, James Hogan <james.hogan@imgtec.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51940CAF.6010808@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
References: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
 <51940CAF.6010808@codeaurora.org>
Message-ID: <20130529175827.6058.16653@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC 0/2] clk: add metag specific gate/mux clocks
Date: Wed, 29 May 2013 10:58:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2013-05-15 15:31:11)
> On 05/10/13 08:02, James Hogan wrote:
> > This adds a metag architecture specific clk-gate and clk-mux which
> > extends the generic ones to use global lock2 to protect the register
> > fields. It is common with metag to have an RTOS running on a different
> > thread or core with access to different bits in the same register (which
> > contain clock gate/switch bits for other clocks). Access to such
> > registers must be serialised with a global lock such as the one provided
> > by the metag architecture port in <asm/global_lock.h>
> >
> > RFC because despite extending the generic clocks there's still a bit of
> > duplicated code necessary. One alternative is to add special cases to
> > the generic clock components for when a global or callback function
> > based lock is desired instead of a spinlock, but I wasn't sure if that
> > sort of hack would really be appreciated in the generic drivers.
> >
> > Comments?
> 
> Can you please Cc the devicetree mailing list when proposing new bindings?
> 
> Your patchset brings up a question I've had which is if we should be
> putting the bits and register width information in devicetree at all. On
> the one hand it's nice to not have anything in C code, just iterate over
> nodes and register clocks. On the other hand, it's the first time I've
> seen anyone put the register interface into devicetree. From what I can
> tell, the regulator bindings have put at most the register base and
> physical properties like enable-time, max voltage, etc., but not what
> bits are needed to enable/disable a regulator. Also I thought I read
> somewhere that reg properties shouldn't overlap each other, so if you
> ever have two clocks living in the same register we're going to violate
> that.
> 

I've written bindings for the generic mux-clock, divider-clock, and I'm
working on a gate-clock (reusing some RFCs from a while back for
gate-clock).  All of these specify the base address as well as the
relevant bit fields.  To me this seems to intuitively describe the
hardware.  I'll post these bindings soon and let the bike shedding
begin.

Regards,
Mike

> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
