Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3HWIX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:23:58 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:38553 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3HWIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:23:56 -0400
Date: Fri, 23 Aug 2013 10:23:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Liu ping fan <kernelfans@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kevin Hao <haokexin@gmail.com>
Subject: Re: [PATCH] x86: ioapic needs check attr when programmed more than
 once
Message-ID: <20130823082352.GA25858@gmail.com>
References: <1377161197-3175-1-git-send-email-pingfank@linux.vnet.ibm.com>
 <20130823073052.GA25533@gmail.com>
 <CAFgQCTuZ2ojrgvW3McDtrrVu06J1d9ssdfu4fD3Pb7rCYL2MHA@mail.gmail.com>
 <CAFgQCTtNmL7td-yqrUMe=H-6yxdA-7WSjCxzbeTTrsphEGWNwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgQCTtNmL7td-yqrUMe=H-6yxdA-7WSjCxzbeTTrsphEGWNwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Liu ping fan <kernelfans@gmail.com> wrote:

> On Fri, Aug 23, 2013 at 4:04 PM, Liu ping fan <kernelfans@gmail.com> wrote:
> > On Fri, Aug 23, 2013 at 3:30 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >>
> >> * Liu Ping Fan <kernelfans@gmail.com> wrote:
> >>
> >>> When programming ioapic pinX more than once, current code
> >>> does not check whether the later attr (trigger&polarity) is the
> >>> same as the former or not. This causes a broken semantic.
> >>>
> >>> Fix it by reporting -EBUSY, when attr is different.
> >>
> >> Was this observed in real life somehow, and if yes, what is
> >> the before/after behavior?
> >>
> > Using qemu q35 machine, I found the ioapic's ioredtbl[] will never has
> > low-active, even the hpet driver registered it. After tracing, I found
> > it shared a high-level active IRQ line with other device. So in fact,
> > the acpi_register_gsi(, ACPI_ACTIVE_LOW) in hpet driver fail, but it
> > did not detect it.
> > The effect in qemu: when hpet-dev assert low-level, the kernel can not respond.
> >
> After changing, I can observe the low-active be set in ioredtbl[x],
> and with some bug fix in qemu's hpet, the kernel can work.

Okay, so because in practice this kind of information is 
much more important to users than anything else in the 
changelog please put all this into the changelog and 
re-send.

Thanks,

	Ingo
