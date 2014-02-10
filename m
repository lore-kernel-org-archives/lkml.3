Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaBJVeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:34:00 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60771 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaBJVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:33:58 -0500
MIME-Version: 1.0
In-Reply-To: <1391952344.25424.4.camel@x220>
References: <1391886379.2669.11.camel@x41> <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
 <1391890927.1882.5.camel@x41> <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Feb 2014 14:33:35 -0700
Message-ID: <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset flushing
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 6:25 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2014-02-09 at 13:15 +0000, Steven Newbury wrote:
>> PCI resource allocation is undergoing some changes at the moment, it's
>> definitely a bug if the Flush Page isn't getting allocated.  I'm looking
>> forward to hopefully getting pci_bus_alloc_resource_fit() behaviour in
>> mainline, it will provide much better resource allocation in the 32 bit
>> PCI address space, and prevent problems like this from cropping up.
>>
>> See Yinghai Lu's for-pci-res-alloc branch.
>>
>> I've been carrying the changes in my local tree, but right now the
>> upstream PCI changes are quite extensive.  He's planning on rebasing the
>> branch soon.
>
> Does this mean I might be better of not bisecting this just yet? Or are
> these changes targeted at v3.15 (or later)?

Yinghai's changes would probably be in v3.15 or later.

Can you open a kernel.org bugzilla report and attach complete dmesg
logs of the working and broken kernels to it?  There might be more
useful resource-related messages from the PCI core.

I wouldn't start bisecting yet, but if you're in the mood, this
commit: 96702be56037 "Merge branch 'pci/resource' into next" looks
like a good place to start, so you could try the pre-merge commit:
04f982beb900 "Merge branch 'pci/msi' into next".  If 04f982beb900 is
good, there are only about 15 commits on the pci/resource branch to
look at.

Thanks for the report!

Bjorn
