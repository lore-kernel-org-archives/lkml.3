Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3IQPn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:43:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43563 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3IQPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:43:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qAk7/qVKfgfoZrVyVsjYq
Date: Tue, 17 Sep 2013 08:43:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "nm@ti.com" <nm@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "pdeschrijver@nvidia.com" <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/2] ARM: OMAP: Add secure function omap_smc3()
 which calling instruction smc #1
Message-ID: <20130917154331.GA9994@atomide.com>
References: <20130916171023.GA17477@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130916171023.GA17477@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Martin <Dave.Martin@arm.com> [130916 10:18]:
> On Sat, Sep 14, 2013 at 10:37:12AM +0100, Pali Rohár wrote:
> > On Sunday 08 September 2013 09:43:29 Pali Rohár wrote:
> > > + */
> > > +ENTRY(omap_smc3)
> > > +	stmfd	sp!, {r4-r11, lr}
> > > +	mov	r12, r0		@ Copy the secure service ID
> > > +	mov	r6, #0xff	@ Indicate new Task call
> > > +	dsb			@ Memory Barrier (not sure if needed, copied from
> > > omap_smc2) +	smc	#1		@ Call PPA service
> > > +	ldmfd	sp!, {r4-r11, pc}
> > > +ENDPROC(omap_smc3)
> > > +
> > >  ENTRY(omap_modify_auxcoreboot0)
> > >  	stmfd   sp!, {r1-r12, lr}
> > >  	ldr	r12, =0x104
> > 
> > Dave, it is ok now?
> 
> Yes, that's sufficient to warn people to stop and think (at least, if
> someone copy-pastes it, they will likely highlight the possible error by
> copy-pasting the comment too).  Thanks.
> 
> Acked-by: Dave Martin <Dave.Martin@arm.com>

Have you guys checked how this works with the recently posted
"[PATCH v6 0/5] ARM: support for Trusted Foundations secure monitor"
series?

Regards,

Tony
 
