Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaJOQ5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:57:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:61310 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaJOQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:57:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="400765963"
Date: Wed, 15 Oct 2014 09:57:18 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: be more verbose on ERRATIC_ERROR interrupt
Message-ID: <20141015165718.GB4529@psi-dev26.jf.intel.com>
References: <1413317705-10194-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141015050022.GA2378@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015050022.GA2378@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 12:00:22AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Oct 14, 2014 at 01:15:05PM -0700, David Cohen wrote:
> > ERRATIC_ERROR interrupt is an event that needs more attention from
> > developers than currently implemented, since this indicates a serious
> > stability issue. The only way to get warned about it is by selecting the
> > maximum driver's verbosity.
> > 
> > This patch increases a bit the error's verbosity.
> > 
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > ---
> >  drivers/usb/dwc3/gadget.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 3818b26bfc05..132e761d62e4 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -2484,7 +2484,8 @@ static void dwc3_gadget_interrupt(struct dwc3 *dwc,
> >  		dev_vdbg(dwc->dev, "Start of Periodic Frame\n");
> >  		break;
> >  	case DWC3_DEVICE_EVENT_ERRATIC_ERROR:
> > -		dev_vdbg(dwc->dev, "Erratic Error\n");
> > +		WARN_ON_ONCE(1);
> > +		dev_dbg(dwc->dev, "Erratic Error\n");
> 
> how about:
> 		WARN_ONCE(true, "Erratic Error\n");
> 
> instead ?

When erratic error event happens, in my experience it is usually
followed but many of them in a row. It may end up too verbose.

Br, David

> 
> >  		break;
> >  	case DWC3_DEVICE_EVENT_CMD_CMPL:
> >  		dev_vdbg(dwc->dev, "Command Complete\n");
> > -- 
> > 2.1.0
> > 
> 
> -- 
> balbi


