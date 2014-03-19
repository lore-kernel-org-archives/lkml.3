Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbaCSB10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:27:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:62947 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980AbaCSB1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:27:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,681,1389772800"; 
   d="scan'208";a="501623143"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Chew, Kean Ho" <kean.ho.chew@intel.com>,
        "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] pwm: add support for Intel Low Power Subsystem PWM
Thread-Topic: [PATCH v2] pwm: add support for Intel Low Power Subsystem PWM
Thread-Index: AQHPQr8XoOKYPqnxMka3HgVtjsxWsZrnnitw
Date: Wed, 19 Mar 2014 01:25:34 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA01568555@PGSMSX103.gar.corp.intel.com>
References: <1393599057-26451-1-git-send-email-chiau.ee.chew@intel.com>
 <20140318152855.GA7237@mithrandir>
In-Reply-To: <20140318152855.GA7237@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 28, 2014 at 10:50:57PM +0800, Chew Chiau Ee wrote:
> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > Add support for Intel Low Power I/O subsystem PWM controllers found on
> > Intel BayTrail SoC.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Chew, Kean Ho <kean.ho.chew@intel.com>
> > Signed-off-by: Chang, Rebecca Swee Fun
> > <rebecca.swee.fun.chang@intel.com>
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > ---
> >  drivers/pwm/Kconfig    |   10 +++
> >  drivers/pwm/Makefile   |    1 +
> >  drivers/pwm/pwm-lpss.c |  179
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 190 insertions(+), 0 deletions(-)  create mode
> > 100644 drivers/pwm/pwm-lpss.c
> 
> Sorry for taking so long to get back to you on this. Things have been somewhat
> crazy lately.
> 
> This generally looks very good, but I found two issues that escaped last time.
> See below.
>
> > diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
> [...]
> > +static int pwm_lpss_config(struct pwm_chip *chip, struct pwm_device *pwm,
> > +			   int duty_ns, int period_ns)
> > +{
> > +	struct pwm_lpss_chip *lpwm = to_lpwm(chip);
> > +	u8 on_time_div;
> > +	unsigned long c = clk_get_rate(lpwm->clk);
> > +	unsigned long long base_unit, freq = NSECS_PER_SEC;
> > +	u32 ctrl;
> > +
> > +	do_div(freq, period_ns);
> > +
> > +	/* The equation is: base_unit = ((freq / c) * 65536) + correction */
> > +	base_unit = freq * 65536;
> > +	do_div(base_unit, c);
> 
> clk_get_rate() can return 0, so perhaps it would be safer to check for the
> validity of c before dividing by it. This will probably never happen for your
> driver or platform, but people may look at your driver for inspiration at some
> point, so it should still be handling this correctly.

Agreed. Will update the code accordingly.

> > +MODULE_DESCRIPTION("PWM driver for Intel LPSS");
> MODULE_AUTHOR("Mika
> > +Westerberg <mika.westerberg@linux.intel.com>");
> > +MODULE_LICENSE("GPLv2");
> 
> I think this needs to be "GPL v2".

Ok. Will update this as well.

Thanks for your review!

> 
> Thierry
