Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaEZKvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:51:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaEZKvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:51:15 -0400
Date: Mon, 26 May 2014 12:51:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@alien8.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] x86, MCE: Flesh out when to panic comment
In-Reply-To: <20140526101859.GD25732@pd.tnic>
Message-ID: <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
References: <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz> <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com> <20140521214319.GF25130@pd.tnic> <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com> <20140521215411.GI25130@pd.tnic> <537D21F2.8030702@zytor.com> <20140521221121.GL25130@pd.tnic> <537D2522.80702@zytor.com> <20140526101859.GD25732@pd.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014, Borislav Petkov wrote:

> On Wed, May 21, 2014 at 03:13:54PM -0700, H. Peter Anvin wrote:
> > Seems like a comment would be in order, though.
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Subject: [PATCH] x86, MCE: Flesh out when to panic comment
> 
> Recent discussion (link below) showed that it is not really clear what
> appropriate recovery actions we're taking when in a machine check
> exception. Flesh out the comment which was explaining that with more
> detail.
> 
> Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Link: http://lkml.kernel.org/r/CALCETrXudJ8BkNF_M-r4O40XLN%2BPnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 68317c80de7f..9f070339b09f 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1151,10 +1151,14 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  		no_way_out = worst >= MCE_PANIC_SEVERITY;
>  
>  	/*
> -	 * At insane "tolerant" levels we take no action. Otherwise
> -	 * we only die if we have no other choice. For less serious
> -	 * issues we try to recover, or limit damage to the current
> -	 * process.
> +	 * At insane "tolerant" levels we take no action. Otherwise we only die
> +	 * if we have no other choice. Which means, we're definitely going to
> +	 * panic on unrecoverable, uncontainable errors which would otherwise
> +	 * influence machine state and/or cause any type of corruption. The
> +	 * decision what do to is done by mce_severity().
> +	 *
> +	 * For less serious issues we try to recover, or limit damage to the
> +	 * current process.
>  	 */

I think the comment is still not explaining the big part of what the 
discussion was about -- i.e. if it was in kernel context, we always panic.

-- 
Jiri Kosina
SUSE Labs
