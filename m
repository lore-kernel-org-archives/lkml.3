Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3LNBLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 20:11:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:22011 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3LNBLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 20:11:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,482,1384329600"; 
   d="scan'208";a="396554344"
Date: Fri, 13 Dec 2013 17:16:12 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: host: xhci: Move suspend ops under PM_SLEEP to
 avoid warning
Message-ID: <20131214011611.GA15754@psi-dev26.jf.intel.com>
References: <1386896784-23916-1-git-send-email-santosh.shilimkar@ti.com>
 <20131213015133.GA29964@psi-dev26.jf.intel.com>
 <52AA6A60.7050308@ti.com>
 <20131213032555.GA31992@psi-dev26.jf.intel.com>
 <20131213052334.GA2403@psi-dev26.jf.intel.com>
 <52AB9058.7030106@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52AB9058.7030106@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 05:55:20PM -0500, Santosh Shilimkar wrote:
> On Friday 13 December 2013 12:23 AM, David Cohen wrote:
> > On Thu, Dec 12, 2013 at 07:25:55PM -0800, David Cohen wrote:
> >> On Thu, Dec 12, 2013 at 09:01:04PM -0500, Santosh Shilimkar wrote:
> >>> On Thursday 12 December 2013 08:51 PM, David Cohen wrote:
> >>>> On Thu, Dec 12, 2013 at 08:06:24PM -0500, Santosh Shilimkar wrote:
> >>>>> Otherwise you get below build warnings
> >>>>>
> >>>>> drivers/usb/host/xhci-plat.c:201:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
> >>>>> drivers/usb/host/xhci-plat.c:209:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]
> >>>>>
> >>>>> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> >>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>>>> ---
> >>>>>  drivers/usb/host/xhci-plat.c |    4 ++--
> >>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> >>>>> index d9c169f..4875be5 100644
> >>>>> --- a/drivers/usb/host/xhci-plat.c
> >>>>> +++ b/drivers/usb/host/xhci-plat.c
> >>>>> @@ -197,7 +197,7 @@ static int xhci_plat_remove(struct platform_device *dev)
> >>>>>  	return 0;
> >>>>>  }
> >>>>>  
> >>>>> -#ifdef CONFIG_PM
> >>>>> +#ifdef CONFIG_PM_SLEEP
> >>>>
> >>>> Can't you just remove these #ifdefs altogether?
> >>>> xhci_plat_pm_ops is set using SET_SYSTEM_SLEEP_PM_OPS() macro which
> >>>> already handles '#ifdef CONFIG_PM_SLEEP' case.
> >>>>
> >>> It does handle the difference but the hooks implemented would
> >>> show-up un-used warning if you remove the #ifdefs.
> >>>
> >>> drivers/usb/host/xhci-plat.c:200:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
> >>> drivers/usb/host/xhci-plat.c:208:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]
> >>>
> >>> So you need to wrap them under the PM_SLEEP check.
> >>
> >> Yeah... it's not smart enought :)
> >> But you could still remove the #else condition and the ugly DEV_PM_OPS
> >> macro.
> > 
> > Since this patch is not urgent, I sent a RFC proposing smarter
> > SET_*_PM_OPS(). I included your patch (a bit different) here:
> > https://patchwork.kernel.org/patch/3337961/
> > 
> Thats fine by me if you can get your RFC through.

Thanks. I'll keep trying in this case.

Br, David

> 
> Regards,
> Santosh
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
