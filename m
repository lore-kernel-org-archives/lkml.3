Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084AbaGPTfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:35:19 -0400
Received: from server721-han.de-nserver.de ([85.158.180.102]:53314 "EHLO
	server721-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbaGPTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:35:17 -0400
X-Fcrdns: Yes
Message-ID: <20140716213513.18895776q3wl3oj5@berry.schulz.ip-v6.eu>
X-Priority: 3 (Normal)
Date: Wed, 16 Jul 2014 21:35:13 +0200
From: Christoph Schulz <develop@kristov.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Robert Resch <fli4l@robert.reschpara.de>
Subject: Re: [PATCH 1/1] x86: don't exclude low BIOS area when allocating
 address space for non-PCI cards
References: <53C63139.7000608@kristov.de>
 <CAErSpo5_wJrA_aHL9Oy3_qq_UUCb2-7ioY_wARKFFUoM9Ag6FQ@mail.gmail.com>
In-Reply-To: <CAErSpo5_wJrA_aHL9Oy3_qq_UUCb2-7ioY_wARKFFUoM9Ag6FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.9)
X-User-Auth: Auth by mail@kristov.de through 89.182.109.101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Bjorn Helgaas schrieb am Wed, 16 Jul 2014 13:00:21 -0600:

> I applied this to pci/misc for v3.17, thanks.

Thank you very much. What do you think about queuing it up to -stable?  
Commit 30919b0bf356 is in the tree since 2.6.37-rc7. We have used the  
proposed patch for over a year (since 3.2.42 / 3.7.10 / 3.8.5, to be  
exact) without any regressions. I *think* it meets the criteria for  
-stable, but I don't have much experience of Linux kernel development  
processes, so it's your decision, of course.

> This effectively reverts 30919b0bf356 ("x86: avoid low BIOS area when
> allocating address space").  I don't see a reference there to a bug
> fixed by 30919b0bf356, so hopefully reverting it won't reintroduce a
> bug.

Well, for PCI, the current behaviour does not change effectively, and  
for ISA, the proposed patch fixes a bug. What memory allocations  
beyond ISA and PCI could be adversely affected?


Best regards,

Christoph Schulz

