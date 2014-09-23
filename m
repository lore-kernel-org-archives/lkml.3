Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaIWMkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:40:32 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60848 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaIWMka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:40:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v4 7/9] net: pxa168_eth: allow Berlin SoCs to use the pxa168_eth driver
Date: Tue, 23 Sep 2014 14:40:01 +0200
Message-ID: <4458671.9hKSvmlZNz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411474536-22626-8-git-send-email-antoine.tenart@free-electrons.com>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com> <1411474536-22626-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RIGlbkxXUM0Ale+b9fxQKJiXboFaCdhDYmLJpYyVNVr
 yor5NeFiaKfBO/sVFMh9xAgiDYnWtugRUrhT9X8fhYKJ7QPDGp
 0tknkfp5Dr76APLMUe7O5falPKNlxpvobJEXk672pdg9L7YDhQ
 Ghe1c+BevauZQk1t4ORblFXWg4UtNc6hWggwO1sGCsKymwzVl3
 H2+JXWG7amOCuxqTl4tJaizxrWi2yZFMtPw8nlUKrlkwKYBNsE
 yBh+1m+Ag/xQgxnEOQ+2pCyl1MDtM+sJ5Jm2V518DSgKmPUqmD
 kvQXWE2eZw5/cwahlzeSAG9885pjiB4auqyIlEcrOdpj6R9M4E
 xHJpjySZtpeZe1q81OrE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 14:15:34 Antoine Tenart wrote:
> diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> index 1b4fc7c639e6..48b9466d1781 100644
> --- a/drivers/net/ethernet/marvell/Kconfig
> +++ b/drivers/net/ethernet/marvell/Kconfig
> @@ -64,7 +64,7 @@ config MVPP2
>  
>  config PXA168_ETH
>         tristate "Marvell pxa168 ethernet support"
> -       depends on CPU_PXA168
> +       depends on CPU_PXA168 || ARCH_BERLIN
>         select PHYLIB
>         ---help---
>           This driver supports the pxa168 Ethernet ports.
> 

Myabe you can also add '|| COMPILE_TEST' here, to allow building it
on other architectures. Check if you need 'depends on OF' though.

	Arnd
