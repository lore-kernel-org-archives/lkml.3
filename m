Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3GZAbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:31:32 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:54044 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab3GZAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:31:31 -0400
MIME-Version: 1.0
In-Reply-To: <5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
	<20130725200551.GA16719@gmail.com>
	<5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com>
Date: Thu, 25 Jul 2013 17:31:29 -0700
X-Google-Sender-Auth: cYj8cu2sjcxj5BO21sJ1_Wb8dq0
Message-ID: <CA+55aFyDXkvc7mK2trfHA2Wj9vRu2FkCeZuZVfRvmbak1TqUmA@mail.gmail.com>
Subject: Re: Ugly patches for stolen reservation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 3:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> So the bootloader is just as likely to step on things... what happens when/if it does?

This isn't a new problem. We've had this "firmware tables don't show
all devices" issue before.

The only odd thing about this one is how the quirk in question uses
"e820_add_region()" instead of just adding things to the MMIO list.
And I think that's actually likely a mistake.

So Jesse, why don't you do what the other quirks do, and claim an
actual MMIO resource? If you make it a real resource, you'll get to
use fancy things like REAL NAMES, and actually document it. With
human-readable strings.

See quirk_io_region() in drivers/pci/quirks.c for example. The same
code except for IORESOURCE_MEM should do a lovely job..

And even *if* it's already marked reserved in the e820 table, it just
looks nice in /proc/iomem.

Hmm?

           Linus
