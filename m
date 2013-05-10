Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3EJJWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:22:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52749 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3EJJWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:22:32 -0400
Date: Fri, 10 May 2013 11:28:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130510092811.GA22942@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130510002930.GB2394@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510002930.GB2394@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 02:29:31AM +0200, Frederic Weisbecker wrote:
> @@ -616,8 +616,17 @@ static bool wake_up_full_nohz_cpu(int cpu)
>  {
>  	if (tick_nohz_full_cpu(cpu)) {
>  		if (cpu != smp_processor_id() ||
> -		    tick_nohz_tick_stopped())
> +		    tick_nohz_tick_stopped()) {
> +			if (!cpu_online(cpu)) {
> +				static int printed = 0;
> +				if (!printed) {
> +					printk("%d %d\n", cpu, smp_processor_id());
> +					dump_stack();
> +					printed = 1;

You know about printk_once, right? We even have all the pr_<level>_once
macros.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
