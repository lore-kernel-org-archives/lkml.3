Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaLIW3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:29:46 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaLIW3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:29:45 -0500
Date: Thu, 4 Dec 2014 03:40:44 -0800
From: Darren Hart <dvhart@infradead.org>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Javi Merino <javi.merino@arm.com>, linux-pm@vger.kernel.org
Subject: Re: [RESEND PATCH v5 3/5] acerhdf: Use bang-bang thermal governor
Message-ID: <20141204114044.GB100190@vmdeb7>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1417184452-11884-1-git-send-email-peter@piie.net>
 <1417184452-11884-4-git-send-email-peter@piie.net>
 <20141203090436.GC52608@vmdeb7>
 <cone.1417677032.220767.18692.1000@mups>
 <cone.1417677666.882029.18692.1000@mups>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1417677666.882029.18692.1000@mups>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 08:21:06AM +0100, Peter Feuerer wrote:
> Hi again,
> 
> Peter Feuerer writes:
> 
> >Hi Darren,
> >
> >thank you very much for your reply.
> >
> >
> >Darren Hart writes:
> >
> >>On Fri, Nov 28, 2014 at 03:20:50PM +0100, Peter Feuerer wrote:
> >>>acerhdf has been doing an on-off fan control using hysteresis by
> >>>post-manipulating the outcome of thermal subsystem trip point handling.
> >>>This patch enables acerhdf to use the bang-bang governor, which is
> >>>intended for on-off controlled fans.
> >>>
> >>>Cc: platform-driver-x86@vger.kernel.org
> >>>Cc: Darren Hart <dvhart@infradead.org>
> >>>Cc: Andrew Morton <akpm@linux-foundation.org>
> >>>CC: Zhang Rui <rui.zhang@intel.com>
> >>>Cc: Andreas Mohr <andi@lisas.de>
> >>>Cc: Javi Merino <javi.merino@arm.com>
> >>>Acked-and-tested-by: Borislav Petkov <bp@suse.de>
> >>>Signed-off-by: Peter Feuerer <peter@piie.net>
> >>>---
> >>> drivers/platform/x86/Kconfig   |  3 ++-
> >>> drivers/platform/x86/acerhdf.c | 36 +++++++++++++++++++++++++++++++-----
> >>> 2 files changed, 33 insertions(+), 6 deletions(-)
> >>>
> >>>diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> >>>index a2eabe6..c173266 100644
> >>>--- a/drivers/platform/x86/Kconfig
> >>>+++ b/drivers/platform/x86/Kconfig
> >>>@@ -38,7 +38,8 @@ config ACER_WMI
> >>> config ACERHDF
> >>> 	tristate "Acer Aspire One temperature and fan driver"
> >>>-	depends on THERMAL && ACPI
> >>>+	select THERMAL_GOV_BANG_BANG
> >>
> >>So we use select sparingly as it does implicit things.
> >>
> >>I checked the THERMAL_GOV_BANG_BANG Kconfig entry, and the help says acerhdf
> >>already depends on it (which it doesn't appear to). Any particular reason to add
> >>select here instead of adding it as a depends.
> >>
> >>Why did you drop THERMAL?
> >
> >I had it like this in my first version of patches:
> >+ depends on THERMAL && ACPI && THERMAL_GOV_BANG_BANG
> >
> >But after some discussion with lkml community we ended up with the select
> >line and dropped THERMAL dependency, as it is implied by
> >THEMAL_GOV_BANG_BANG.  I'm not so experienced with Kconfig, so I must rely
> >on the statements of the community in this case.
> 
> Just found the link about this discussion I had with Rui and Boris:
> http://linux-kernel.2935.n7.nabble.com/PATCH-0-4-acerhdf-thermal-adding-new-models-and-appropriate-governor-tp848572p908256.html
> 

Rui,

I see you said you agree with the approach to "select THERMAL_GOV_BANG_BANG",
and I'm OK with that. But that doesn't ensure, as far as I can see, a
sufficient set of Kconfig dependencies for ACERHDF as THERMAL_GOV_BANG_BANG
doesn't in turn select THERMAL.

While it's unlikely to get ACERHDF available without THERMAL enabled, it does
look possible. Should this driver also select or depends on THERMAL?

Maybe:

depends on ACPI
depends on THERMAL
select THERMAL_GOV_BANG_BANG

?

> [...]
> 
> -- 
> kind regards,
> --peter;
> 

-- 
Darren Hart
Intel Open Source Technology Center
