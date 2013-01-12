Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3ALRHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:07:16 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:50396 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3ALRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:07:14 -0500
MIME-Version: 1.0
In-Reply-To: <4068140.Uym9gOXymC@hammer82.arch.suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<CAE9FiQWEan4Vq-pbp6sgMWVFHwWygQ4Hq2wRsPH166+7w7L2yg@mail.gmail.com>
	<50F08F43.7080604@zytor.com>
	<4068140.Uym9gOXymC@hammer82.arch.suse.de>
Date: Sat, 12 Jan 2013 09:07:12 -0800
X-Google-Sender-Auth: ZRBMzUybKr8Cy5bDw9hhwmhTPbk
Message-ID: <CAE9FiQWNRS6rBzx+fbX+O9_L+Z-4T-oBWZUdzR0sS=P22ctZ0w@mail.gmail.com>
Subject: Re: [PATCH] x86 e820: only void usable memory areas in
 memmap=exactmap case
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 3:31 AM, Thomas Renninger <trenn@suse.de> wrote:
>         memmap=exactmap [KNL,X86] Enable setting of an exact
> -                       E820 memory map, as specified by the user.
> -                       Such memmap=exactmap lines can be constructed based on
> -                       BIOS output or other requirements. See the memmap=nn@ss
> -                       option description.
> +                       E820 usable memory map, as specified by the user.
> +                       All unusable (reserved, ACPI, NVS,...) ranges from the
> +                       original e820 table are preserved.
> +                       But the usable memory regions from the original e820
> +                       table are removed.
> +                       This parameter is explicitly for kdump usage:
> +                       The memory the kdump kernel is allowed to use must
> +                       be passed via below memmap=nn[KMG]@ss[KMG] param.
> +                       All reserved regions the kernel may use for ioremapping
> +                       and similar are still considered.
> +
> +       memmap=voidmap  [KNL,X86] Do not use any e820 ranges from BIOS or
> +                       bootloader. Instead you have to pass regions via
> +                       below memmap= options.

I would suggest to keep memmap=exactmap meaning not changed, and add
memmap=exactusablemap
instead.

kexec-tools could be updated to support exactusablemap with
kernelversion checking for kdump.

also we need to double check to make sure:
1. exactmap should override exactusablemap, even the out of order sequence.
2. when exactusablemap is used, not just remove old usable type range,
also need to remove overlapped range
with new usable range.

Thanks

Yinghai
