Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3AaJLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:11:42 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:49726 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab3AaJLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:11:37 -0500
Message-ID: <1359623495.1345.98.camel@x61.thuisdomein>
Subject: Re: [PATCH] x86, tsc: downgrade message for fast calibration failure
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 31 Jan 2013 10:11:35 +0100
In-Reply-To: <1348654189.1664.12.camel@x61.thuisdomein>
References: <1348654189.1664.12.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2013 09:11:35.0715 (UTC) FILETIME=[F825D730:01CDFF92]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 12:09 +0200, Paul Bolle wrote:
> When fast calibration of the TSC fails an error is printed:
>     tsc: Fast TSC calibration failed
> 
> This message was printed at default level (ie, as a warning) before
> commit c767a54ba0657e52e6edaa97cbe0b0a8bf1c1655 ("x86/debug: Add
> KERN_<LEVEL> to bare printks, convert printks to pr_<level>"). But it is
> more appropriate to print it at informational level. If fast calibration
> fails that only means an alternative calibration strategy will be tried,
> and if that strategy also fails only a warning is printed. Besides,
> there's nothing one can really do after noticing a fast calibration
> failure.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

What's the status of this patch? Did anyone (besides Joe) have a look at
it? (I'm fine with the wordsmithing Joe suggested, by the way.)

> 0) This is a rather verbose commit explanation. For trivialities like
> these I try to write a very short explanation. But here the verbosity is
> meant to obfuscate my complete ignorance of the (calibration of the)
> TSC.
> 
> 1) By the way, it's debatable whether this message should be printed at
> informational or at notice level. But the difference between KERN_NOTICE
> and KERN_INFO is too subtle for me. I even find the difference between
> KERN_ALERT and KERN_CRIT, and between KERN_ERR and KERN_WARNING a bit
> subtle. Are there guidelines for choosing between those levels?
> 
>  arch/x86/kernel/tsc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index cfa5d4f..4f258ae 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -374,7 +374,7 @@ static unsigned long quick_pit_calibrate(void)
>  			goto success;
>  		}
>  	}
> -	pr_err("Fast TSC calibration failed\n");
> +	pr_info("Fast TSC calibration failed\n");
>  	return 0;
>  
>  success:


Paul Bolle

