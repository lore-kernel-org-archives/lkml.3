Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3JWGvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:51:14 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60482 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3JWGvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAOx4COX4M0nk5RPO6EHoot7VzUcuK8MLo4dSb2Ld3mdKTv5qzQ@mail.gmail.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	<20131021135437.GD1283@fenchurch.internal.datastacks.com>
	<20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	<1382433990.1657.66.camel@hastur.hellion.org.uk>
	<5266620602000078000FCA48@nat28.tlf.novell.com>
	<1382435127.1657.70.camel@hastur.hellion.org.uk>
	<526668A502000078000FCA7B@nat28.tlf.novell.com>
	<20131022134252.GA27302@phenom.dumpdata.com>
	<20131022144309.GA18547@phenom.dumpdata.com>
	<1382455537.8512.11.camel@shinybook.infradead.org>
	<20131022163502.GD19189@phenom.dumpdata.com>
	<CAOx4COX4M0nk5RPO6EHoot7VzUcuK8MLo4dSb2Ld3mdKTv5qzQ@mail.gmail.com>
Date: Wed, 23 Oct 2013 14:51:10 +0800
X-Google-Sender-Auth: 7B7go2LxVVC27VMBMmK6Kiab4oE
Message-ID: <CAOx4COWkJzQNhUZCT2QxKEVUxNw8BwjqBJRd8_7T+6V3ukTiUg@mail.gmail.com>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Michael Chang <mchang@suse.com>
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        "keir@xen.org" <keir@xen.org>, Ian Campbell <ian.campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/23 Michael Chang <mchang@suse.com>:
> 2013/10/23 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
>> On Tue, Oct 22, 2013 at 03:25:39PM +0000, Woodhouse, David wrote:
>>> On Tue, 2013-10-22 at 10:43 -0400, Konrad Rzeszutek Wilk wrote:
>>> >
>>> > And looking at bit deeper in the x86/linux boot spec:
>>> >
>>> > **** EFI HANDOVER PROTOCOL
>>> >
>>> > This protocol allows boot loaders to defer initialisation to the EFI
>>> > boot stub. The boot loader is required to load the kernel/initrd(s)
>>> > from the boot media and jump to the EFI handover protocol entry point
>>> > which is hdr->handover_offset bytes from the beginning of
>>> > startup_{32,64}.
>>>
>>> Oh, ignore that. You want the *actual* PE executable entry point, as it
>>> would get invoked by a real UEFI firmware.
>>
>> Right. The Xen hypervisor can be built in two images: a standard PE/COFF
>> that can be executed from the EFI shell, and an multiboot blob that can
>> be loaded by multiboot compatible boot loaders (like GRUB).
>>
>>>
>>> I thought that's what Grub invoked, for 'linuxefi'. Perhaps I mean a
>>> chainloader method of some kind instead. Either way, make Grub (or
>>> whatever bootloader you choose) load it as an EFI executable.
>>
>> Looks like chainloader was it from Peter's answer. But then you can't
>> do SecureBoot <sigh>.
>
> In SUSE/openSUSE we had a patch[1] in chainloader for supporting
> shim's protocol to verify loaded EFI images. The efi image can be
> loaded and verified by db or MOK keyrings.
>
> [1] https://build.opensuse.org/package/view_file/openSUSE:Factory/grub2/grub2-secureboot-chainloader.patch?expand=1
>
> With the linux foundation's PreLoader, that patch can be eliminated
> totally as the verification is done via installed hook, where
> verification result from MOK keyring is added, to authenticate file
> protocol. The verification is thus transparent to UEFI applications so
> any other loader, like shim, can be benefited from it.

Sorry, other loaders should be gummiboot, refind and so on ..

>
> The PreLoader has it's own controversy as that protocol is not part of
> UEFI spec, instead it's part of PI spec for UEFI firmware
> implementation thus shouldn't be used by an application (loader). It
> could have compatibility problem ...
>
> Regards,
> Michael
>>
>>>
>>> Seriously, forget Grub for now. Grub is mostly just an exercise in
>>> gratuitously doing things the difficult way and wondering why it's
>>> fragile.
>>>
>>> Make your code work as an EFI executable when loaded directly from the
>>> UEFI firmware. Worry about the insanity of grub later.
>>
>> That has been done by Jan. Now we are at the 'have a shim that launches
>> GRUB2, now what?'
>>
>>>
>>>
>>> --
>>>                    Sent with MeeGo's ActiveSync support.
>>>
>>> David Woodhouse                            Open Source Technology Centre
>>> David.Woodhouse@intel.com                              Intel Corporation
>>>
>>>
>>>
>>
>>
>>
>> _______________________________________________
>> Grub-devel mailing list
>> Grub-devel@gnu.org
>> https://lists.gnu.org/mailman/listinfo/grub-devel
>>
