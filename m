Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3CUKkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:40:23 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45642 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3CUKkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:40:22 -0400
Date: Thu, 21 Mar 2013 11:40:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        penguin-kernel@I-love.SAKURA.ne.jp,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address
 by __pa_nodebug()
Message-ID: <20130321104018.GA18484@gmail.com>
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> +	initrd_start_p = (unsigned long *)__pa_nodebug(&initrd_start);
> +	initrd_start_addr = (unsigned long)__pa_nodebug(*initrd_start_p);

We should probably use __pa_early() for that - aliased to __pa_nodebug(). 
That would self-document the purpose.

Thanks,

	Ingo
