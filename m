Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaDWNZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:25:35 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59848 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaDWNZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:25:33 -0400
Message-ID: <1398259477.4724.218.camel@iivanov-dev>
Subject: Re: [PATCH v6 15/19] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Felipe Balbi <balbi@ti.com>, Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Date: Wed, 23 Apr 2014 16:24:37 +0300
In-Reply-To: <53566A23.8010508@cogentembedded.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
	 <1398158438-21579-16-git-send-email-iivanov@mm-sol.com>
	 <53566A23.8010508@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2014-04-22 at 17:09 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 22-04-2014 13:20, Ivan T. Ivanov wrote:
> 
> > From: Tim Bird <tbird20d@gmail.com>
> 
> > Fix the value used for Parallel Transceiver Select (PTS) for the MSM USB
> > controller.  This is a standard chipidea PORTSC definition, where
> > a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
> > Fix the definitions and use them correctly in the driver code.
> 
> > Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> > ---
> >   drivers/usb/phy/phy-msm-usb.c    | 8 +++++---
> >   include/linux/usb/msm_hsusb_hw.h | 5 +++--
> >   2 files changed, 8 insertions(+), 5 deletions(-)
> 
> > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> > index dababf9..e83d13a 100644
> > --- a/drivers/usb/phy/phy-msm-usb.c
> > +++ b/drivers/usb/phy/phy-msm-usb.c
> > @@ -287,8 +287,9 @@ static int msm_link_reset(struct msm_otg *motg)
> >   	if (motg->phy_number)
> >   		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);
> >
> > +	/* put transciever in serial mode as part of reset */
> 
>     s/transciever/transceiver/
> 
> [...]
> 
> > diff --git a/include/linux/usb/msm_hsusb_hw.h b/include/linux/usb/msm_hsusb_hw.h
> > index 575c743..98d3dd8 100644
> > --- a/include/linux/usb/msm_hsusb_hw.h
> > +++ b/include/linux/usb/msm_hsusb_hw.h
> > @@ -31,8 +31,9 @@
> >   #define USB_USBINTR          (MSM_USB_BASE + 0x0148)
> >
> >   #define PORTSC_PHCD            (1 << 23) /* phy suspend mode */
> > -#define PORTSC_PTS_MASK         (3 << 30)
> > -#define PORTSC_PTS_ULPI         (3 << 30)
> > +#define PORTSC_PTS_MASK        (3 << 30)
> > +#define PORTSC_PTS_ULPI        (2 << 30)
> > +#define PORTSC_PTS_SERIAL      (3 << 30)
> 
>     Please use tabs, not spaces here.

Thanks, will fix and resend.

Ivan

> 
> WBR, Sergei
> 


