Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaETGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:16:28 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:44514 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaETGQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:2>);
	Tue, 20 May 2014 02:16:27 -0400
Message-Id: <537B0F560200007800013E3E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Tue, 20 May 2014 07:16:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <david.vrabel@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <matt.fleming@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, <eshelton@pobox.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
 <537A23A50200007800013A7F@mail.emea.novell.com>
 <20140519204657.GB3529@olila.local.net-space.pl>
In-Reply-To: <20140519204657.GB3529@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.05.14 at 22:46, <daniel.kiper@oracle.com> wrote:
> On Mon, May 19, 2014 at 02:30:45PM +0100, Jan Beulich wrote:
>> >>> On 16.05.14 at 22:41, <daniel.kiper@oracle.com> wrote:
>> > @@ -457,6 +460,21 @@ void __init efi_free_boot_services(void)
>> >  	efi_unmap_memmap();
>> >  }
>> >
>> > +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
>> > +							unsigned long size)
>> > +{
>> > +	if (efi_enabled(EFI_DIRECT))
>> > +		return early_ioremap(phys_addr, size);
>> > +
>> > +	return (__force void __iomem *)phys_addr;
>>
>> Now that surely needs some explanation: I can't see how this can
>> ever be correct, Xen or not being completely irrelevant.
> 
> I hope that efi_enabled(EFI_DIRECT) is obvious. However, in case of
> !efi_enabled(EFI_DIRECT) some structures are created artificially
> and they live in virtual address space. So that is why they should
> not be mapped. If you wish I could add relevant comment here.

That would be the very minimum I suppose. But I wonder whether
you wouldn't be better off storing their physical addresses in the
first place (and then decide whether you can stay with early_ioremap()
or want/need to use early_memremap() if !EFI_DIRECT).

Jan

