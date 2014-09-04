Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaIDVnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:43:25 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52633 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbaIDVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:43:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Xia Kaixu <kaixu.xia@linaro.org>, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>, linaro-kernel@lists.linaro.org,
        Anton Vorontsov <anton@enomsg.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH] ARM: cns3xxx: fix allmodconfig panic in pci driver
Date: Thu, 04 Sep 2014 23:42:43 +0200
Message-ID: <7546804.XWPgHM2sst@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409750292-24105-1-git-send-email-kaixu.xia@linaro.org>
References: <kaixu.xia@linaro.org> <1409750292-24105-1-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Vg+GRY/KIlmBg4lL7LvV4A7wdtb06NjZvq6xNro4gnT
 rLOLn5HWJec9MXrPy6SfPXP6UFWZw4V4MTuCBzb6QVrdOB95nh
 zpTO7OLpKKKRgKfJ84QotQP4IDsQ+DW/N0BWoUHcVBoVgehP5O
 vtEnjJzodBC30Qkw651UOgdnPcYBsx0G7gE7cunsAnVlaTzPHb
 hVsMsxIoxGw0V0raPwTUj2yD4BeFYxU/86TUvsnkN+MAWZQeIp
 zKVqvCRo5zGU51MGC/F2FbEA/zVzb1/7kwOLj1ysctGIgetUjo
 re7WKk4n8zL5BTDwKoBmF+quNwqcmD9awU+UKthko7O5nz9PCb
 XxSGs0SYwiIxss1F1zGU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 21:18:12 Xia Kaixu wrote:
> 
> +#ifdef CONFIG_PCI
> +extern int __init cns3xxx_pcie_init_late(void);
> +#else
> +static inline int __init cns3xxx_pcie_init_late(void)
> +{
> +       return -ENXIO;
> +}
> +#endif
> +
>  void __init cns3xxx_map_io(void);
> 

I found another problem: we get a new compile-time warning
because the function returns an 'int' while the .init_late
callback expects a function returning 'void'.

I've fixed it up locally, but please be more careful about
introducing warnings in the future.

	Arnd
