Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3F0Kyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:54:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34598 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3F0Kyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:54:38 -0400
Date: Thu, 27 Jun 2013 12:54:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wang YanQing <udknight@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix override new_cpu_data.x86 with 486
Message-ID: <20130627105435.GA21297@pd.tnic>
References: <20130626162640.GA19913@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130626162640.GA19913@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:26:40AM +0800, Wang YanQing wrote:
> 
> We should set X86 to 486 before use cpuid
> to detect the cpu type, if we set X86 to 486
> after cpuid, then we will get 486 for ever.

So not "for ever" but until cpu_detect runs.

> 
> Yes, we will correct this in early_cpu_init,
> but it is still a wrong behavior, right? So
> just fix it.

Right, so this patch is correct and it fixes the small window where we
run with family == 4 before cpu_detect but the commit message needs a
bit massaging before it gets applied.

> 
> I also find maybe we can delete the new_cpu_data,
> because we will over write all the information
> in early_cpu_init, and before early_cpu_init,
> there is no user of new_cpu_data, but this is
> another patch in the future.

You can drop that part.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
