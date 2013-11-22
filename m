Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3KVPZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:25:46 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61677 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3KVPZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:25:45 -0500
MIME-Version: 1.0
In-Reply-To: <20131122134317.GA4046@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
	<8761rl73s7.fsf@xmission.com>
	<20131122015518.GA31921@redhat.com>
	<CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com>
	<20131122134317.GA4046@redhat.com>
Date: Fri, 22 Nov 2013 16:25:44 +0100
X-Google-Sender-Auth: CNY1uDNZEKe4HCaTFfYbd7EK2P0
Message-ID: <CAMuHMdV4=Z8i0u_rWpQU0HHW0mvyv1k-acW1MyT9ZYy=iNwrfg@mail.gmail.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 2:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Looking at kexec-tools, all of arm, cris, i386, ia64, m68k, mips, ppc, ppc64,
>> s390, sh, and x86_64 support ELF.
>
> How many of them use ELF to boot in real world? Also one can easily
> add ELF loader. I am just not able to see why ELF loader should be
> a requirement for this patchset.

Many bootloaders support ELF.

>> Only arm, i386, ppc, ppc64, sh, and x86_64 support zImage.
>> It's not clear to me what alpha supports (if it supports anything at all?).
>
> Motiviation behind this patchset is secureboot. That is x86 specific
> only and bzImage is most commonly used format on that platform. So it
> makes sense to implement bzImage loader first, IMO.

While secureboot(TM) may be x86-centric, IIRC actually loading signed kernels
and modules didn't originate on x86. Anything can have a bootloader that
accepts signed kernel images only.

Even without the signing, I like the simplicity of the new syscall, moving
some bookkeeping to and keeping some info in the kernel (e.g. the kernel
no longer needs to export system RAM chunks and device tree or
bootinfo).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
