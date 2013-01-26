Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3AZMoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:44:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33498 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3AZMo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:44:28 -0500
Date: Sat, 26 Jan 2013 13:47:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: Re: [PATCH -v4 5/5] x86,smp: limit spinlock delay on virtual machines
Message-ID: <20130126124716.GB21395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
	eric.dumazet@gmail.com, lwoodman@redhat.com, knoel@redhat.com,
	chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
	mingo@redhat.com
References: <20130125140553.060b8ced@annuminas.surriel.com>
 <20130125141917.6d5960a8@annuminas.surriel.com>
 <20130126120043.GB13445@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130126120043.GB13445@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 01:00:43PM +0100, Ingo Molnar wrote:
> > +void __init init_spinlock_delay(void)
> > +{
> > +	if (x86_hyper)
> > +		max_spinlock_delay = MAX_SPINLOCK_DELAY_GUEST;
> 
> I realize that you took existing code and extended it, but that 
> chunk of code looks pretty disgusting visually now - at minimum 
> it should be vertically aligned as most other kernel code does.
> 
> The comment should also tell that the unit of these values is 
> 'spinlock-op loops' or so.

Also, with currently making PARAVIRT_GUEST optional, x86_hyper is maybe
a bad choice of a variable to test.

Maybe instead to this:

	if (IS_ENABLED(CONFIG_PARAVIRT_GUEST))
		...

Btw, this CONFIG_PARAVIRT_GUEST will change into
CONFIG_HYPERVISOR_GUEST.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
