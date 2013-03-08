Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab3CHTBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:01:13 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:65475 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3CHTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <1362768434-30525-1-git-send-email-david.vrabel@citrix.com>
References: <1362768434-30525-1-git-send-email-david.vrabel@citrix.com>
Date: Fri, 8 Mar 2013 11:01:12 -0800
X-Google-Sender-Auth: MdRfc3R58wU7uoDhq7KdZS0nfxY
Message-ID: <CAE9FiQX38v_3-zMebjbUPum+Tt1z1jrDAzAfXo4o1j4X-xbHSg@mail.gmail.com>
Subject: Re: [PATCH] x86,mm: fix init_mem_mapping() when the first memory
 chunk is small
From: Yinghai Lu <yinghai@kernel.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 10:47 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> In init_mem_mapping(), if the first chunk of memory that is mapped is
> small, there will not be enough mapped pages to allocate page table
> pages for the next (larger) chunk.
>
> Estimate how many pages are used for the mappings so far and how many
> are needed for a larger chunk, and only increase step_size if there
> are enough free pages.
>
> This fixes a boot failure on a system where the first chunk of memory
> mapped only had 3 pages in it.
>
> init_memory_mapping: [mem 0x00000000-0x000fffff]
> init_memory_mapping: [mem 0x20d000000-0x20d002fff]
> init_memory_mapping: [mem 0x20c000000-0x20cffffff]
> Kernel panic - not syncing: alloc_low_page: can not alloc memory

Can you check current linus tree?

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=98e7a989979b185f49e86ddaed2ad6890299d9f0

should fix the problem with your system.

Thanks

Yinghai
