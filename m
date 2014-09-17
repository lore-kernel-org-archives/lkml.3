Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaIQIjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:39:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:47369 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaIQIjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:39:02 -0400
Message-ID: <5419489C.9090607@linutronix.de>
Date: Wed, 17 Sep 2014 10:38:52 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <20140912224324.GK18849@atomide.com> <5416D2A0.5020407@linutronix.de> <541833C0.5020106@linutronix.de> <20140916164858.GA1580@atomide.com> <20140916213043.GB6672@atomide.com>
In-Reply-To: <20140916213043.GB6672@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 11:30 PM, Tony Lindgren wrote:
> Found one more issue when booting on 2420 n8x0, maybe something to do
> with runtime PM?
To some degree, yes.

> [    4.770507] Internal error: Oops - undefined instruction: 0 [#1]
SMP ARM

  e3a02000        mov     r2, #0
  ee072fba        mcr     15, 0, r2, cr7, cr10, {5}
  e3a01001        mov     r1, #1
  f5d3f000        pld     [r3]
=>e1d30f9f        ldrexb  r0, [r3]

That ldrexb is part of the xchg() function in serial8250_rpm_get_tx().
So it looks like 2420 n8x0 does not understand ldrexb but the inline
assembly decided that it should.

This OMAP2420 should be ARM1136 / ARMv6. The ARM1136J(F)-S TRM says for
ldrexb: "This command is only available from the rev1 (r1p0) release of
the ARM1136JF-S processor."

So it looks like the CPU should know what to do when this opcode comes
around.

> 
> Regards,
> 
> Tony
> 

Sebastian
