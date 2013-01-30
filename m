Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3A3XqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 18:46:06 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53714 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab3A3XqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1301291158130.1507-100000@iolanthe.rowland.org>
References: <20130129170423.0f83cd31@stein> <Pine.LNX.4.44L0.1301291158130.1507-100000@iolanthe.rowland.org>
From: Mark Einon <mark.einon@gmail.com>
Date: Wed, 30 Jan 2013 23:45:48 +0000
Message-ID: <CANK3SE09VqvshdLrV4xp2W8BHZqLmuz-pV9jQVj7tbk1JBX+9g@mail.gmail.com>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2013 17:01, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 29 Jan 2013, Stefan Richter wrote:
>
>> Added Cc: linux-pm.
>>
>> On Jan 29 Mark Einon wrote:
>> > On 28 January 2013 23:01, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> > > On Jan 28 Mark Einon wrote:
>> > >> This patch fixes the kernel warning generated when putting an MSI MS-1727
>> > >> GT740 laptop into suspend mode. The call sequence in this case calls
>> > >> free_irq() twice, once in pci_remove() and once then in pci_suspend().
>> > >
>> > > You mean /first/ in pci_suspend() and /then/ in pci_remove() on the
>> > > already suspended devices, right?
>> >
>> > Yes, I did. The call sequence is suspend then resume. My bad.
>
> Why does the pci_suspend routine call free_irq() at all?  As far as I
> know, it's not supposed to do that.  Won't the device continue to use
> the same IRQ after it is resumed?

This sounds reasonable to me - I think we could probably get rid of
the request_irq() call from resume, and use
disable_irq()/enable_irq()?
I'll attempt a patch - but unfortunately I don't have a firewire device to test.

Cheers,

Mark
