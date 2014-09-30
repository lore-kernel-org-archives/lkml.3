Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaI3Kjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:39:41 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64760 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaI3Kji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:39:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, naushad@samsung.com, tomasz.figa@gmail.com,
        thomas.ab@samsung.com, vikas.sajjan@samsung.com
Subject: Re: [PATCH v8 2/2] ARM: EXYNOS: Move PMU specific definitions from common.h
Date: Tue, 30 Sep 2014 12:38:58 +0200
Message-ID: <11948982.c37J1JPj8N@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412072481-22370-3-git-send-email-pankaj.dubey@samsung.com>
References: <1412072481-22370-1-git-send-email-pankaj.dubey@samsung.com> <1412072481-22370-3-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RphkNFm2L4bWMPMZR2x8AwI/CVzr/YmGZZsnqKa7xhb
 HwWstnFT/+WWNtr2yDu3mHmMP70uwDYcttl/GvIhvZVtH/dBs2
 evNO4WivIyc3ZfO8RNZkShXhwczx2V+gV567B3kJQ4zH7Wn2iF
 dXyoOyk4fEP7xD2tWinI60vD+s0ZLwUgiAb5IEl0M7d55Eu4u8
 b41dyctFxtp6cjt/v1TNBUBg5GiJeVHhETl/qXPjPFQeXTL99a
 GrIxh41q4nVeCsitUQhsMSJJVk/YOkZG46gBAQakec9309Tapy
 7ujczmQKchDbfZ4CYKr4S7xv8Z4NicuE3ZA3LHJguO1xciCtT1
 VUxXF7FUx5f+6h2lXDHQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 15:51:21 Pankaj Dubey wrote:
> 
> +static inline void pmu_raw_writel(u32 val, u32 offset)
> +{
> +       __raw_writel(val, pmu_base_addr + offset);
> +}
> +
> +static inline u32 pmu_raw_readl(u32 offset)
> +{
> +       return __raw_readl(pmu_base_addr + offset);
> +}
> +
> 

While you're at it, please convert these to use readl_relaxed() instead,
which is safe to use in drivers and works independent of CPU endianess.

	Arnd
