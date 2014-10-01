Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaJAQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:26:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52193 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaJAQ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:26:22 -0400
Date: Wed, 1 Oct 2014 09:26:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-metag@vger.kernel.org,
        linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH 10/16] mips: support poweroff through poweroff
 handler call chain
Message-ID: <20141001162617.GC11708@roeck-us.net>
References: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
 <1412100056-15517-11-git-send-email-linux@roeck-us.net>
 <20141001133238.GJ19854@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001133238.GJ19854@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 03:32:39PM +0200, Ralf Baechle wrote:
> On Tue, Sep 30, 2014 at 11:00:50AM -0700, Guenter Roeck wrote:
> 
> > The kernel core now supports a poweroff handler call chain
> > to remove power from the system. Call it if pm_power_off
> > is set to NULL.
> > 
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  arch/mips/kernel/reset.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/mips/kernel/reset.c b/arch/mips/kernel/reset.c
> > index 07fc524..c3391d7 100644
> > --- a/arch/mips/kernel/reset.c
> > +++ b/arch/mips/kernel/reset.c
> > @@ -41,4 +41,6 @@ void machine_power_off(void)
> >  {
> >  	if (pm_power_off)
> >  		pm_power_off();
> > +	else
> > +		do_kernel_poweroff();
> 
> I'm happy with this as long as in a later version pm_power_off indeed
> goes away.
> 
Yes, that would be the ultimate goal. Hope we can get there.

Guenter
