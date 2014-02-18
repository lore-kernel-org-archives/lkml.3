Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaBROa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:30:56 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:42011 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaBROay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:30:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Levente Kurusa <levex@linux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media <linux-media@vger.kernel.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Archana kumari <archanakumari959@gmail.com>,
        David Binderman <dcb314@hotmail.com>
Subject: Re: [PATCH] staging: davinci_vpfe: fix error check
Date: Tue, 18 Feb 2014 15:32:03 +0100
Message-ID: <7270574.TJsfU1PaQa@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140215171619.GA22985@leaf>
References: <1392459431-28203-1-git-send-email-levex@linux.com> <20140215171619.GA22985@leaf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

(Removing Greg, Mauro and the devel@driverdev.osuosl.org list to avoid 
spamming them)

On Saturday 15 February 2014 09:16:19 Josh Triplett wrote:
> On Sat, Feb 15, 2014 at 11:17:11AM +0100, Levente Kurusa wrote:
> > The check would check the pointer, which is never less than 0.
> > According to the error message, the correct check would be
> > to check the return value of ipipe_mode. Check that instead.
> > 
> > Reported-by: David Binderman <dcb314@hotmail.com>
> > Signed-off-by: Levente Kurusa <levex@linux.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Could you please handle this patch ?

> >  drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> > b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c index
> > 2d36b60..b2daf5e 100644
> > --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> > +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> > @@ -267,7 +267,7 @@ int config_ipipe_hw(struct vpfe_ipipe_device *ipipe)
> > 
> >  	}
> >  	
> >  	ipipe_mode = get_ipipe_mode(ipipe);
> > -	if (ipipe < 0) {
> > +	if (ipipe_mode < 0) {
> >  		pr_err("Failed to get ipipe mode");
> >  		return -EINVAL;
> >  	}

-- 
Regards,

Laurent Pinchart

