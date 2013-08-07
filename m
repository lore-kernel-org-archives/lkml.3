Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3HGIrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:47:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab3HGIrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:47:21 -0400
Date: Wed, 7 Aug 2013 10:47:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG linux-next] watchdog: build breakage for non-SMP builds
Message-ID: <20130807084716.GA8184@dhcp22.suse.cz>
References: <20993.64234.352390.254920@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20993.64234.352390.254920@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-08-13 09:44:42, Lothar Waßmann wrote:
> Hi,
> 
> commit 0ce6966b "watchdog: update watchdog_tresh properly" breaks
> build on non-SMP systems (more specifically: on systems where
> CONFIG_USE_GENERIC_SMP_HELPERS is not set):
> linux-next/kernel/watchdog.c: In function 'update_timers':
> linux-next/kernel/watchdog.c:522:2: error: implicit declaration of function '__smp_call_function_single' [-Werror=implicit-function-declaration]

The fix is already in the Andrew's tree so it should show up in
linux-next sometimes soon.

Sorry about the hassles.

> I guess the offending code should be guarded by an
> '#ifdef CONFIG_USE_GENERIC_SMP_HELPERS'
> like in kernel/softirq.c:
> #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
> [...]
> static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
> {
>         if (cpu_online(cpu)) {
>                 cp->func = remote_softirq_receive;
>                 cp->info = &softirq;
>                 cp->flags = 0;
> 
>                 __smp_call_function_single(cpu, cp, 0);
>                 return 0;
>         }
>         return 1;
> }
> #else /* CONFIG_USE_GENERIC_SMP_HELPERS */
> static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
> {
>         return 1;
> }
> #endif
> 
> 
> Lothar Waßmann
> -- 
> ___________________________________________________________
> 
> Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
> Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
> Geschäftsführer: Matthias Kaussen
> Handelsregistereintrag: Amtsgericht Aachen, HRB 4996
> 
> www.karo-electronics.de | info@karo-electronics.de
> ___________________________________________________________

-- 
Michal Hocko
SUSE Labs
