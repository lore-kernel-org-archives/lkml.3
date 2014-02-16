Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaBPRMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:12:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43724 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbaBPRMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:12:03 -0500
Date: Sun, 16 Feb 2014 18:11:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jan Beulich <jbeulich@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs > maxcpus
 and CONFIG_HOTPLUG=n
Message-ID: <20140216171159.GB25047@pd.tnic>
References: <20140215150223.63bb52fb@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140215150223.63bb52fb@hananiah.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 03:02:23PM +0100, Petr Tesarik wrote:
> Note that the check against i (value passed as maxcpus, but at least 1)
> is repeated further down, including the warning, but since possible is
> already clamped to max_cpus at that time, it is never printed. In fact,
> for the non-hotplug case, the warning about exceeding maxcpus is only
> ever printed if "possible_cpus" was also specified on the command line.
> 
> I strongly believe that such limitation was unintentional.
> 
> I also changed the message slightly -- the kernel parameter name is
> maxcpus, not max_cpus.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> ---
>  arch/x86/kernel/smpboot.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a32da80..376b6c6 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1226,9 +1226,6 @@ __init void prefill_possible_map(void)
>  #ifdef CONFIG_HOTPLUG_CPU
>  		if (setup_max_cpus)
>  			possible += disabled_cpus;
> -#else
> -		if (possible > i)
> -			possible = i;

Hmm, ok, this function is not the easiest to parse and provided I'm not
missing some corner case, the cleanup makes sense to me.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
