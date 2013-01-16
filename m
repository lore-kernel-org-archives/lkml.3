Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3APMPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:15:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39130 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab3APMPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:15:07 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH 1/2] pwm: pwm-tiehrpwm: Low power sleep support
Thread-Topic: [PATCH 1/2] pwm: pwm-tiehrpwm: Low power sleep support
Thread-Index: AQHN7zLYj+sKmHr0jEa75GwTxmATpphIEW8AgAPQThA=
Date: Wed, 16 Jan 2013 12:14:01 +0000
Deferred-Delivery: Wed, 16 Jan 2013 12:14:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA5DF80@DBDE01.ent.ti.com>
References: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
 <1357823024-17585-2-git-send-email-avinashphilip@ti.com>
 <20130114070855.GA21994@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130114070855.GA21994@avionic-0098.adnet.avionic-design.de>
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

On Mon, Jan 14, 2013 at 12:38:56, Thierry Reding wrote:
> On Thu, Jan 10, 2013 at 06:33:43PM +0530, Philip Avinash wrote:
> [...]
> > diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
> [...]
> > +static int ehrpwm_pwm_suspend(struct device *dev)
> > +{
> > +	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
> > +
> > +	ehrpwm_pwm_context_save(pc);
> > +	pm_runtime_put_sync(dev);
> > +	return 0;
> > +}
> > +
> > +static int ehrpwm_pwm_resume(struct device *dev)
> > +{
> > +	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
> > +
> > +	pm_runtime_get_sync(dev);
> > +	ehrpwm_pwm_context_restore(pc);
> > +	return 0;
> > +}
> 
> According to Documentation/power/runtime_pm.txt, the PM core runs the
> pm_runtime_get_noresume() and pm_runtime_put_sync() before executing the
> .suspend() and .resume() callbacks. Are you sure you need to call them
> here explicitly?

I understand the problem of calling pm_runtime_get_sync() from .resume().
But this has to be called if pwm was running while going to suspend so that
pwm can continues to run after resume.

So I will add check of test_bit(PWMF_ENABLED, &pwm->flags) before 
pm_runtime_get/put_sync calls.

Thanks
Avinash

> 
> Thierry
> 

