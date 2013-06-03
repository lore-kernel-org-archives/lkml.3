Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3FCNuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:50:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:50:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        ulf.hansson@linaro.org
Subject: Re: [PATCH 09/21] ARM: ux500: Supply the UART clocks lookup to the DBX500 DT
Date: Mon, 03 Jun 2013 15:50:20 +0200
Message-ID: <196465635.q8uKhQ7JEM@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370266965-7901-10-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org> <1370266965-7901-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pqzLyXpLrdn+Img7HKt5WEGIQunoSLGSG4h9+7tVlE+
 EzVAqZsv8yy1GXcrJ93LcV0PZfwU7Hyh7RVMRlgG74h++N6I0q
 BCwOMt0yIsL/0FG3N2Zyxf1AsQyBvmf7e/YYLZv9qXf1ym03wV
 3Bi1UVOGd+BykoPKeV+iix4scWsudpLy13+FgxzvTGd0P+2exd
 pIzRUlhyB4K5lq/w1Rf2294WzT7K2nkCewzMb3EbaAhzlfbo8i
 2Pb5b+ADMmfyNVFPIwTLjmumZXD7TLTvSjBTJUQxBTx2yCYGDr
 9U33RC/f1k9H4vPfH86VfZt0Kwr/rg5trgIlC3Gww1o/fhEO+Z
 YQi9mJdJNF/QYPtrVJdY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 14:42:33 Lee Jones wrote:
> @@ -650,6 +650,9 @@
>                                <&dma 13 0 0x0>; /* Logical - MemToDev */
>                         dma-names = "rx", "tx";
>  
> +                       clocks = <&clk 83>, <&clk 40>;
> +                       clock-names = "uart0", "apb_pclk";
> +
>                         status = "disabled";
>                 };
>  
> @@ -662,6 +665,9 @@
>                                <&dma 12 0 0x0>; /* Logical - MemToDev */
>                         dma-names = "rx", "tx";
>  
> +                       clocks = <&clk 84>, <&clk 41>;
> +                       clock-names = "uart1", "apb_pclk";
> +
>                         status = "disabled";
>                 };
>  

This seems wrong: why would one of them have a clock named "uart0"
and the other one call it "uart1"? The clock name should be defined
in the binding and specific to the driver using it, not a string that
indicates where it is connected to.

	Arnd
