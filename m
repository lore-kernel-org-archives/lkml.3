Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3GIQXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:23:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab3GIQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:23:49 -0400
Subject: Re: [PATCH 3/3] firmware/dmi_scan: Constify strings
From: Jean Delvare <jdelvare@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1373385495.14604.4.camel@joe-AO722>
References: <1373384438.4391.6.camel@chaos.site>
	 <1373384634.4391.10.camel@chaos.site>  <1373385495.14604.4.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 09 Jul 2013 18:23:32 +0200
Message-ID: <1373387012.4391.14.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Le Tuesday 09 July 2013 à 08:58 -0700, Joe Perches a écrit :
> On Tue, 2013-07-09 at 17:43 +0200, Jean Delvare wrote:
> > Add const to all DMI string pointers where this is possible. This
> > fixes a checkpatch warning.
> 
> That's a nice little improvement.

Thanks.

> > +++ linux-3.10-rc0/drivers/firmware/dmi_scan.c	2013-05-04 11:20:52.808187924 +0200
> []
> > @@ -252,7 +252,7 @@ static void __init dmi_save_oem_strings_
> >  	struct dmi_device *dev;
> >  
> >  	for (i = 1; i <= count; i++) {
> > -		char *devname = dmi_string(dm, i);
> > +		const char *devname = dmi_string(dm, i);
> >  
> >  		if (devname == dmi_empty_string)
> 
> btw: that last test sure looks like it would be
>      better written as
> 		if (strcmp(devname, dmi_empty_string) == 0)
> 

No, it does not. If you look at the rest of the code, the comparison
makes sense as is.

-- 
Jean Delvare
Suse L3

