Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3JNRH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:07:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39136 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab3JNRHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:07:54 -0400
Date: Mon, 14 Oct 2013 19:07:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
Message-ID: <20131014170741.GA4351@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
 <20131011152451.GF5925@pd.tnic>
 <20131014031633.GA12189@gchen.bj.intel.com>
 <20131014102635.GC4009@pd.tnic>
 <CA+8MBbJ+mOWhZR5d8wP4x_ncgumGOANziOGmDBzj0QdbPSDH0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbJ+mOWhZR5d8wP4x_ncgumGOANziOGmDBzj0QdbPSDH0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 09:50:00AM -0700, Tony Luck wrote:
> Now load the module with the not-weak definition of the function -
> the module loader would have to go do a relocation fix-up in the base
> kernel to point to this new function. At module unload it would have
> to undo that.

Ok, then. How about a reg/dereg functionality, something like what I did
in drivers/edac/mce_amd.c, near the top? We're basically handing down a
proper function pointer to call and at module unload time we clear it.

Also, those register/unregister functions could be made to return an
errval so that code calling them can handle that gracefully.

Bottom line is, IMO we're much better off having a clearly defined
interface like that instead of exporting a naked function pointer.

Thoughts?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
