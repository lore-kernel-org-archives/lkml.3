Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3A1WZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:25:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3A1WZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:25:13 -0500
Date: Mon, 28 Jan 2013 14:25:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
Message-Id: <20130128142510.68092e10.akpm@linux-foundation.org>
In-Reply-To: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2013 14:50:43 +0900
Kyungsik Lee <kyungsik.lee@lge.com> wrote:

> This patchset is for supporting LZ4 compressed kernel and initial ramdisk on
> the x86 and ARM architectures.
> 
> According to http://code.google.com/p/lz4/, LZ4 is a very fast lossless
> compression algorithm and also features an extremely fast decoder.
> 
> Kernel Decompression APIs are based on implementation by Yann Collet
> (http://code.google.com/p/lz4/source/checkout).
> De/compression Tools are also provided from the site above.
> 
> The initial test result on ARM(v7) based board shows that the size of kernel
> with LZ4 compressed is 8% bigger than LZO compressed  but the decompressing
> speed is faster(especially under the enabled unaligned memory access).
> 
> Test: 3.4 based kernel built with many modules
> Uncompressed kernel size: 13MB
> lzo: 6.3MB, 301ms
> lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)
> 
> It seems that it___s worth trying LZ4 compressed kernel image or ramdisk 
> for making the kernel boot more faster.
>
> ...
>
>  20 files changed, 663 insertions(+), 3 deletions(-)
>
> ...
>

What's this "with enabled unaligned memory access" thing?  You mean "if
the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
that's only x86, which isn't really in the target market for this
patch, yes?

It's a lot of code for a 50ms boot-time improvement.  Does anyone have
any opinions on whether or not the benefits are worth the cost?

