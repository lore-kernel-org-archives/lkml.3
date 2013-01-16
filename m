Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3APMPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:15:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40214 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3APMPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:15:06 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH 2/2] pwm: pwm-tiecap: Low power sleep support
Thread-Topic: [PATCH 2/2] pwm: pwm-tiecap: Low power sleep support
Thread-Index: AQHN7zLZngBaM9ff00qnZXHpH1rHFZhIEeQAgAPU0HA=
Date: Wed, 16 Jan 2013 12:13:59 +0000
Deferred-Delivery: Wed, 16 Jan 2013 12:14:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA5DF7A@DBDE01.ent.ti.com>
References: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
 <1357823024-17585-3-git-send-email-avinashphilip@ti.com>
 <20130114071034.GB21994@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130114071034.GB21994@avionic-0098.adnet.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:40:34, Thierry Reding wrote:
> On Thu, Jan 10, 2013 at 06:33:44PM +0530, Philip Avinash wrote:
> > In low power modes of AM33XX platforms, peripherals power is cut off.
> > This patch supports low power sleep transition support for ECAP driver.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > ---
...
> > +struct ecap_regs {
> > +	u32	cap3;
> > +	u32	cap4;
> > +	u16	ecctl2;
> > +};
> 
> Perhaps name this ecap_context for consistency with the EHRPWM driver?

I will correct it.

> 
> > +void ecap_pwm_save_reg(struct ecap_pwm_chip *pc)
> > +{
> > +	pm_runtime_get_sync(pc->chip.dev);
> > +	pc->ctx.ecctl2 = readw(pc->mmio_base + ECCTL2);
> > +	pc->ctx.cap4 = readl(pc->mmio_base + CAP4);
> > +	pc->ctx.cap3 = readl(pc->mmio_base + CAP3);
> > +	pm_runtime_put_sync(pc->chip.dev);
> > +}
> > +
> > +void ecap_pwm_restore_reg(struct ecap_pwm_chip *pc)
> > +{
> > +	writel(pc->ctx.cap3, pc->mmio_base + CAP3);
> > +	writel(pc->ctx.cap4, pc->mmio_base + CAP4);
> > +	writew(pc->ctx.ecctl2, pc->mmio_base + ECCTL2);
> > +}
> 
> Then rename these ecap_pwm_{save,restore}_context()?

I will correct in next version.

...

> Same comment as for the EHRPWM driver applies here.

I will correct in next version

Thanks
Avinash

> 
> Thierry
> 

