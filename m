Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3FFWIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:08:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3FFWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:08:42 -0400
Date: Fri, 7 Jun 2013 01:07:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Johannes Schilling <of82ecuq@cip.cs.fau.de>, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 3/6] keucr: migrate printk to dev_dbg/info/warn/err
Message-ID: <20130606220736.GO23987@mwanda>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370535050-7167-4-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370541200.2209.6.camel@joe-AO722>
 <20130606211137.GC28112@mwanda>
 <1370553788.2209.46.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370553788.2209.46.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 02:23:08PM -0700, Joe Perches wrote:
> On Fri, 2013-06-07 at 00:11 +0300, Dan Carpenter wrote:
> > On Thu, Jun 06, 2013 at 10:53:20AM -0700, Joe Perches wrote:
> > > On Thu, 2013-06-06 at 18:10 +0200, Johannes Schilling wrote:
> > > > From: Laura Lawniczak <laura.lawniczak@googlemail.com>
> > > []
> > > > diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
> > > []
> > > > @@ -19,13 +19,13 @@ int ENE_InitMedia(struct us_data *us)
> > > []
> > > > -	printk(KERN_INFO "MiscReg03 = %x\n", MiscReg03);
> > > > +	dev_info(&us->pusb_dev->dev, "MiscReg03 = %x\n", MiscReg03);
> > > 
> > > I suggest adding a few convenience macros to make
> > > this a bit shorter and more likely to fit on a single
> > > line without exceeding 80 cols.
> > > 
> > > Adding something like:
> > > 
> > > #define us_<level>(us, fmt, ...)				\
> > > 	dev_<level>(&us->pusb_dev->dev, fmt, ##__VA_ARGS__)
> > > 
> > > so these uses become
> > > 
> > > 	us_info(us, "MiscReg03\n", MiscReg03);
> > > 
> > > which is shorter and more readable.
> > > 
> > 
> > Wait what?  That's not a readable example.  Why are we passing the
> > MiscReg03 variable when there is no %d in the string?
> 
> 'cause I forgot to add in the  " = %x",  Oops.

Ah, fine.  In that case it's not an unreasonable macro.

I haven't looked at this closely enough to say for sure what option
is easiest or cleanest.

regards,
dan carpenter

