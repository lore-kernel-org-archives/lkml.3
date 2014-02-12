Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaBLRAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:00:51 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:42366 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBLRAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:00:50 -0500
MIME-Version: 1.0
In-Reply-To: <20140212132640.GA3147@dhcp-26-207.brq.redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com> <434a34e01c353441131204edef36126a95e8928a.1391172839.git.agordeev@redhat.com>
 <20140131.133051.483295479425700960.davem@davemloft.net> <20140211003814.GC12851@google.com>
 <20140211010803.GD12851@google.com> <20140212132640.GA3147@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Feb 2014 10:00:28 -0700
Message-ID: <CAErSpo7Puj1hgpmnjvuBjvoNjHQUyOU-axsKm+PY3j8jkZHDAQ@mail.gmail.com>
Subject: Re: [PATCH 01/34] bnx2: Use pci_enable_msix_range()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 6:26 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Mon, Feb 10, 2014 at 06:08:03PM -0700, Bjorn Helgaas wrote:
>> I skimmed these and the scsi patches, and I think you were right in
>> proposing an MSI-X enable function that takes a single "number of vectors"
>> argument, in addition to pci_enable_msix_range(), which takes a minimum and
>> a maximum.  Obviously the pci_enable_msix_fixed() or whatever could be a
>> simple #define wrapper or something.
>>
>> Of the fifty-some net and scsi patches, I counted 23 that use the min ==
>> max pattern, and it seems a shame to have to repeat that expression.
>
> (un-CCing netdev@vger.kernel.org)
>
> Hi Bjorn,
>
> I propose pci_enable_msix_exact(pdev, entries, nvec) rather than
> pci_enable_msix_fixed().

OK, that sounds fine.

> Do you prefer this one to return 0/-errno or nvec/-errno?

0/-errno seems right to me.  We are asking for a very specific thing,
and returning nvec doesn't give the caller any additional information
(since the caller supplied nvec in the first place), so simple
success/failure is what I would expect.

> Do you want pci_enable_msi_exact() in addition to pci_enable_msix_exact()?

If there are cases where pci_enable_msi_exact() would be used, I guess
the same arguments would apply, so yes.  I haven't looked at the
archives, but I have this nagging feeling that this is exactly what
you proposed initially, and I had some objection.  If so, I'm sorry
about changing my mind :)

Bjorn
