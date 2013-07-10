Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3GJLHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:07:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3GJLG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:06:59 -0400
Date: Wed, 10 Jul 2013 08:06:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Borislav Petkov <bp@alien8.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EDAC lockdep splat
Message-ID: <20130710080637.21b755da.mchehab@infradead.org>
In-Reply-To: <20130710104114.GF14873@pd.tnic>
References: <20130710095733.GA356@x4>
	<20130710103915.GE14873@pd.tnic>
	<20130710104114.GF14873@pd.tnic>
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris/Markus,

Em Wed, 10 Jul 2013 12:41:15 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> Forgot to CC him.
> 
> On Wed, Jul 10, 2013 at 12:39:15PM +0200, Borislav Petkov wrote:
> > On Wed, Jul 10, 2013 at 11:57:33AM +0200, Markus Trippelsdorf wrote:
> > > While debugging an unrelated issue I came across the following lockdep
> > > splat:
> > 
> > …
> > 
> > > Jul 10 11:38:00 x4 kernel: BUG: key ffff8802169693f8 not in .data!
> > > Jul 10 11:38:00 x4 kernel: ------------[ cut here ]------------
> > > Jul 10 11:38:00 x4 kernel: WARNING: CPU: 3 PID: 1 at kernel/lockdep.c:2987 lockdep_init_map+0x45e/0x490()
> > > Jul 10 11:38:00 x4 kernel: sda: unknown partition table
> > > Jul 10 11:38:00 x4 kernel: DEBUG_LOCKS_WARN_ON(1)
> > 
> > I know: http://marc.info/?l=linux-kernel&m=136809709202740&w=2
> > 
> > I was expecting Mauro to fix it since his patches grew this out:
> > 
> > commit 7a623c039075e4ea21648d88133fafa6dcfd113d
> > Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Date:   Mon Apr 16 16:41:11 2012 -0300
> > 
> >     edac: rewrite the sysfs code to use struct device
> > 
> > adds struct bus_type to struct mem_ctl_info which is dynamically
> > allocated and that's why lockdep complains.
> > 
> > bus_register() needs to get a statically allocated struct bus_type as
> > the rest of the kernel does it.
> 

I'm currently without any systems where I could try to reproduce it, as
I moved to a new job at Samsung, and I'm still in the process of getting
access to the corporate facilities and to get the needed hardware.
The hardware I currently own doesn't support EDAC.

So, I doubt that I would be able to touch on that in the next couple
weeks or so.

If you're urging for a fix, feel free to propose a patch.
Otherwise, I'll take care of it as soon as I receive the hardware.

Regards,
Mauro
