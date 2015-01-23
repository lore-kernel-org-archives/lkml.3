Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbbAWKVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:21:46 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:65077 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbAWKVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:21:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stathis Voukelatos <stathisv70@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Stathis Voukelatos <stathis.voukelatos@linn.co.uk>,
        abrestic@chromium.org
Subject: Re: [PATCH] net: Linn Ethernet Packet Sniffer driver
Date: Fri, 23 Jan 2015 11:21:37 +0100
Message-ID: <3515756.ch1oRd7PaS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk>
References: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:+Lr813aC9WJL7hzsz5LR24oR8yqobNHtYQUA3h9wKwOEQGgNS3X
 c40xaGwkDiwPPcCc1ultnxClyOgIsKKTlTZniBM+psuGH4KoMYI27UIk7OFV8cWFiohmGx5
 LU/hMfaKm6W7pNHsG5AO2f+g3EuQBRtKXA7t4k8wIWUUiErKXbvyqZh3x50ej09EY1xX9G6
 27UkzVucEbbKdYN39H6jQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2015 10:07:01 Stathis Voukelatos wrote:
> +- interrupts : sniffer interrupt specifier
> +- clocks : specify the system clock for the peripheral
> +- clock-names : must contain the "sys" entry
> +- fifo-block-words : number of words in one data FIFO entry
> +
> +Example:
> +
> +sniffer@1814a000 {
> +        compatible = "linn,eth-sniffer";
> +        reg = <0x1814a000 0x100>, <0x1814a400 0x400>, <0x1814a800 0x400>;
> +        reg-names = "regs", "tx-ram", "rx-ram";
> +        interrupts = <GIC_SHARED 58 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "eth-sniffer-irq";
> +        clocks = <&system_clk>;
> +        clock-names = "sys";
> +        fifo-block-words = <4>;
> 

The example contains an interrupt-names property that is not documented.
If you want to name interrupts, the exact name strings need to
be mandated by the binding. Alternatively just drop the name.
I notice that the driver requests the first interrupt without giving
a name anyway, and the description above suggests that there can
only be one interrupt.

	Arnd
