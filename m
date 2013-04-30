Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab3D3U4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:56:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab3D3U4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:56:05 -0400
Date: Tue, 30 Apr 2013 13:56:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        David Sterba <dsterba@suse.cz>, Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 3/5] arm: Add support for LZ4-compressed kernel
Message-Id: <20130430135602.2aa0d3b4ec392bf83a9b64d0@linux-foundation.org>
In-Reply-To: <1362484056-9778-4-git-send-email-kyungsik.lee@lge.com>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
	<1362484056-9778-4-git-send-email-kyungsik.lee@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Mar 2013 20:47:34 +0900 Kyungsik Lee <kyungsik.lee@lge.com> wrote:

> This patch integrates the LZ4 decompression code to the arm pre-boot code.
> And it depends on two patchs below
> 
> lib: Add support for LZ4-compressed kernel
> decompressor: Add LZ4 decompressor module
> 
> ...
>
> - Apply CFLAGS, -Os to decompress.o to improve decompress
>   performance during boot-up process
>
> ...
>
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -24,6 +24,9 @@ endif
>  AFLAGS_head.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
>  HEAD	= head.o
>  OBJS	+= misc.o decompress.o
> +ifeq ($(CONFIG_KERNEL_LZ4),y)
> +CFLAGS_decompress.o := -Os
> +endif

Surprised.  You found that -Os produces faster code than -O2?  Details,
please?

