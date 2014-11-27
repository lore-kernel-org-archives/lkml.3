Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbaK0RxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:53:07 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:59557 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaK0RxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:53:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: grant.likely@linaro.org, kbuild-all@01.org, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] m32r: Add missing big-endian I/O accessors
Date: Thu, 27 Nov 2014 18:52:58 +0100
Message-ID: <75201216.LyHlPqmjDS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417110404-13297-2-git-send-email-cernekee@gmail.com>
References: <1417110404-13297-1-git-send-email-cernekee@gmail.com> <1417110404-13297-2-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:eA8smMS4rnOuwyOWh7WT5ma3MbFwTZAUA0FaS5TAMa4
 pmFrBKA6vnPT4828Ilefcdb9Nv+qbij6Q0DeGSj1m/kmdpBm5t
 TpN8zdtMPZ0zkDDYdZV3cFI/3zKA7DntTj+0guqhc5MhBzr8aI
 NoEmkPNu3L+1jGIDPaTZNe/q312jK7dNRHdb0Bpwrbo4+2Nb+9
 2cqXYTgQqtAuIE0OJnG4eNGYklOK2zH/cwpmlcUBuFkAzXlyBM
 PpG8WcI17OK2bnBvmNc6aIdbyDebq/aQ3i3Moei+9LwrA/2+9a
 gOsJR9x3BC8gOnKTAS3fZrYVymaTH2GAiY1pJxbQaSDy1EhrKk
 P9xk6T33sJM94o95V0UQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 09:46:44 Kevin Cernekee wrote:
>  #define iowrite32 writel
>  
> +#define ioread16be(addr)       be16_to_cpu(readw(addr))
> +#define ioread32be(addr)       be32_to_cpu(readl(addr))
> +#define iowrite16be(val, addr) writew(cpu_to_be16(val), addr)
> +#define iowrite32be(val, addr) writel(cpu_to_be32(val), addr)
> +
> 

m32r can be either little-endian or big-endian, so these need to
unconditionally swap instead.

	Arnd
