Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3FFVXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:23:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48948 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753117Ab3FFVXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:23:09 -0400
Message-ID: <1370553788.2209.46.camel@joe-AO722>
Subject: Re: [PATCH 3/6] keucr: migrate printk to dev_dbg/info/warn/err
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Schilling <of82ecuq@cip.cs.fau.de>, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Date: Thu, 06 Jun 2013 14:23:08 -0700
In-Reply-To: <20130606211137.GC28112@mwanda>
References: <20130605094517.GS28112@mwanda>
	 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
	 <1370535050-7167-4-git-send-email-of82ecuq@cip.cs.fau.de>
	 <1370541200.2209.6.camel@joe-AO722> <20130606211137.GC28112@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 00:11 +0300, Dan Carpenter wrote:
> On Thu, Jun 06, 2013 at 10:53:20AM -0700, Joe Perches wrote:
> > On Thu, 2013-06-06 at 18:10 +0200, Johannes Schilling wrote:
> > > From: Laura Lawniczak <laura.lawniczak@googlemail.com>
> > []
> > > diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
> > []
> > > @@ -19,13 +19,13 @@ int ENE_InitMedia(struct us_data *us)
> > []
> > > -	printk(KERN_INFO "MiscReg03 = %x\n", MiscReg03);
> > > +	dev_info(&us->pusb_dev->dev, "MiscReg03 = %x\n", MiscReg03);
> > 
> > I suggest adding a few convenience macros to make
> > this a bit shorter and more likely to fit on a single
> > line without exceeding 80 cols.
> > 
> > Adding something like:
> > 
> > #define us_<level>(us, fmt, ...)				\
> > 	dev_<level>(&us->pusb_dev->dev, fmt, ##__VA_ARGS__)
> > 
> > so these uses become
> > 
> > 	us_info(us, "MiscReg03\n", MiscReg03);
> > 
> > which is shorter and more readable.
> > 
> 
> Wait what?  That's not a readable example.  Why are we passing the
> MiscReg03 variable when there is no %d in the string?

'cause I forgot to add in the  " = %x",  Oops.

> You're a big fan of custom printk macros but it's better if people
> can stick the to the normal ones if possible.  In this case, just
> using a local variable is enough:
> 
> 	dev_dbg(us_dev, "scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
> 
> 79 characters.

<shrug>  Now you need another line to set the local var
in each function.  If there's only a few functions that'd
be fine.

> Anyway this could fixed in a later patch.

True, but if there are a lot of files patched separately,
putting the macro in an appropriate header first saves a
lot of follow up patches.

