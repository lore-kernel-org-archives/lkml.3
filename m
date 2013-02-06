Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3BFGEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:04:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51540 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3BFGEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:04:49 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Tony Lindgren <tony@atomide.com>, Linus Walleij <linus.walleij@linaro.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
	module_exit
Thread-Topic: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
	module_exit
Thread-Index: AQHOA5PRbLOgMKi70k6HSt7PoXXIN5hsVo0A
Date: Wed, 6 Feb 2013 06:04:22 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701583209@DBDE01.ent.ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
 <1359445134-13323-2-git-send-email-manishv.b@ti.com>
 <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
 <20130201170906.GE22517@atomide.com> <20130201171124.GF22517@atomide.com>
 <A4887BF146CD57468F700B415D2F47015828C7@DBDE01.ent.ti.com>
 <20130205112731.GK17786@n2100.arm.linux.org.uk>
In-Reply-To: <20130205112731.GK17786@n2100.arm.linux.org.uk>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, Feb 05, 2013 at 16:57:31, Russell King - ARM Linux wrote:
> On Tue, Feb 05, 2013 at 06:36:34AM +0000, Vishwanathrao Badarkhe, Manish wrote:
> > I made following changes, in order to update "dip->p" pointer with 
> > correct value:
> > 
> > -       if (!dpi->p) {
> > +       if (IS_ERR_OR_NULL(dpi->p)) {
> >                 dpi->p = devm_pinctrl_get(dev);
> > -               if (IS_ERR_OR_NULL(dpi->p)) {
> > -                       int ret = PTR_ERR(dpi->p);
> > -
> > -                       dev_dbg(dev, "no pinctrl handle\n");
> > -                       /* Only return deferrals */
> > -                       if (ret == -EPROBE_DEFER)
> > -                               return ret;
> > -                       return 0;
> > -               }
> > +               ret = PTR_ERR(dpi->p);
> > +               dev_dbg(dev, "no pinctrl handle\n");
> > +               /* Only return deferrals */
> > +               if (ret == -EPROBE_DEFER)
> > +                       return ret;
> > +               return 0;
> > 
> > Is this intended change?
> 
> The above looks totally broken to me.
> 
> Oh, it's using IS_ERR_OR_NULL(), so it's bound to be broken.
> 

I went through discussion in community on usage of "IS_ERR_OR_NULL".
https://patchwork.kernel.org/patch/1953271/
Will take care not use this in future.

Thanks,
Manish
