Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbaH0KOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:14:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47070 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393AbaH0KOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:14:49 -0400
Date: Wed, 27 Aug 2014 13:13:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Marc Carino <marc.ceeeee@gmail.com>,
        kernel-janitors@vger.kernel.org, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 11/14] ARM: brcmstb: delete unneeded test before
 of_node_put
Message-ID: <20140827101353.GG5046@mwanda>
References: <1407492475-26283-11-git-send-email-Julia.Lawall@lip6.fr>
 <20140813222212.GB18411@ld-irv-0074>
 <alpine.DEB.2.02.1408140733190.2053@localhost6.localdomain6>
 <20140814065310.GK11952@brian-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814065310.GK11952@brian-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:53:10PM -0700, Brian Norris wrote:
> > > >  cleanup:
> > > > -	if (syscon_np)
> > > > -		of_node_put(syscon_np);
> > > > -
> > > > +	of_node_put(syscon_np);
> > > > +out:
> > > 
> > > Is there a good reason for this new label? I thought part of the point
> > > of this semantic patch is that the previous line (of_node_put()) is a
> > > no-op for NULL arguments.
> > 
> > Personally, I prefer code to only be executed if it needs to be.  It is 
> > helpful from a program analysis point of view, and I think it helps 
> > someone trying to understand the code.
> > 
> > That is, when I am trying to understand some unknown code, I may look at 
> > the cleanup code and try to figure out why each piece of it is executed.  
> > If some of it is statically known to be irrelevant, it is confusing.
> > 
> > But I you think the other way around, and would rather have just one label 
> > that contains anything that might ever be useful, then I guess that is a 
> > reasonable point of view as well.
> 
> Yeah, I personally just look to avoid unnecessary labels.
> 

Having more than one label is better because it helps you avoid "One Err
Bugs".  This is a common kind of bug which is cause when functions have
only one "err:" label which does all the error handling.

Some examples of this type of bug are:
234ad18249a4 ('staging: gdm7240: fix error handling of probe()')
85a258b70d48 ('ocfs2: fix error handling in ocfs2_ioctl_move_extents()')
920c4f4c3651 ('drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_probe()')

If you unwind in the exact reversed order of how things were allocated
then it makes the code a lot easier to understand so it avoids bugs.

regards,
dan carpenter

