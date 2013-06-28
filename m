Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3F1IvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:51:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58415 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab3F1IvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:51:11 -0400
Date: Fri, 28 Jun 2013 10:51:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wang YanQing <udknight@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix override new_cpu_data.x86 with 486
Message-ID: <20130628085107.GA24494@pd.tnic>
References: <20130626162640.GA19913@udknight>
 <20130627105435.GA21297@pd.tnic>
 <20130628005642.GA2232@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130628005642.GA2232@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 08:56:42AM +0800, Wang YanQing wrote:
> > Right, so this patch is correct and it fixes the small window where we
> > run with family == 4 before cpu_detect but the commit message needs a
> > bit massaging before it gets applied.
> 
> I think it fixes the window where we run with family > 4 before cpu_detect :)

Yes, before cpu_detect, the family is set to 4. And with "family" I mean

#define X86             new_cpu_data+CPUINFO_x86

and not the hardware family of the CPU and what you mean is that when
we boot 32-bit on a hardware family != 4, we run with X86 == 4 until
cpu_detect runs.

So basically we're saying the same thing. :)

> I can't catch the exactly meaning:
> 
> We can drop the new_cpu_data or 
> I need to drop this part commit
> message.

Yes, this part of the commit message.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
