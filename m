Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaBRQfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:35:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45967 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaBRQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:35:49 -0500
Date: Tue, 18 Feb 2014 10:33:21 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] usb: phy: msm: fix compilation errors when
 !CONFIG_PM_SLEEP
Message-ID: <20140218163321.GE31116@joshc.qualcomm.com>
References: <87lhyemr3y.fsf@linaro.org>
 <1389981531-15539-1-git-send-email-joshc@codeaurora.org>
 <20140117182650.GZ8153@joshc.qualcomm.com>
 <20140218162407.GF9878@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218162407.GF9878@saruman.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:24:16AM -0600, Felipe Balbi wrote:
> On Fri, Jan 17, 2014 at 12:26:50PM -0600, Josh Cartwright wrote:
> > On Fri, Jan 17, 2014 at 11:58:51AM -0600, Josh Cartwright wrote:
> > > Both the PM_RUNTIME and PM_SLEEP callbacks call into the common
> > > msm_otg_{suspend,resume} routines, however these routines are only being
> > > built when CONFIG_PM_SLEEP.  In addition, msm_otg_{suspend,resume} also
> > > depends on msm_hsusb_config_vddcx(), which is only built when
> > > CONFIG_PM_SLEEP.
> > > 
> > > Fix the CONFIG_PM_RUNTIME, !CONFIG_PM_SLEEP case by changing the
> > > preprocessor conditional, and moving msm_hsusb_config_vddcx().
> > > 
> > > While we're here, eliminate the CONFIG_PM conditional for setting
> > > up the dev_pm_ops.
> > > 
> > > This address the following errors Russell King has hit doing randconfig
> > > builds:
> > > 
> > > drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_suspend':
> > > drivers/usb/phy/phy-msm-usb.c:1691:2: error: implicit declaration of function 'msm_otg_suspend'
> > > drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_resume':
> > > drivers/usb/phy/phy-msm-usb.c:1699:2: error: implicit declaration of function 'msm_otg_resume'
> > > 
> > > Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > > ---
> > > v1->v2: Change conditional to simply CONFIG_PM (thanks ccov and khilman!)
> > > 
> > >  drivers/usb/phy/phy-msm-usb.c | 57 ++++++++++++++++++++-----------------------
> > >  1 file changed, 26 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> > > index 8546c8d..5b169a7 100644
> > > --- a/drivers/usb/phy/phy-msm-usb.c
> > > +++ b/drivers/usb/phy/phy-msm-usb.c
> > [..]
> > > @@ -440,7 +414,32 @@ static int msm_otg_reset(struct usb_phy *phy)
> > >  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
> > >  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
> > >  
> > > -#ifdef CONFIG_PM_SLEEP
> > > +#if CONFIG_PM
> > 
> > *sigh*.  This, of course, should have been #ifdef CONFIG_PM.  Fixed
> > v3 below.
> 
> sorry, please git send-email it properly.

No problem, will do.  FWIW, it's applicable with git am --scissors.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
