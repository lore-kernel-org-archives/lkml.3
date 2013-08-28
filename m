Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3H1Rxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:53:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3H1Rxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:53:44 -0400
Date: Wed, 28 Aug 2013 10:56:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Joe Perches <joe@perches.com>, Jason Baron <jbaron@akamai.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/1] dev-core: fix build break when DEBUG is enabled
Message-ID: <20130828175604.GA14095@kroah.com>
References: <CACE9dm_msF7e2aKEeT0J6maxnka1NpaAbTWTp5r1MbpDHSw4Kg@mail.gmail.com>
 <20130828175031.GA26807@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130828175031.GA26807@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 10:50:31AM -0700, Sarah Sharp wrote:
> Any objections to queuing this patch through Greg's usb-next tree?  I've
> already sent the 2/2 patch, which will cause build breakage without this
> patch.
> 
> Changes since v2:
>  - Fixed a checkpatch warning caused by a comment in a macro.
> 
> Sarah Sharp
> 
> >8----------------------------------------------------------------8<
> 
> From: Dmitry Kasatkin <d.kasatkin@samsung.com>
> 
> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
> It leads to build break.
> For example, when I try to use dev_dbg_ratelimited in USB code and
> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:
> 
>   CC [M]  drivers/usb/host/xhci-ring.o
>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_intr_tx’:
>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘DEFINE_DYNAMIC_DEBUG_METADATA’ [-Werror=implicit-function-declaration]
>   drivers/usb/host/xhci-ring.c:3059:3: error: ‘descriptor’ undeclared (first use in this function)
>   drivers/usb/host/xhci-ring.c:3059:3: note: each undeclared identifier is reported only once for each function it appears in
>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘__dynamic_pr_debug’ [-Werror=implicit-function-declaration]
>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_isoc_tx_prepare’:
>   drivers/usb/host/xhci-ring.c:3847:3: error: ‘descriptor’ undeclared (first use in this function)
>   cc1: some warnings being treated as errors
>   make[2]: *** [drivers/usb/host/xhci-ring.o] Error 1
>   make[1]: *** [drivers/usb/host] Error 2
>   make: *** [drivers/usb/] Error 2
> 
> This patch separates definition for CONFIG_DYNAMIC_DEBUG and DEBUG cases.
> 
> [Note, Sarah moved the comment above the macro to avoid checkpatch
> warnings.]
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
