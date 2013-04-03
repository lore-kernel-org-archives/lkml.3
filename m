Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350Ab3DCJMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:12:15 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36188 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835Ab3DCJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:12:11 -0400
Date: Wed, 3 Apr 2013 11:12:00 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Subject: Re: [PATCH 04/12] usb: phy: ab8500-usb: fix eye diagram for ab8500
 v2.0
Message-ID: <20130403091200.GA3909@balto.lan>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
 <1364978713-19612-5-git-send-email-fabio.baltieri@linaro.org>
 <20130403085336.GJ25837@arwen.pp.htv.fi>
 <20130403085858.GK25837@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403085858.GK25837@arwen.pp.htv.fi>
X-Operating-System: Linux balto 3.9.0-rc4-00218-g0776ce0 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, Apr 03, 2013 at 11:58:58AM +0300, Felipe Balbi wrote:
> On Wed, Apr 03, 2013 at 11:53:36AM +0300, Felipe Balbi wrote:
> > On Wed, Apr 03, 2013 at 10:45:05AM +0200, Fabio Baltieri wrote:
> > > From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
> > > 
> > > AB8500 v2.0 has eye diagram issues when drawing more than 100mA from
> > > VBUS.  Force charging current to 100mA in case of standard host.
> > > 
> > > Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > > ---
> > >  drivers/usb/phy/phy-ab8500-usb.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
> > > index 5b92a59..1fd0780 100644
> > > --- a/drivers/usb/phy/phy-ab8500-usb.c
> > > +++ b/drivers/usb/phy/phy-ab8500-usb.c
> > > @@ -485,6 +485,18 @@ static void ab8500_usb_phy_disable_work(struct work_struct *work)
> > >  		ab8500_usb_peri_phy_dis(ab);
> > >  }
> > >  
> > > +static unsigned ab8500_eyediagram_workaroud(struct ab8500_usb *ab, unsigned mA)
> > > +{
> > > +	/* AB8500 V2 has eye diagram issues when drawing more than 100mA from
> > 
> > wrong comment style. Please run *all* patches through checkpatch.pl
> > --strict and sparse. I can wait 2 more hours before closing my tree for
> > v3.10.
> 
> you know what ? this is simple enough, I'll fix it myself.

Ok, I was rushing a rebase but you've been faster! :-)

Anyway, paches were already sparse and checkpatch checked, but I ignored
a warning for "mA" camelcase (as that's how it's commonly spelled for
regulator) and new line indentation (where I used two-tabs instead of
open parenthesis to be coherent with the rest of the source).

For comment style, checkpatch does not give me any warning for some
reson.  The in-line open style is already used in the net/ subsystem so
I was assuming that it was accepted here too.  If this is not the case
maybe checkpatch.pl has to be fixed somehow.

Thanks,
Fabio

-- 
Fabio Baltieri
