Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3ILAJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:09:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47063 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3ILAJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:09:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>, "Li, Fei" <fei.li@intel.com>
Subject: Re: [PATCH] ACPI / osl: implement acpi_os_sleep() with msleep()
Date: Thu, 12 Sep 2013 02:20:31 +0200
Message-ID: <1956828.ud2cRdZZYe@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B1F71E@SHSMSX101.ccr.corp.intel.com>
References: <1378921377.26153.26.camel@cliu38-desktop-build> <37297227.So9eVdeflb@vostro.rjw.lan> <27240C0AC20F114CBF8149A2696CBE4A01B1F71E@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 11, 2013 11:55:53 PM Liu, Chuansheng wrote:
> Hello Rafael,
> 
> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > Sent: Wednesday, September 11, 2013 8:37 PM
> > To: Liu, Chuansheng
> > Cc: lenb@kernel.org; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Li, Zhuangzhi; Li, Fei
> > Subject: Re: [PATCH] ACPI / osl: implement acpi_os_sleep() with msleep()
> > 
> > On Thursday, September 12, 2013 01:42:57 AM Chuansheng Liu wrote:
> > >
> > > Currently the acpi_os_sleep() is using the schedule_timeout_interruptible(),
> > > which can be interrupted by signal, which causes the real sleep time is
> > shorter.
> > >
> > > According to the ACPI spec:
> > > The Sleep term is used to implement long-term timing requirements.
> > > Execution is delayed for at least the required number of milliseconds.
> > >
> > > The sleeping time should be at least of the required number msecs, here
> > > using msleep() to implement it.
> > >
> > > Also if the real time is shorter, we meet the device POWER ON issue.
> > 
> > What exactly is the "power on" issue?
> The case is we have one device _PS0 method in platform.asl like below:
> Write the pmcsr REG to power on;
> Sleep 10ms;
> Read some registers;
> ...
> 
> Here sometimes the actual sleeping time is < 10ms, it causes the following
> actions failed due this device
> need 10ms to power on successfully.

I see.

OK, I'll queue up your patch for 3.13.

Thanks,
Rafael

