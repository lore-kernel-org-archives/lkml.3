Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3JKGUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:20:08 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46945 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3JKGUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:20:06 -0400
Date: Fri, 11 Oct 2013 08:20:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFD: Does CONFIG_X86_LOCAL_APIC still make sense?
Message-ID: <20131011062002.GC4975@gmail.com>
References: <52573279.9020404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52573279.9020404@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> I'm trying to wrap my head around if there are use cases where disabling 
> either CONFIG_X86_UP_APIC or CONFIG_X86_LOCAL_APIC would ever make sense 
> anymore.
> 
> I am guessing there are probably some small number of embedded systems 
> which still don't have LAPICs, but is it a significant number and does 
> anyone care for new kernels?  We are not talking about discontinuing 
> support for non-APIC configurations, just the configuration option.

I guess it depends on the kernel size difference. If it's more than just a 
few K then a patch will creep back via some CONFIG_EXPERT "reduce kernel 
bloat" route.

The thing is, if we allow non-apic configurations then we have paid most 
of the modularization, #ifdef and general maintenance price already. 
Adding a Kconfig just makes it more testable and breakages more apparent.

Unless I missed some aspects of this that would allow us to simplify code 
significantly that is.

Thanks,

	Ingo
