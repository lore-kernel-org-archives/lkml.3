Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3H1J4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:56:43 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48216 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3H1J4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:56:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUTBYMxLPBv2fq86h3dxyANhtpd6=Q4XGMscrntPNA9bQ@mail.gmail.com>
References: <CA+icZUUTBYMxLPBv2fq86h3dxyANhtpd6=Q4XGMscrntPNA9bQ@mail.gmail.com>
Date: Wed, 28 Aug 2013 11:56:39 +0200
Message-ID: <CA+icZUW6JMa6VoRJ62AUZDpYm2_q_tzSM0Ryb56RNnCdEhwQyA@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 28 [ xhci build breakage ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:49 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi all,
>
> Changes since 20130827:
>
> The f2fs tree lost its build failure.
>
> The md tree gained a conflict against the arm tree.
>
> The libata tree lost its build failure.
>
> The spi tree lost its build failure.
>
> The arm-soc tree gained conflicts against the usb tree.
>
> The dma-mapping tree gained a conflict against the driver-core tree.
>
> The akpm-current tree gained a conflict against the net tree.
>
> ----------------------------------------------------------------------------
>
> My build here breaks like this:
>
>   CC      drivers/usb/host/xhci-ring.o
>   CC      drivers/video/console/softcursor.o
> drivers/usb/host/xhci-ring.c: In function 'xhci_queue_intr_tx':
> drivers/usb/host/xhci-ring.c:3090:3: error: implicit declaration of
> function 'DEFINE_DYNAMIC_DEBUG_METADATA'
> [-Werror=implicit-function-declaration]
> drivers/usb/host/xhci-ring.c:3090:3: error: 'descriptor' undeclared
> (first use in this function)
> drivers/usb/host/xhci-ring.c:3090:3: note: each undeclared identifier
> is reported only once for each function it appears in
> drivers/usb/host/xhci-ring.c:3090:3: error: implicit declaration of
> function '__dynamic_pr_debug' [-Werror=implicit-function-declaration]
> drivers/usb/host/xhci-ring.c: In function 'xhci_queue_isoc_tx_prepare':
> drivers/usb/host/xhci-ring.c:3875:3: error: 'descriptor' undeclared
> (first use in this function)
> cc1: some warnings being treated as errors
> make[5]: *** [drivers/usb/host/xhci-ring.o] Error 1
> make[4]: *** [drivers/usb/host] Error 2
>
> My kernel-config is attached.
>

Looks like <linux/device.h> or <linux/dynamic_debug.h> is missing.

$ egrep -w '__dynamic_pr_debug|DEFINE_DYNAMIC_DEBUG_METADATA' -nr linux/include/
linux/include/linux/device.h:1118:
DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);                 \
linux/include/linux/device.h:1121:
__dynamic_pr_debug(&descriptor, pr_fmt(fmt),            \
linux/include/linux/dynamic_debug.h:45:int __dynamic_pr_debug(struct
_ddebug *descriptor, const char *fmt, ...);
linux/include/linux/dynamic_debug.h:63:#define
DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)         \
linux/include/linux/dynamic_debug.h:76:
DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
linux/include/linux/dynamic_debug.h:78:
__dynamic_pr_debug(&descriptor, pr_fmt(fmt),    \
linux/include/linux/dynamic_debug.h:84:
DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
linux/include/linux/dynamic_debug.h:92:
DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
linux/include/linux/dynamic_debug.h:101:
DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,               \

Can't say which one is preferred here.

- Sedat -
