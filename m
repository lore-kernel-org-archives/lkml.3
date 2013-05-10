Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab3EJPb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:31:56 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39220 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3EJPby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:31:54 -0400
Date: Fri, 10 May 2013 17:31:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130510153148.GA9358@somewhere>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130510002930.GB2394@somewhere>
 <20130510092811.GA22942@pd.tnic>
 <CAFTL4hxx_pHkJExnRks4hcOYGrJb8TCMRdCtt0UA-i3wsaWWcQ@mail.gmail.com>
 <20130510093729.GA16487@gmail.com>
 <20130510094556.GA23014@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510094556.GA23014@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:45:56AM +0200, Borislav Petkov wrote:
> On Fri, May 10, 2013 at 11:37:29AM +0200, Ingo Molnar wrote:
> > The pattern I use in such cases is:
> > 
> > 	if (WARN_ONCE(!cpu_online(cpu))) {
> > 		printk("%d %d\n", cpu, smp_processor_id());
> > 		dump_stack();
> > 	}
> 
> Cool, and WARN_ONCE dumps stack already so:
> 
> 	if (WARN_ONCE(!cpu_online(cpu)))
> 		printk("%d %d\n", cpu, smp_processor_id());

Even better:

 	if (WARN_ONCE(!cpu_online(cpu)))
 		printk_once("%d %d\n", cpu, smp_processor_id());

So the printk doesn't flood after the first case.

> 
> Nice.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
