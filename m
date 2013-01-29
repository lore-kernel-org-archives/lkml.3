Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3A2Mod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:44:33 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:55828 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3A2Mob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:44:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130129000149.5fa5b0c3@stein>
References: <1359410988-3740-1-git-send-email-mark.einon@gmail.com> <20130129000149.5fa5b0c3@stein>
From: Mark Einon <mark.einon@gmail.com>
Date: Tue, 29 Jan 2013 12:44:15 +0000
Message-ID: <CANK3SE0w08n1RSzqy5dV4eAymAfmnb-a+T9UfVSxw-+3fP-PVA@mail.gmail.com>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2013 23:01, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> On Jan 28 Mark Einon wrote:
>> This patch fixes the kernel warning generated when putting an MSI MS-1727
>> GT740 laptop into suspend mode. The call sequence in this case calls
>> free_irq() twice, once in pci_remove() and once then in pci_suspend().
>
> You mean /first/ in pci_suspend() and /then/ in pci_remove() on the
> already suspended devices, right?

Yes, I did. The call sequence is suspend then resume. My bad.

>
> Because the other way around, first pci_remove(), then pci_suspend(),
> surely must not appen.  And if it does, the bug is elsewhere but not in
> firewire-ohci.
>
> On that note, is pci_suspend() -> pci_remove() actually a legal state
> transition that must be handled by drivers?

It's happening on the Ubuntu 12.10 distro which performs the suspend
then remove sequence. I assumed that was normal.

>
> Another comment below.
<snip>
>
> firewire-ohci's pci_resume() calls request_irq() a little bit before that,
> in ohci_enable().  Is the sequence pci_probe/request_irq() ->
> pci_suspend/disable_irq() -> pci_resume/request_irq() ->
> pci_resume/enable_irq() legal?

I missed the call to request_irq(). Perhaps the simplest way to handle
the fix would be to use a flag that holds the irq state? I'm open to
suggestions.

Cheers,

Mark
