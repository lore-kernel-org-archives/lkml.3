Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3GXWl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:41:28 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:55063 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab3GXWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:41:27 -0400
Message-ID: <1374705685.29835.15.camel@x61.thuisdomein>
Subject: Re: [PATCH 4/5] SLIP: Add error message for xleft non-zero
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dean Jenkins <Dean_Jenkins@mentor.com>, Andre Naujoks <nautsch2@gmail.com>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Date: Thu, 25 Jul 2013 00:41:25 +0200
In-Reply-To: <20130724221849.GD21709@kroah.com>
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
	 <1372779094-11730-5-git-send-email-Dean_Jenkins@mentor.com>
	 <20130724221849.GD21709@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2013 22:41:26.0881 (UTC) FILETIME=[EE9DDD10:01CE88BE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 15:18 -0700, Greg Kroah-Hartman wrote:
> On Tue, Jul 02, 2013 at 04:31:33PM +0100, Dean Jenkins wrote:
> > Add a printk to show when xleft is non-zero in sl_encaps.
> > 
> > The idea is to see whether a previous SLIP frame failed to be
> > fully transmitted.
> > 
> > Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
> > ---
> >  drivers/net/slip/slip.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> > index f7303e0..e2eff84 100644
> > --- a/drivers/net/slip/slip.c
> > +++ b/drivers/net/slip/slip.c
> > @@ -395,6 +395,10 @@ static void sl_encaps(struct slip *sl, unsigned char *icp, int len)
> >  #endif
> >  		count = slip_esc(p, sl->xbuff, len);
> >  
> > +	if (sl->xleft)
> > +		printk(KERN_ERR "%s: ERROR: xleft is non-zero %d\n",
> > +		       __func__, sl->xleft);
> 
> dev_err() perhaps?

After looking at the commit explanation and the patch itself I wonder
why this should be printed at error level. Especially since patch 3/5
will set sl->xleft to zero immediately after.

So, dev_dbg() perhaps?

And can't this be merged into 3/5?


Paul Bolle  

