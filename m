Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3DUJ6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:58:48 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39119 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3DUJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:58:47 -0400
Date: Sun, 21 Apr 2013 11:58:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check
Message-ID: <20130421095843.GB10683@gmail.com>
References: <1366515340-17853-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366515340-17853-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> The AMD K6 errata check relies on timing a indirect call.
> But the way it was written it could be optimized to a direct call.
> Force gcc to actually do a indirect call and not just
> constant resolve the target address.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 4a549db..11ea6f6 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -115,7 +115,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
>  		 */
>  
>  		n = K6_BUG_LOOP;
> -		f_vide = vide;
> +		asm("" : "=g" (f_vide) : "0" (vide));
>  		rdtscl(d);
>  		while (n--)
>  			f_vide();

Would be useful to read in the changelog about how you found the bug:

 - saw miscalculated values and figured out the reason
 - saw a new warning in GCC
 - saw it during review

?

	Ingo
