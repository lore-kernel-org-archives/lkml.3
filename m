Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822Ab3BNSWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:22:39 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:45443 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431Ab3BNSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:22:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130214150810.GA26095@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
	<20130213111007.GA11367@gmail.com>
	<CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
	<alpine.LFD.2.02.1302140012460.22263@ionos>
	<20130214144510.GC25282@gmail.com>
	<20130214145424.GA26071@gmail.com>
	<20130214150810.GA26095@gmail.com>
Date: Thu, 14 Feb 2013 10:22:37 -0800
X-Google-Sender-Auth: P-ozeVtn-ApM-tWHKMnkz8rPMCs
Message-ID: <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 7:08 AM, Ingo Molnar <mingo@kernel.org> wrote:
> these three:
>
> 10d73e655cef mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment
> c060f943d092 mm: use aligned zone start for pfn_to_bitidx calculation
> c0232ae861df mm: memblock: fix wrong memmove size in memblock_merge_regions()
>
> might have highmem=512m boot parameter sensitivity.

10d73e655cef should not be related, as we are using nobootmem wrapper
of memblock.
c0232ae861df is copying less while using the blank slot in memblock
memory or reserved array
so it should be ok too.

c060f943d092 may be related as you config does not have
CONFIG_SPARSEMEM defined.

Thanks

Yinghai
