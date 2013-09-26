Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab3IZXih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:38:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57641 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab3IZXig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:38:36 -0400
Date: Fri, 27 Sep 2013 01:38:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: suravee.suthikulpanit@amd.com
Cc: herrmann.der.user@googlemail.com, jacob.w.shin@gmail.com,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH V2] x86, microcode, AMD: Fix patch level reporting for
 family15h
Message-ID: <20130926233821.GE10123@pd.tnic>
References: <1285806432-1995-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1285806432-1995-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 07:27:12PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> On AMD family15h, applying microcode patch on the a core (core0)
> would also affect the other core (core1) in the same compute unit.
> The driver would skip applying the patch on core1, but it still
> need to update kernel structures to reflect the proper patch level.
> 
> The current logic is not updating the struct ucode_cpu_info.cpu_sig.rev
> of the skipped core. This causes the /sys/devices/system/cpu/cpu1/microcode/version
> to report incorrect patch level as shown below:
> 
> $ grep . cpu?/microcode/version
> cpu0/microcode/version:0x600063d
> cpu1/microcode/version:0x6000626
> cpu2/microcode/version:0x600063d
> cpu3/microcode/version:0x6000626
> cpu4/microcode/version:0x600063d
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
> Changes from V1:
> 	- Update commit log as suggested by Boris.
> 
>  arch/x86/kernel/microcode_amd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 7123b5d..af99f71 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -216,6 +216,7 @@ int apply_microcode_amd(int cpu)
>  	/* need to apply patch? */
>  	if (rev >= mc_amd->hdr.patch_id) {
>  		c->microcode = rev;
> +		uci->cpu_sig.rev = rev;
>  		return 0;
>  	}

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
