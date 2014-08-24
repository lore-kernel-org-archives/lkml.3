Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaHXTTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:19:08 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61979 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaHXTTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<53F752A2.7080604@redhat.com>
	<CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
Date: Sun, 24 Aug 2014 22:19:04 +0300
Message-ID: <CAPWNY8V=T=Y5uPX9J_qjdkTJRnctDs-PoTQP7LEX_cKQEn0_Zg@mail.gmail.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
To: Harald Hoyer <harald@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 5:43 PM, Mantas Mikulėnas <grawity@gmail.com> wrote:
>
> On Fri, Aug 22, 2014 at 5:24 PM, Harald Hoyer <harald@redhat.com> wrote:
> > On 09.08.2014 16:23, Mantas Mikulėnas wrote:
> >> As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"),
> >> the kernel freezes at the earliest possible moment when trying to boot
> >> via UEFI on my Asus laptop. (It still boots via BIOS.)
> >>
> >> If I revert that commit on current master (c309bfa9b481), it boots
> >> correctly again [although I see "setup_efi_pci() failed" being printed].
> >>
> >> (Seems like it freezes when handle_cmdline_files() attempts to read
> >> the last chunk of the initramfs -- the last call to efi_file_read()
> >> never returns. Figuring out why that happens is beyond me, though.)
> >>
> >
> > I fixed my issue with: https://lkml.org/lkml/2014/8/22/232
>
> ...Well. If that's the _physical_ address, then I suppose it wouldn't
> have worked on my 4 GB laptop either way. (I thought UEFI already used
> some sort of virtual memory, so I never even thought to mention
> this... Oh well.)
>
> Though if that's the case, then I'm wondering why it would be affected
> by the read size? Shouldn't it have crashed either as soon as the high
> address was used, or never at all? (I really don't know much about
> memory at this level. Sorry.)
>
> > Care to test?
>
> Will try later today.

Finally got around to testing it, and yes, your patch fixes the initrd
boot for me.

-- 
Mantas Mikulėnas <grawity@gmail.com>
