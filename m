Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3A2MD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:03:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51482 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3A2MD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:03:26 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "tony@atomide.com" <tony@atomide.com>, "hs@denx.de" <hs@denx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
 module_exit
Thread-Topic: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
 module_exit
Thread-Index: AQHN/fOatoDuxwofTUaND8395mrFe5hfx24AgABkn2A=
Date: Tue, 29 Jan 2013 12:02:54 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701581AE9@DBDE01.ent.ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
	<1359445134-13323-2-git-send-email-manishv.b@ti.com>
 <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
In-Reply-To: <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
Accept-Language: en-IN, en-US
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

Hi Linus,

On Tue, Jan 29, 2013 at 16:29:54, Linus Walleij wrote:
> On Tue, Jan 29, 2013 at 8:38 AM, Vishwanathrao Badarkhe, Manish <manishv.b@ti.com> wrote:
> 
> > Currently, I2C driver gets probed before pinctrl driver.
> > To achieve I2C pin muxing via pinctrl driver before I2C probe get 
> > called, register pinctrl driver in arch_initcall.
> > Also, add module_exit to unregister pinctrl driver.
> >
> > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> 
> So your I2C driver is not returning -EPROBE_DEFER if it cannot find its pins?
Yes. In Davinci I2C driver, it's not implemented to return -EPROBE_DEFER if it 
can't find its pins.

Please see below discussion for more details: 
https://patchwork2.kernel.org/patch/2031321/
 
> 
> Hm, well I can live with this, if Tony ACKs it.
> 
> Yours,
> Linus Walleij
> 


Regards, 
Manish
