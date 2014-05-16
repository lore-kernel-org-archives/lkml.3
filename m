Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaEPXMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:12:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60797 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbaEPXMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:12:21 -0400
Message-ID: <53769B27.2090407@zytor.com>
Date: Fri, 16 May 2014 16:11:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, "Joseph S. Myers" <joseph@codesourcery.com>
CC: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk> <9236147.lyD24Zv5SZ@wuerfel>
In-Reply-To: <9236147.lyD24Zv5SZ@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 01:38 PM, Arnd Bergmann wrote:
> 
> For practical purposes in the kernel, we may still want to use 64-bit
> nanoseconds: if we use a 96 bit struct timespec, that would be incompatible
> with the native type on 64-bit kernels, thus complicating the syscall
> emulation layer.
> 
> I don't know why timespec on x32 uses 'long tv_nsec', it does seem
> problematic.

struct timespec is specified in POSIX as having type "long" for tv_nsec.
 This, as Linus pointed out, is totally braindamaged.

x32 does not follow POSIX (Linus pretty much dictated that), and instead
does the __kernel_suseconds_t to match the native kernel type.  The
proposal at some point was to try to push a snseconds_t into POSIX.

	-hpa

