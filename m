Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3GJM2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:28:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab3GJM2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:28:45 -0400
Subject: Re: [PATCH 2/3] firmware/dmi_scan: Fix most checkpatch errors and
 warnings
From: Jean Delvare <jdelvare@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1373386794.14604.14.camel@joe-AO722>
References: <1373384438.4391.6.camel@chaos.site>
	 <1373384574.4391.9.camel@chaos.site>  <1373386794.14604.14.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 10 Jul 2013 14:28:25 +0200
Message-ID: <1373459305.4399.27.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Le Tuesday 09 July 2013 à 09:19 -0700, Joe Perches a écrit :
> On Tue, 2013-07-09 at 17:42 +0200, Jean Delvare wrote:
> > Fix all errors and trivial warnings reported by checkpatch for file
> > drivers/firmware/dmi_scan.c.
> 
> trivia:
> 
> > +++ linux-3.11-rc0/drivers/firmware/dmi_scan.c	2013-07-09 16:08:13.979592957 +0200
> > @@ -63,7 +63,7 @@ static char * __init dmi_string(const st
> >  	if (str != NULL)
> >  		strcpy(str, bp);
> >  	else
> > -		printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
> > +		pr_err("dmi_string: cannot allocate %Zu bytes.\n", len);
> 
> If the function name is used in every printk, it might
> be better to add
> 
> #define pr_fmt(fmt) "%s: " fmt, __func__
> 
> before any #include

No, only error messages include the function name, debug and info
messages do not.

> If not, then I suggest removing the embedded function names
> and writing these as
> 		pr_err("%s: etc...", __func__, etc...);
> 
> This eliminates any possible function name mismatch.

I had considered this too, but stepped back after finding out that this
change would increase the binary size. It's hard to sell such a change
then when it's only fixing a theoretical problem.

> > @@ -217,7 +220,7 @@ static void __init dmi_save_one_device(i
> >  
> >  	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
> >  	if (!dev) {
> > -		printk(KERN_ERR "dmi_save_one_device: out of memory.\n");
> > +		pr_err("dmi_save_one_device: out of memory.\n");
> 
> OOM messages generally aren't useful.
> 
> dmi_alloc is either a trivial front-end to kmalloc,
> and kmalloc already does a dump_stack() when OOM, or
> for x86, dmi_alloc uses extend_brk which BUGs when
> unsuccessful.

Fair enough, I'll send a separate patch for this in a minute.

-- 
Jean Delvare
Suse L3

