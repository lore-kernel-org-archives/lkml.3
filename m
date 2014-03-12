Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaCLWSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:18:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:46245 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaCLWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:18:23 -0400
Date: Wed, 12 Mar 2014 23:18:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Neil Horman <nhorman@tuxdriver.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2] x86: adjust irq remapping quirk for older revisions
 of 5500/5520 chipsets
In-Reply-To: <1394654862-16030-1-git-send-email-nhorman@tuxdriver.com>
Message-ID: <alpine.DEB.2.02.1403122318130.18573@ionos.tec.linutronix.de>
References: <1394649873-14913-1-git-send-email-nhorman@tuxdriver.com> <1394654862-16030-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Neil Horman wrote:

> A while back I posted this commit:
> 
> commit 03bbcb2e7e292838bb0244f5a7816d194c911d62
> Author: Neil Horman <nhorman@tuxdriver.com>
> Date:   Tue Apr 16 16:38:32 2013 -0400
> 
>     iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets
> 
> Which properly disables irq remapping on the 5500/5520 chipsets that don't
> correctly perform that feature.  However, when I wrote it, I followed the errata
> sheet linked in that commit too closely, and explicitly tied the activation of
> the quirk to revision 0x13 of the chip, under the assumption that earlier
> revisions were not in the field.  Recently a system was reported to be suffering
> from this remap bug and the quirk hadn't triggered, because the revision id
> register read at a lower value that 0x13, so the quirk test failed improperly.
> Given this, it seems only prudent to adjust this quirk so that any revision less
> than 0x13 has the quirk asserted.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org

That probably wants to go to stable as well.
 
> ---
> Change notes:
> 
> v2) fix stupid < / <= error
> ---
>  arch/x86/kernel/early-quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index bc4a088..e69907a 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -208,7 +208,7 @@ static void __init intel_remapping_check(int num, int slot, int func)
>  	 * and should be flagged as broken.  Additionally revisions 0x12
>  	 * and 0x22 of device id 0x3405 has this problem.
>  	 */
> -	if (revision == 0x13)
> +	if (revision <= 0x13)
>  		set_irq_remapping_broken();
>  	else if ((device == 0x3405) &&
>  	    ((revision == 0x12) ||
> -- 
> 1.8.3.1
> 
> 
