Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab3JKPSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:18:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61566 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab3JKPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:18:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+SAax2Uf47crMGqSyulbi9
Date: Fri, 11 Oct 2013 08:18:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
Message-ID: <20131011151838.GM29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054221.8941.87801.stgit@localhost>
 <5256AA7F.8030005@ti.com>
 <20131010160018.GA29913@atomide.com>
 <5257BB8C.5080001@ti.com>
 <52580438.4040002@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52580438.4040002@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [131011 07:07]:
> On 10/11/2013 11:49 AM, Roger Quadros wrote:
> > On 10/10/2013 07:00 PM, Tony Lindgren wrote:
> >>
> >> Well the irq_set_wake() should only be needed for suspend and resume. For runtime PM
> >> the wake-events should be always enabled by default as pointed out by Alan Stern
> >> a while back.
> > 
> > Right, but we need to update the WAKEUP_EN bit in the pad control register for that
> > to work, no?. This is something we are not doing in the driver.
> 
> OK sorry, just figured out that we are doing it indeed in pcs_irq_set().
> Wasn't able to test it yet with USB. But I don't see any issues except that
> pcs_soc->rearm() needs to be called from pcs_irq_set() instead of from pcs_irq_unmask().

Hmm that sounds like a different behaviour compared to what I'm seeing
on omap3. Care to send a little fix on top of these patches so I can
test it with my set up too? 

It seems that the only difference would be that we're calling rearm()
after both masking and unmasking, which seemed unnecessary to me earlier.
 
> After that you can add my
> 
> Reviewed-by: Roger Quadros <rogerq@ti.com>

Thanks, for testing, sorry I already pushed them out after Kevin
ran his PM tests on them.

Regards,

Tony
