Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500Ab3BIBtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:49:00 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:36908 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760434Ab3BIBs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:48:59 -0500
Date: Fri, 8 Feb 2013 17:45:15 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Axel Lin <axel.lin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] da9030_battery: include notifier.h
Message-ID: <20130209014515.GA9289@lizard.sbx05663.mountca.wayport.net>
References: <1360142098-13124-1-git-send-email-mhocko@suse.cz>
 <20130206140959.GE10254@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130206140959.GE10254@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 03:09:59PM +0100, Michal Hocko wrote:
> Ohh, I have just noticed that this could be introduced by "mm: break
> circular include from linux/mmzone.h" in mm tree.
> Adding Andrew to CC.

The patch is legit, actually. So, I've applied it, thank you!

Anton

> On Wed 06-02-13 10:14:58, Michal Hocko wrote:
> > randconfig complains about:
> > drivers/power/da9030_battery.c:113: error: field ‘nb’ has incomplete type
> > 
> > because there is no direct include for notifier.h which defines
> > struct notifier_block.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  drivers/power/da9030_battery.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
> > index 94762e6..e8c5a39 100644
> > --- a/drivers/power/da9030_battery.c
> > +++ b/drivers/power/da9030_battery.c
> > @@ -22,6 +22,7 @@
> >  
> >  #include <linux/debugfs.h>
> >  #include <linux/seq_file.h>
> > +#include <linux/notifier.h>
> >  
> >  #define DA9030_FAULT_LOG		0x0a
> >  #define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
> > -- 
> > 1.7.10.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
