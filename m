Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaGJNva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:51:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56213 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752455AbaGJNv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:51:28 -0400
Date: Thu, 10 Jul 2014 15:51:24 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: chipidea: add support to the PHY framework for
 ChipIdea
Message-ID: <20140710135124.GB32462@kwain>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-5-git-send-email-antoine.tenart@free-electrons.com>
 <20140710134227.GL15340@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140710134227.GL15340@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 08:42:27AM -0500, Felipe Balbi wrote:
> On Wed, Jul 09, 2014 at 12:17:16PM +0200, Antoine Ténart wrote:
> > This patch adds the support to the PHY framework for ChipIdea drivers
> > while keeping the USB PHY compatibility. Changes are done in both the
> > ChipIdea common code and in the drivers accessing the PHY. This is done
> > by renaming 'phy' into 'usb_phy' and adding a new 'phy' member into the
> > ci_hdrc structre.
> > 
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> > ---
> >  drivers/usb/chipidea/ci.h          |  4 ++-
> >  drivers/usb/chipidea/ci_hdrc_imx.c |  2 +-
> >  drivers/usb/chipidea/ci_hdrc_msm.c |  6 ++--
> >  drivers/usb/chipidea/core.c        | 67 +++++++++++++++++++++++++++++++-------
> >  drivers/usb/chipidea/debug.c       |  4 ++-
> >  drivers/usb/chipidea/host.c        | 17 ++++++----
> >  drivers/usb/chipidea/otg_fsm.c     |  6 ++--
> >  drivers/usb/chipidea/udc.c         |  4 +--
> >  include/linux/usb/chipidea.h       |  4 ++-
> >  9 files changed, 86 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> > index 9563cb56d564..139589c8ab90 100644
> > --- a/drivers/usb/chipidea/ci.h
> > +++ b/drivers/usb/chipidea/ci.h
> > @@ -201,7 +201,9 @@ struct ci_hdrc {
> >  
> >  	struct ci_hdrc_platform_data	*platdata;
> >  	int				vbus_active;
> > -	struct usb_phy			*transceiver;
> > +	struct phy			*transceiver;
> > +	/* old usb_phy interface */
> > +	struct usb_phy			*usb_transceiver;
> 
> while at that, do you mind calling all struct usb_phy pointers
> 'usb_phy' ?

Not at all.
With s/usb_transceiver/usb_phy/, what about 'transceiver'?


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
