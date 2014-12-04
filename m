Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbaLDSZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:25:16 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41341 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932464AbaLDSZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:25:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/wJFLgeBUHJFe+t//N29iv
Date: Thu, 4 Dec 2014 10:23:03 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] i2c: omap: new fixes 2
Message-ID: <20141204182302.GH2817@atomide.com>
References: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Kochetkov <al.kochet@gmail.com> [141203 06:36]:
> This pacth series intended for fixing problem reported
> by Tony Lindgren <tony@atomide.com> here[1]
> 
> One of first four patched could fix the problem.
> Last patch provide event trace so I could resolve problem.
> It could be applied using 'git am' or 'patch -p1 ...'
> 
> Patches are rebased on branch 'i2c/for-next' of
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
> (6e79807443cba7397cd855ed29d6faba51d4c893)
> 
> Tony, could you check, does the series fix the problem reported[1]?
> If yes, could you bisect and point commit that solve.
> If no, could you provide trace output (with or without the patches
> from series).
> If no, could you check does i2c-omap.c from commit ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4.
> (the commit before my changes to kernel) work for you?

It seems this is not related to your patches. Applying these
cause the following though on my 2430sdp:

omap_i2c 48072000.i2c: addr: 0x004b, len: 2, flags: 0x0, stop: 1
omap_i2c 48072000.i2c: XFER0: STAT=0x0000; IE=0x601f; CON=0x8000; (omap_i2c_xfer_msg:705)
omap_i2c 48072000.i2c: XFER1: STAT=0x0010; IE=0x601f; CON=0x8600; (omap_i2c_xfer_msg:707)
omap_i2c 48072000.i2c: THR: STAT=0x1410; IE=0x601f; CON=0x8600; (omap_i2c_isr_thread:1016)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: THR: STAT=0x1000; IE=0x601f; CON=0x8600; (omap_i2c_isr_thread:1016)
omap_i2c 48072000.i2c: THR DONE: STAT=0x1004; IE=0x601f; CON=0x8600; (omap_i2c_isr_thread:1168)
omap_i2c 48072000.i2c: THR: STAT=0x1004; IE=0x601f; CON=0x8600; (omap_i2c_isr_thread:1016)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: THR: STAT=0x1000; IE=0x601f; CON=0x8602; (omap_i2c_isr_thread:1016)
omap_i2c 48072000.i2c: THR DONE: STAT=0x1000; IE=0x601f; CON=0x8602; (omap_i2c_isr_thread:1168)
omap_i2c 48072000.i2c: XFER TIMEOUT: STAT=0x1000; IE=0x601f; CON=0x8602; (omap_i2c_xfer_msg:716)
omap_i2c 48072000.i2c: controller timed out
twl: Write failed (mod 3, reg 0x0e count 1)

Regards,

Tony

> [1] http://www.spinics.net/lists/linux-i2c/msg17811.html
> 
> Alexander Kochetkov (5):
>   i2c: omap: ack only reported events
>   i2c: omap: simplify i462 errata handling for NACK and AL cases
>   i2c: omap: move STP generation logic into ISR thread
>   i2c: omap: reimpelement STP hack via 2-phases transfer
>   i2c: omap: add trace
> 
>  drivers/i2c/busses/i2c-omap.c |  162 ++++++++++++++++++++++++-----------------
>  1 file changed, 95 insertions(+), 67 deletions(-)
> 
> -- 
> 1.7.9.5
> 
