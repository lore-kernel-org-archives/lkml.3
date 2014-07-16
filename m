Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaGPU1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:27:05 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:43541 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaGPU06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140716213513.18895776q3wl3oj5@berry.schulz.ip-v6.eu>
References: <53C63139.7000608@kristov.de> <CAErSpo5_wJrA_aHL9Oy3_qq_UUCb2-7ioY_wARKFFUoM9Ag6FQ@mail.gmail.com>
 <20140716213513.18895776q3wl3oj5@berry.schulz.ip-v6.eu>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 16 Jul 2014 14:26:37 -0600
Message-ID: <CAErSpo41UDuCiS24dV0i=CGTthbUusMRVUcM0-T2UtQNYgVqJA@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: don't exclude low BIOS area when allocating
 address space for non-PCI cards
To: Christoph Schulz <develop@kristov.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Robert Resch <fli4l@robert.reschpara.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 1:35 PM, Christoph Schulz <develop@kristov.de> wrote:
> Hello!
>
> Bjorn Helgaas schrieb am Wed, 16 Jul 2014 13:00:21 -0600:
>
>
>> I applied this to pci/misc for v3.17, thanks.
>
>
> Thank you very much. What do you think about queuing it up to -stable?
> Commit 30919b0bf356 is in the tree since 2.6.37-rc7. We have used the
> proposed patch for over a year (since 3.2.42 / 3.7.10 / 3.8.5, to be exact)
> without any regressions. I *think* it meets the criteria for -stable, but I
> don't have much experience of Linux kernel development processes, so it's
> your decision, of course.

Good point, I added:

CC: stable@vger.kernel.org  # v2.6.37+

>> This effectively reverts 30919b0bf356 ("x86: avoid low BIOS area when
>> allocating address space").  I don't see a reference there to a bug
>> fixed by 30919b0bf356, so hopefully reverting it won't reintroduce a
>> bug.
>
>
> Well, for PCI, the current behaviour does not change effectively, and for
> ISA, the proposed patch fixes a bug. What memory allocations beyond ISA and
> PCI could be adversely affected?

There aren't very many, I guess, but I don't want to build things on
the assumption that ISA and PCI are the only possibilities.  ISA was
once the only possibility :)

Bjorn
