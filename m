Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaLFC6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:58:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaLFC6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:58:08 -0500
Date: Fri, 5 Dec 2014 18:58:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "George Spelvin" <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] [PATCH] VERIFY_OCTAL_PERMISSIONS: Move to
 <linux/sysfs.h> where it belongs
Message-Id: <20141205185821.08afc560.akpm@linux-foundation.org>
In-Reply-To: <20141206024952.24901.qmail@ns.horizon.com>
References: <20141205172802.4c56cbd6.akpm@linux-foundation.org>
	<20141206024952.24901.qmail@ns.horizon.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Dec 2014 21:49:52 -0500 "George Spelvin" <linux@horizon.com> wrote:

> >> -----
> 
> > This shouldn't be here because "^---" is considered "end of changelog".
> 
> Damn it, I couldn't remember how to add not-for-commit comments to a patch.
> I RTFMed and thought that was what "git mailinfo --scissors" wanted.
> 
> (Normally, I put it down with the diffstat, but preferred a more
> prominent place for this conversation.)

I think in 100% of cases I find the stuff that people put below the
^--- was useful info, so I move it into the changelog.  Yours was no
exception ;) 

> > Let's include bug.h into sysfs.h.
> 
> It worked without, but yeah... since I can't figure *how* it works.

heh.  `KCPPFLAGS=-H make foo.o' will show the include graph.  I usually
do `make foo.i' then go poke around in foo.i to work out how foo.c
received a particular definition.

> >> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> >> index 1c9effa2..974097df 100644
> >> --- a/include/linux/moduleparam.h
> >> +++ b/include/linux/moduleparam.h
> >> @@ -1,9 +1,9 @@
> >>  #ifndef _LINUX_MODULE_PARAMS_H
> >>  #define _LINUX_MODULE_PARAMS_H
> >>  /* (C) Copyright 2001, 2002 Rusty Russell IBM Corporation */
> >> -#include <linux/init.h>
> >>  #include <linux/stringify.h>
> >> -#include <linux/kernel.h>
> >> +#include <linux/sysfs.h>
> >> +#include <linux/types.h>
> 
> > Removing the kernel.h inclusion is good, but risky.  Are you sure
> > there's nothing in moduleparam.h which uses kernel.h things?
> 
> Well, I did a quick eyeball-scan, then did my usual build, then
> an allyesconfig and an allmodconfig.
> 
> I found some other alarming things, but nothing related to this.
> 
> E.g.
> drivers/net/ethernet/intel/i40e/i40e_debugfs.c: In function 'i40e_dbg_dump_desc':
> drivers/net/ethernet/intel/i40e/i40e_debugfs.c:855:1: warning: the frame size of 8192 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>  }
> 
> (Honestly, I didn't wait for the allmodconfig to finish, since I
> expected it to fail within the first few hundred modules if it was going to
> fail at all, but it has finished now.)

OK, let's run with it and see what happens.
