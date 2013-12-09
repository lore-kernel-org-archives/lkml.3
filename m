Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab3LIBNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:13:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3LIBNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:13:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 6/9] ARM: dts: pxa3xx: move declaration to header
Date: Mon, 9 Dec 2013 02:13:27 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <1386543229-1542-1-git-send-email-ynvich@gmail.com> <1386543229-1542-7-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386543229-1542-7-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312090213.27395.arnd@arndb.de>
X-Provags-ID: V02:K0:mnNY/GXbp0h0STscbgwrv6PWs+IsiKjbp/u0UuI1W2W
 vnd9N3wrH8b2/+lsh7hjitXXKtjZMSV6EFXfudmWz2bPP5aWM3
 OJPGf33MnvXhISI+PcVbXPOjzX0wZej8PWFVBSTseqh8OqPMeA
 Nr6bCb0aoKXt4k1G97OWi7+f6k2MtOgqKU8dTEYCSsmJoVfCbK
 n+GwketCZ/RZKefw8n/JeM8ztMbF61R/w46rj1BMUqIoQO6B2s
 zSyuraW3X6zuloIYB2pxaIY5k7bgyk+qP2BjQ+ZOchqslfBy0/
 Ere+6hEDQs652Uv1AXyD/P9ezfyPKZrJLHiqD50D9PxCE9CyHL
 kJLhwDf9ovmL9qdszbo8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 December 2013, Sergei Ianovich wrote:
> +#ifdef CONFIG_OF
> +extern void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int));
> +#endif /* CONFIG_OF */
> +

In general, don't put declarations like this into #ifdef, unless you need
an #else clause like

static inline void pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int) {}

Same in patch 8.

	Arnd
