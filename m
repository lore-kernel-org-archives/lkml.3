Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3LWRUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:20:04 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:48760 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3LWRUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <20131223144418.GA11342@dhcp-26-207.brq.redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com> <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
 <20131218003002.GA15119@google.com> <20131223144418.GA11342@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 23 Dec 2013 10:19:41 -0700
Message-ID: <CAErSpo6urD4Gd4STW3=SzeNfvZrstqTpfzouCvEwqDLoMpBpng@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] PCI/MSI: Introduce pci_auto_enable_msi*() family helpers
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@aculab.com>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 7:44 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Tue, Dec 17, 2013 at 05:30:02PM -0700, Bjorn Helgaas wrote:
>> > +int pci_auto_enable_msi_range(struct pci_dev *dev, struct msix_entry *entries,
>> > +                         int minvec, int maxvec)
>
> [...]
>
>> > +If this function returns a positive number it indicates at least the
>> > +returned number of MSI interrupts have been successfully allocated (it may
>> > +have allocated more in order to satisfy the power-of-two requirement).
>>
>> I assume this means the return value may be larger than the "maxvec"
>> requested, right?  And the driver is free to use all the vectors up to the
>> return value, even those above maxvec, right?
>
> No, the returned value may not be larger than the "maxvec" ever. This is just
> paraphrasing the semantics of exisitng pci_enable_msi_block() interface - a
> value written to MMC register might be larger than the returned value, but the
> driver may not use the extra vectors it did not request.

Then I think we should remove the "(it may have allocated more...)"
text.  If the driver can't use those extra vectors, they are an
internal implementation detail, and mentioning them here will only
cause confusion.  The "at least" text should also be removed.  From
the driver's point of view, it can use exactly the number of
interrupts returned.

Bjorn
