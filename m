Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3KWRZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 12:25:53 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46079 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3KWRZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 12:25:50 -0500
Date: Sat, 23 Nov 2013 18:26:12 +0100
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: hub: avoid possible division by zero
Message-ID: <20131123172612.GA17119@sauron.fritz.box>
References: <1385224294-15461-1-git-send-email-morbidrsa@gmail.com>
 <20131123172010.GA8018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123172010.GA8018@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 09:20:10AM -0800, Greg Kroah-Hartman wrote:
> On Sat, Nov 23, 2013 at 05:31:34PM +0100, Johannes Thumshirn wrote:
> > Avoid possible division by zero in led_work, if hdev->maxchild is 0.
> >
> > See also:
> > http://buildbot.llvm.linuxfoundation.org/checker/scan-build-latest/report-b65939.html#EndPath
> >
> > Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> > ---
> >  drivers/usb/core/hub.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index a7c04e2..8c7aa4e 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> > @@ -453,7 +453,8 @@ static void led_work (struct work_struct *work)
> >  	unsigned		changed = 0;
> >  	int			cursor = -1;
> >
> > -	if (hdev->state != USB_STATE_CONFIGURED || hub->quiescing)
> > +	if (hdev->state != USB_STATE_CONFIGURED || hub->quiescing
> > +		|| hdev->maxchild == 0)
>
> And how can maxchild ever be equal to 0?
>
> Look at where it is assigned (it comes from bNbrPorts in the
> descriptor), in hub_configure() and if it is set to 0, the creation of
> the structure fails and then this code will never run, right?
>
> So I don't think this is needed, and your checker needs to be fixed.
>
> sorry,

Args, sorry for the noise. Should've checked that better.
