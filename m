Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3BFE54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:57:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48896 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab3BFE5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:57:53 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Lindgren <tony@atomide.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
Thread-Index: AQHN/fOatoDuxwofTUaND8395mrFe5hfx24AgAUeJgCAAACkAIAF8NDQgAASfwCAAWQmgA==
Date: Wed, 6 Feb 2013 04:57:25 +0000
Message-ID: <A4887BF146CD57468F700B415D2F47015831F0@DBDE01.ent.ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
	<1359445134-13323-2-git-send-email-manishv.b@ti.com>
	<CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
	<20130201170906.GE22517@atomide.com>	<20130201171124.GF22517@atomide.com>
	<A4887BF146CD57468F700B415D2F47015828C7@DBDE01.ent.ti.com>
 <CACRpkdYUBGkRRF_nDbn5tGmtZC_Wucqxz_PjWo0xX_KbnQJ5cw@mail.gmail.com>
In-Reply-To: <CACRpkdYUBGkRRF_nDbn5tGmtZC_Wucqxz_PjWo0xX_KbnQJ5cw@mail.gmail.com>
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

Hi Linus

On Tue, Feb 05, 2013 at 18:30:48, Linus Walleij wrote:
> On Tue, Feb 5, 2013 at 7:36 AM, Vishwanathrao Badarkhe, Manish <manishv.b@ti.com> wrote:
> 
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
> 
> This is based on some old code that I wrote ages ago. Check the pinctrl tree or linux-next for the latest core pin grabbing code.
> Use that instead.

Thanks for your reply.
I have checked with your latest changes regarding pinctrl 
in linux-next tree and these changes are working fine for me.

Regards
Manish Badarkhe
