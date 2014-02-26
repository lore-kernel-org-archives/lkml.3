Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaBZJtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaBZJtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:49:43 -0500
Message-ID: <1393408171.4744.32.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v4 2/2] hyperv-fb: kick off efifb early
From: Gerd Hoffmann <kraxel@redhat.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        KY Srinivasan <kys@microsoft.com>,
        "Abhishek Gupta (LIS)" <abgupta@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Date: Wed, 26 Feb 2014 10:49:31 +0100
In-Reply-To: <5414def7813d4bccbcf1b128b6a5ee46@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1393331320-18147-1-git-send-email-kraxel@redhat.com>
	 <1393331320-18147-3-git-send-email-kraxel@redhat.com>
	 <5414def7813d4bccbcf1b128b6a5ee46@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> > diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c index
> > b7b3dd0..1b11886 100644
> > --- a/drivers/video/hyperv_fb.c
> > +++ b/drivers/video/hyperv_fb.c
> > @@ -683,6 +683,7 @@ static int hvfb_getmem(struct fb_info *info)
> >  		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
> >  		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
> >  	}
> > +	remove_conflicting_framebuffers(info->apertures,
> > KBUILD_MODNAME,
> > +false);
> 
> Thanks for the updates. I'm concerned about, after removing efifb, 
> if synthvid_send_config(hdev) fails, then there will be no video driver
> available.

That may happen, yes.

> Is there a way to bring the generic driver back if 
> synthvid_send_config(hdev) fails?

Not that I know of.

> If no way to recover the generic driver, please limit the early
> remove_conflicting_framebuffers() to Gen2 VM only.

I'll send updated patches once they are tested.

cheers,
  Gerd


