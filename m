Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaBOTYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:24:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbaBOTYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:24:41 -0500
Message-ID: <1392492273.2771.44.camel@deneb.redhat.com>
Subject: Re: [PATCH] c6x: Include init.h in asm/cache.h
From: Mark Salter <msalter@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Joe Perches <joe@perches.com>
Date: Sat, 15 Feb 2014 14:24:33 -0500
In-Reply-To: <52FFAAA7.6040104@roeck-us.net>
References: <1391781742-32250-1-git-send-email-linux@roeck-us.net>
	 <52FFAAA7.6040104@roeck-us.net>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-15 at 09:57 -0800, Guenter Roeck wrote:
> On 02/07/2014 06:02 AM, Guenter Roeck wrote:
> > arch/c6x/include/asm/cache.h uses __init and thus needs to include init.h.
> > This fixes the following c6x build error.
> >
> > arch/c6x/include/asm/cache.h:63:20: error: expected '=', ',', ';',
> > 'asm' or '__attribute__' before 'c6x_cache_init'
> >   extern void __init c6x_cache_init(void);
> >
> > Problem was inadvertendly introduced with commit c28aa1f
> > (printk/cache: mark printk_once test variable __read_mostly).
> >
> > Cc: Joe Perches <joe@perches.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >   arch/c6x/include/asm/cache.h |    1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/c6x/include/asm/cache.h b/arch/c6x/include/asm/cache.h
> > index 09c5a0f..86648c0 100644
> > --- a/arch/c6x/include/asm/cache.h
> > +++ b/arch/c6x/include/asm/cache.h
> > @@ -12,6 +12,7 @@
> >   #define _ASM_C6X_CACHE_H
> >
> >   #include <linux/irqflags.h>
> > +#include <linux/init.h>
> >
> >   /*
> >    * Cache line size
> >
> 
> ping ... c6x builds still fail in mainline due to this problem.
> Anyone interested in a fix ?
> 

Yes, I'm interested. A fix has been in linux-next for a while but I
haven't pushed it to Linus yet. Will do that this week.


