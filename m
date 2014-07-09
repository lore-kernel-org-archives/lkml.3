Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaGIV1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:27:30 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41903 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbaGIV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:27:27 -0400
Date: Wed, 9 Jul 2014 14:27:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Feng Kan <fkan@apm.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>
Subject: Re: [PATCH V8 1/6] power: reset: Add generic SYSCON register mapped
 reset
Message-ID: <20140709212723.GA6737@roeck-us.net>
References: <1404872153-3594-1-git-send-email-fkan@apm.com>
 <1404872153-3594-2-git-send-email-fkan@apm.com>
 <53BCBCEC.7010306@roeck-us.net>
 <CAL85gmB9wRXXrza3g0MBFWUi5w3_eCEhxdSd2FfmoB_SkGA8Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL85gmB9wRXXrza3g0MBFWUi5w3_eCEhxdSd2FfmoB_SkGA8Ww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:15:44PM -0700, Feng Kan wrote:
> On Tue, Jul 8, 2014 at 8:54 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 07/08/2014 07:15 PM, Feng Kan wrote:
> >>
> >> Add a generic SYSCON register mapped reset mechanism.
> >>
> >> Signed-off-by: Feng Kan <fkan@apm.com>
> >> ---
> >>   drivers/power/reset/Kconfig         |  6 +++
> >>   drivers/power/reset/Makefile        |  1 +
> >>   drivers/power/reset/syscon-reboot.c | 91
> >> +++++++++++++++++++++++++++++++++++++
> >>   3 files changed, 98 insertions(+)
> >>   create mode 100644 drivers/power/reset/syscon-reboot.c
> >>
> >> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> >> index bdcf517..5877b38 100644
> >> --- a/drivers/power/reset/Kconfig
> >> +++ b/drivers/power/reset/Kconfig
> >> @@ -80,3 +80,9 @@ config POWER_RESET_KEYSTONE
> >>         help
> >>           Reboot support for the KEYSTONE SoCs.
> >>
> >> +config POWER_RESET_SYSCON
> >> +       bool "Generic SYSCON regmap reset driver"
> >> +       depends on ARM || ARM64 || COMPILE_TEST
> >
> >
> > As written, this driver is really not generic but very arm specific.
> > I don't think COMPILE_TEST is a good idea either, since arm_pm_restart
> > is only defined for the arm architecture. Did you try compiling allmodconfig
> > or allyesconfig for, say, x86_64 with this patch applied ?
> >
> > I think this might benefit from using [1], which would make it really
> > generic.
> >
> > Guenter
> >
> > [1] http://www.spinics.net/lists/kernel/msg1780939.html
> This is great, I will base off this list. Did it make it to a branch anywhere?
> 
Still in review. I hope it will make it into 3.17.
Of course it might be useful if you (and others)
help making the case for it.

Thanks,
Guenter
