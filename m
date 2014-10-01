Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaJAQMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:12:00 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38699 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaJAQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:11:59 -0400
Date: Wed, 1 Oct 2014 17:11:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 1/2] efi: Provide a non-blocking SetVariable() operation
Message-ID: <20141001161151.GD14343@console-pimps.org>
References: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
 <1412165200-32141-2-git-send-email-matt@console-pimps.org>
 <20141001152624.GB2843@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001152624.GB2843@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct, at 05:26:24PM, Peter Zijlstra wrote:
> 
> If you want to have this usable from NMI context, you need to convert
> efi_runtime_lock to a raw_spinlock_t.
 
Hmm.. I note that none of the spinlocks in the pstore code path that we
execute to get here are raw_spinlock_t. And that's the only code path
that calls this function.

They need to be raw_spinlock_t for -rt?

> Also, it would probably be a good idea to have some selftest like thing
> that actually calls this from NMI context, right?

Yeah probably, although that'd need to be a core pstore test since
there's nothing really interesting going on in
virt_efi_set_variable_nonblocking(), and it would be good to test it out
in the larger pstore context.

-- 
Matt Fleming, Intel Open Source Technology Center
