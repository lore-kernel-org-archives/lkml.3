Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaKLKvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:51:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35670 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaKLKve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141112095846.GA6759@red-moon>
References: <1415702040-2790-1-git-send-email-ming.lei@canonical.com>
	<20141111122901.GA4419@red-moon>
	<CACVXFVNAc9axtESmo1zGZ3GMquTzjzWR3jx-b3tbhhLfQDDRcg@mail.gmail.com>
	<20141111182418.GA5507@red-moon>
	<CACVXFVPzo2qNGa5DWESS3TXor=u82_SxHb+xzrBCRXtcQxq4Cg@mail.gmail.com>
	<20141112095846.GA6759@red-moon>
Date: Wed, 12 Nov 2014 18:51:31 +0800
Message-ID: <CACVXFVNn=mDuJ9h3wavvo=H29hzFNisKAYEoF0OiFgm4wVAaLw@mail.gmail.com>
Subject: Re: [PATCH] pci: generic host: make it more generic
From: Ming Lei <ming.lei@canonical.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        alvise rigo <a.rigo@virtualopensystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 5:58 PM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:
> On Wed, Nov 12, 2014 at 02:12:12AM +0000, Ming Lei wrote:
>> On Wed, Nov 12, 2014 at 2:24 AM, Lorenzo Pieralisi
>> <lorenzo.pieralisi@arm.com> wrote:
>> > On Tue, Nov 11, 2014 at 02:02:20PM +0000, Ming Lei wrote:
>> >
>> > [...]
>> >
>> >> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296535.html
>> >> >
>> >> > Patch above is already queued and applies most of the changes you have posted
>> >> > above.
>> >>
>> >> I should have looked at list first before writing the patch, :-(
>> >>
>> >> Could you make it more generic so that other ARCHs(at least ARM64)
>> >> can benefit from it too?
>> >
>> > That's our current goal, we are carrying out clean-ups to remove arch
>> > dependency and move code to the generic layer PCI layer.
>>
>> OK, I am glad to test them after you post them out.
>>
>> At least, the 'struct gen_pci' pointer can be put in driver data
>> of the platform_device now, which may remove dependency on
>> pci_sysdata in this driver.  But ARCH's pcibios code still may
>> access 'pci_sysdata', do you have patches or solution to handle
>> this issue?
>
> I will consider adding struct gen_pci pointer as platform device
> driver data, we are working on removing pci_sys_data dependency in the ARM
> pcibios backend, and I do not think we are far from achieving that.

Other ARCHs has sort of pcibios backend too, so that said it still
depends on ARM or ARM64, doesn't it?

Thanks,
