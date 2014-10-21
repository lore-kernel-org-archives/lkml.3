Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbaJUToM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:44:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:33123 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaJUToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:44:10 -0400
Date: Tue, 21 Oct 2014 21:44:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Kelly <martin@martingkelly.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, rientjes@google.com,
        david.vrabel@citrix.com, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86, e820: panic on sanitizing invalid memory map
In-Reply-To: <54465FC2.1030106@martingkelly.com>
Message-ID: <alpine.DEB.2.11.1410212141350.5308@nanos>
References: <1413859062-26594-1-git-send-email-martin@martingkelly.com> <alpine.DEB.2.11.1410211043150.5308@nanos> <54465FC2.1030106@martingkelly.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Martin Kelly wrote:
> On 10/21/2014 01:56 AM, Thomas Gleixner wrote:
> >> This patch changes the behavior so that sanitize_e820_map is a void
> >> function. When the provided memory map has length 1 or it is sanitized
> >> (both ok cases), it returns nothing. If the provided memory map is
> >> invalid, then it panics.
> > 
> > So you break wilfully default_machine_specific_memory_setup() and
> > probably some other places. Are you sure about that?
> > 
> I was concerned about exactly that kind of breakage, so my first patch
> merely separated out the return values and added some appropriate error
> checking:
> https://lkml.org/lkml/2014/10/13/514
> 
> I then asked whether there are valid cases for ignoring an invalid map
> and continuing on, but I didn't receive a reply, so I took my best
> guess. It appears I missed some fallback code
> (default_machine_specific_memory_setup). That said, most cases don't

We probably could and should also spend some time on investigating the
validity of that fallback stuff. AFAICT, this has some rather obscure
history from voyager, but I had no time to do more archeology on that.

> appear to have fallback code and will hit issues later on if the BIOS
> map is invalid (e.g. Xen).

Right.
 
> Thomas, do you see any issues with a revision that separates out the
> return values (0 for a map with 1 entry, -1 for a map with invalid
> entries) and adds checks in the callers, where appropriate?

I think that's a sane approach.

Thanks,

	tglx
