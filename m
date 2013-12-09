Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3LII44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:56:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:17522 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760769Ab3LII4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:56:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,856,1378882800"; 
   d="scan'208";a="446851254"
Message-ID: <1386579383.1871.102.camel@smile>
Subject: Re: [PATCH] SFI: fix compilation warnings
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Dec 2013 10:56:23 +0200
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802494B99@SHSMSX101.ccr.corp.intel.com>
References: <1386264397-27319-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1419818.3DzaCCe02K@vostro.rjw.lan>
	 <1AE640813FDE7649BE1B193DEA596E8802494B65@SHSMSX101.ccr.corp.intel.com>
	 <1790293.cpW4sKD6m8@vostro.rjw.lan>
	 <1AE640813FDE7649BE1B193DEA596E8802494B99@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 01:51 +0000, Zheng, Lv wrote:
> > From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> > Sent: Friday, December 06, 2013 10:01 AM
> > To: Zheng, Lv
> > Cc: Andy Shevchenko; Wysocki, Rafael J; linux-acpi@vger.kernel.org; LKML
> > Subject: Re: [PATCH] SFI: fix compilation warnings
> > 
> > On Friday, December 06, 2013 01:26:07 AM Zheng, Lv wrote:
> > > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > > Sent: Friday, December 06, 2013 9:26 AM
> > > >
> > > > On Friday, December 06, 2013 01:08:45 AM Zheng, Lv wrote:
> > > > > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > > > > Sent: Friday, December 06, 2013 6:37 AM
> > > > > >
> > > > > > On Thursday, December 05, 2013 07:26:37 PM Andy Shevchenko wrote:
> > > > > > > When build kernel with make W=1 we get the following compiler error.
> > > > > > >
> > > > > > > In file included from drivers/sfi/sfi_acpi.c:66:0:
> > > > > > > include/linux/sfi_acpi.h: In function ‘acpi_sfi_table_parse’:
> > > > > > > include/linux/sfi_acpi.h:72:2: error: implicit declaration of function ‘acpi_table_parse’ [-Werror=implicit-function-declaration]
> > > > > > >   if (!acpi_table_parse(signature, handler))
> > > > > > >   ^
> > > > > > >   cc1: some warnings being treated as errors
> > > > > > >
> > > > > > > The patch changes acpi/acpi.h inclusion to linux/acpi.h.
> > > > > > >
> > > > > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > > >
> > > > > > OK
> > > > > >
> > > > > > Lv, I'm dropping your patch cleaning up the inclusions, please sort that thing
> > > > > > out entirely for the next cycle.
> > > > >
> > > > > No, I think Andy's patch is wrong.
> > > >
> > > > His patch may be wrong, but the warning in his changelog surely is real. :-)
> > > >
> > > > > This warning is existing before merging my fixes.
> > > > >
> > > > > Either we fix this warning or leave it as is.
> > > > >
> > > > > To fix it, you need to add 1 line in sfi_acpi.h rather than change the line.
> > > > > Let me post a fix for this.
> > > >
> > > > Please do.  And I'm putting all ACPI header cleanups on hold until all warnings
> > > > of this kind have been fixed by them.  Otherwise doing those cleanups makes a
> > > > little sense in my opinion.
> > >
> > > OK, not only this warning, there is another warning in sfi_acpi.c.
> > > I doubt whether they are strictly tested before upstreamed...
> > > They are all existing warnings.
> > > You can apply my new patch before the cleanup series.
> > 
> > Sorry, I'm already lost in the thick of patches. :-)
> > 
> > Please resend them all as a single series.
> 
> OK, I'll sort them again.

First of all, you are right. We have to have acpi/acpi.h _and_
linux/acpi.h in sfi_acpi.h.

Please, also check this one:
http://www.mail-archive.com/linux-gpio@vger.kernel.org/msg01521.html


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

