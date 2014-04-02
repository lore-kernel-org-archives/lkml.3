Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095AbaDBXWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161080AbaDBXW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:22:29 -0400
Date: Wed, 2 Apr 2014 16:18:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] drivercore: deferral race condition fix
Message-ID: <20140402231857.GB26696@kroah.com>
References: <1393398414-10822-1-git-send-email-peter.ujfalusi@ti.com>
 <20140301003320.GA31852@kroah.com>
 <53143CD3.30209@ti.com>
 <20140304045626.GK2411@sirena.org.uk>
 <533BB04E.9000206@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533BB04E.9000206@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 09:38:06AM +0300, Peter Ujfalusi wrote:
> Hi Greg,
> 
> On 03/04/2014 06:56 AM, Mark Brown wrote:
> > On Mon, Mar 03, 2014 at 10:26:59AM +0200, Peter Ujfalusi wrote:
> > 
> >> I think it is correct to detect this situation without the need to have non
> >> related drivers to be probed.
> >> The patch is doing this exactly: detects if we had successful parallel driver
> >> probe(s) while another driver was probing which ends up requesting to be
> >> deferred. We only try the deferred list again if this condition has been
> >> detected, we do not loop on the deferred list, we do not try the list again if
> >> there were no other drivers loaded since nothing happened which could satisfy
> >> the driver asking to be deferred.
> > 
> > It's certainly the simplest approach I can think of - anything else
> > would seem to involve looking to see if we're running deferred probes
> > and trying to add things to the list while that's going on which seems
> > like it might be hairy.
> 
> Do you want me to resend this patch in hope that it is going to be taken or do
> you have other method in mind to deal with the situation I have described and
> fixed with this patch?

Can you resend, I've totally lost the idea of the original patch.  And
if others agree with it, getting acks from them (like Grant) would be
great.

thanks,

greg k-h
