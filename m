Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3GXQsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:48:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3GXQsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:48:17 -0400
Date: Wed, 24 Jul 2013 09:48:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        bob.liu@oracle.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] zcache: fix "zcache=" kernel parameter
Message-ID: <20130724164816.GA4050@kroah.com>
References: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
 <20130724150627.GF15095@kroah.com>
 <1940908.YDS0uX8aZx@amdc1032>
 <5294696.DFxsrtntLy@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5294696.DFxsrtntLy@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 05:50:29PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> On Wednesday, July 24, 2013 05:39:20 PM Bartlomiej Zolnierkiewicz wrote:
> > 
> > On Wednesday, July 24, 2013 08:06:27 AM Greg KH wrote:
> > > On Wed, Jul 24, 2013 at 01:54:56PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > 
> > > > On Wednesday, July 24, 2013 01:41:57 PM Michal Hocko wrote:
> > > > > On Wed 24-07-13 12:32:32, Bartlomiej Zolnierkiewicz wrote:
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > On Wednesday, July 24, 2013 12:04:41 PM Michal Hocko wrote:
> > > > > > > On Wed 24-07-13 12:02:35, Michal Hocko wrote:
> > > > > > > > I have posted a similar fix quite some time ago and I guess Greg should
> > > > > > > > already have it.
> > > > > > > 
> > > > > > > For reference https://lkml.org/lkml/2013/6/26/410
> > > > > > 
> > > > > > There was a reply from Greg:
> > > > > > 
> > > > > > 	https://lkml.org/lkml/2013/6/26/410
> > > > > 
> > > > > I guess you meant https://lkml.org/lkml/2013/6/26/569
> > > > 
> > > > Uh, yes.
> > > > 
> > > > > > and it seems that Greg's request has not been fullfilled.
> > > > > 
> > > > > Bob Liu has resent the patch (I cannot find the email in the archive).
> > > > 
> > > > Indeed, I've found it here:
> > > > 
> > > > http://comments.gmane.org/gmane.linux.kernel.mm/102484
> > > > 
> > > > > > Anyway Piotr's patch seems to be more complete:
> > > > > > - it also fixes case in which invalid "zcache=" option is given (returns
> > > > > >   an error value 1 while with your patch the code still erronously retuns 0)
> > > > > > - it prints information about compressor type being used when "zcache="
> > > > > >   option is used (your patch skips it due to addition of "goto out_alloc")
> > > > > 
> > > > > I do not care which one will make it I just pointed out that there is
> > > > > another patch dealing with the same and it is a question how far that
> > > > > one went.
> > > > 
> > > > OK.
> > > > 
> > > > Greg, could you please pick Piotr's patch?
> > > 
> > > Wait, I'm going to take the first one I got, from Michal, as that's the
> > > original author here, not Piotr...
> > > 
> > > confused, and really grumpy about the whole zcache mess...
> > 
> > Just get the second one (from Piotr) as it is more complete (it fixes
> > also problem with invalid data being given to "zcache=" option or chosen
> > compressor not being supported by Crypto API).
> > 
> > I feel a bit sad that this newer patch makes Michal's one obsolete but
> > I don't have a good idea how to resolve it in other way while sticking to
> > "chose the best technical solution" principle. :(
> > 
> > Oh, wait. I updated patch (attached below) to give Michal & Cristian some
> > credit (also added Konrad's Acked-by while at it). I hope that this is
> > an acceptable solution.
> 
> Michal/Cristian, are you fine with that?  Could you please Ack this patch?
>  
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> > 
> > 
> > From: Piotr Sarna <p.sarna@partner.samsung.com>
> > Subject: [PATCH] zcache: fix "zcache=" kernel parameter
> 
> ...
> 
> This time with fixed Bob's email address and better link to an old
> patch. Sorry for that.
> 
> From: Piotr Sarna <p.sarna@partner.samsung.com>
> Subject: [PATCH] zcache: fix "zcache=" kernel parameter

Now, can you resend it in a format that doesn't require me to hand-edit
the patch?  As I deal with thousands of patches every kernel release, I
can't clean up the mess by hand and expect to stay sane...

thanks,

greg k-h
