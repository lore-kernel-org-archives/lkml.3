Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaA2Xjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:39:43 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39960 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA2Xjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:39:42 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJjEUJKo2ip8bDzDRVbBT+yhzqZXV0BYP3X52OJ3zA6Pg@mail.gmail.com>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
	<52E82A40.3040104@intel.com>
	<CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
	<20140129015048.GA14629@konrad-lan.dumpdata.com>
	<CA+8MBbJjEUJKo2ip8bDzDRVbBT+yhzqZXV0BYP3X52OJ3zA6Pg@mail.gmail.com>
Date: Wed, 29 Jan 2014 15:39:41 -0800
X-Google-Sender-Auth: RreNVxhwTAfQRuE-fHHiHcnSw6g
Message-ID: <CAE9FiQWfZk7ogmORm7euBy1bncUhFW0Ms2hV_g8_9uBVU71RRQ@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Yinghai Lu <yinghai@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 3:07 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Hmmph.  ia64 is broken too.  git bisect says:
>
> commit ad6492b80f60a2139fa9bf8fd79b182fe5e3647c
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Mon Jan 27 17:06:49 2014 -0800
>
>     memblock, nobootmem: add memblock_virt_alloc_low()
>
> is to blame.  But this patch doesn't fix it.  Still dies with:
>
> PID hash table entries: 4096 (order: -1, 32768 bytes)
> Sorting __ex_table...
> kernel BUG at mm/bootmem.c:504!

that's another path with memblock_virt wrapper for bootmem.

Let's me check that.
