Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab3IFQCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:02:01 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53544 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab3IFQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:01:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130905200608.GA3846@htj.dyndns.org>
References: <cover.1378383792.git.agordeev@redhat.com> <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
 <20130905130902.GA26314@htj.dyndns.org> <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org> <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org> <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 6 Sep 2013 10:01:38 -0600
Message-ID: <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
To: Tejun Heo <tj@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 2:06 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Alexander.
>
> On Thu, Sep 05, 2013 at 08:54:40PM +0200, Alexander Gordeev wrote:
>> I assume reasons for having this type of interface at the moment of
>> taking design decision about pci_enable_msi_block() still hold true.
>> I do not know what those reasons were, but I think the fact multiple
>> MSIs are rarely used and MSI-X exists does not invalidate them now.
>
> Well, it does change the underlying assumptions to make trade-offs
> against.  If something is widely used, expected to continue to expand,
> additional complexity to achieve better outcome is likely to be more
> justifiable.  Nothing exists in vacuum.  That said, I'm not even sure
> whether we want this sort of interface even if multiple MSI were still
> the hot thing.
>
>> I did consider the other argument - since pci_enable_msi_block_part()
>> is explicitly provided with a value of MME the caller will not be
>> satisfied with any other value and hence a repeated call with a lesser
>> MME does not make sense for the caller. Therefore we could just fail
>> in case the architecture returned a positive value. Same result, but
>> different reasoning.
>
> Just making the whole thing including arch methods to return 0/-errno
> would probably be a lot cleaner.
>
>> At the moment I still prefer pci_enable_msi_block_part() to be similar
>> to pci_enable_msi_block(). I do agree the fallback logic is error-prone,
>> but I would not dare to scrap it all right away.
>
> Yeah, of course, pci_enable_msi_block() would need to be updated to
> match too.  I understand this is going a bit off the original scope of
> the patchset but I can't help but cringing at the interface and the
> resulting "fallback" logic it ends up creating in its users.  Bjorn,
> what do you think?

Sorry, I haven't jumped in here yet because I saw your discussion and
was hoping you guys would figure something out without my help.  It
will take me a few hours to look into this and come up with anything
constructive to say.

I do remember disliking the complicated interface of
pci_enable_msi_block() (return negative errno, return positive "we
might be able to do this" values, or zero), but I'll have to do some
more research before I can say much more than that.

Bjorn
