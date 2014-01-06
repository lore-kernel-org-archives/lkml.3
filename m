Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaAFJWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:22:36 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:34057 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaAFJWd (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 6 Jan 2014 04:22:33 -0500
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
From: joeyli <jlee@suse.com>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <CAOLK0pynyv2CjA-Jb-0cUMkdnXY8KD2QForsk5ygM1mrRtXOyg@mail.gmail.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <CAOLK0pynyv2CjA-Jb-0cUMkdnXY8KD2QForsk5ygM1mrRtXOyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jan 2014 17:20:53 +0800
Message-ID: <1389000053.3539.6078.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2014-01-02 於 16:09 +0800，Lan Tianyu 提到：
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index bba9b72..3f7a075 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -689,6 +689,9 @@ static int __init acpi_init(void)
> >         pci_mmcfg_late_init();
> >         acpi_scan_init();
> >         acpi_ec_init();
> > +#ifdef CONFIG_X86
> > +       acpi_tad_init();
> > +#endif
> 
> Why calling acpi_tad_init() directly here rather than using
> module_initcall?
> Is there dependency?
> 

The rtc-acpitad RTC driver depend on acpi_read/set_time functions in
acpi_tad.

On the other hand, if we adapt to ACPI time device when "CMOS RTC Not
Present" set, then acpi_read/set_time will used to replace CMOS
functions that's called by other drivers. So, I direct call
acpi_tad_init() here.


Thanks a lot!
Joey Lee

