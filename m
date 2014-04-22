Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaDVMbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:31:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:64190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbaDVMa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:30:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 16/28] nios2: System calls handling
Date: Tue, 22 Apr 2014 14:30:39 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <1397824031-4892-13-git-send-email-lftan@altera.com>
In-Reply-To: <1397824031-4892-13-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221430.40237.arnd@arndb.de>
X-Provags-ID: V02:K0:ojkEDJYw5r/n2TKIJF/sV7TmYMTv1IpFCLBrFXtu3DO
 1EELT1WUay7y4mtIu/q3Nu1f1ct4PraNXyjQRULQPqY2LALF0+
 zZIP85aVNylgqMUeG92s96/5yF6evVe2tss7JvvmrOPR/zrjmK
 NNd7reaXyOTHCs2ODs6RqkuG4OrJVj0sx39QoVD1U1DA+824Ce
 rkeuguJ6OvB6Eq/lfSAvM+aW/Hg3gTVMvft8SnGYB96ncjmXz7
 yO07Xca2BtKfdddVwl23SrcJLO+HiRWOW4H0NZG7/ej/GfB14t
 NRGUDnl986hSukfodPW6vCx+nV1XPslh6fQOqYGV4PCatOsyGN
 48r/LwO37TcMjd8YPv6I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2014, Ley Foon Tan wrote:

> +
> + #define sys_mmap2 sys_mmap_pgoff
> +

You use sys_mmap_pgoff here, but

> +asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
> +			unsigned long prot, unsigned long flags,
> +			unsigned long fd, unsigned long offset)
> +{
> +	if (offset & ~PAGE_MASK)
> +		return -EINVAL;
> +
> +	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
> +}

define a separate sys_mmap() here. Doing the former should be enough.
so you can just drop the sys_mmap definition.

	Arnd
