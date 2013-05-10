Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3EJJkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:40:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46579 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab3EJJkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:40:12 -0400
Date: Fri, 10 May 2013 11:45:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130510094556.GA23014@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130510002930.GB2394@somewhere>
 <20130510092811.GA22942@pd.tnic>
 <CAFTL4hxx_pHkJExnRks4hcOYGrJb8TCMRdCtt0UA-i3wsaWWcQ@mail.gmail.com>
 <20130510093729.GA16487@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510093729.GA16487@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:37:29AM +0200, Ingo Molnar wrote:
> The pattern I use in such cases is:
> 
> 	if (WARN_ONCE(!cpu_online(cpu))) {
> 		printk("%d %d\n", cpu, smp_processor_id());
> 		dump_stack();
> 	}

Cool, and WARN_ONCE dumps stack already so:

	if (WARN_ONCE(!cpu_online(cpu)))
		printk("%d %d\n", cpu, smp_processor_id());

Nice.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
