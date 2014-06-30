Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaF3GoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:44:08 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62384 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaF3GoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:44:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicholas Krause <xerofoify@gmail.com>, ulli.kroll@googlemail.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes gemmi_idle in file idle.c
Date: Mon, 30 Jun 2014 08:43:21 +0200
Message-ID: <72959333.SxQIV7k7ca@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404096760-5239-1-git-send-email-xerofoify@gmail.com>
References: <1404096760-5239-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OihV+6OjX6tz2lBYTTLyKPl8ll96CuuN0IjReorfwVk
 nae0SU3Zml+gjFnPUD+khuxJi7qHZSClti93aVeQRUI/+R2If1
 zbSJgeePENuLBes6sbE2jGdnA4hnlkNdXF+QvXMM3cWL1/1nFx
 4otvf/jqHthPv59+2BzEbCGTnbAhz47fQtxy8RaCaVj8rx8kq1
 nzPHXbyt8FyE24xEjFJwwSs/5IntKHtJ4KuIpaSEXYlkBN68Q6
 oP/eB9EuaRQH8OM/s0jStVuXrP3IKMs7TYuh7y9vYGvn3U6ppi
 tX4Y2Qm/xbhzyki+ki0Br10ETXs3c9O+E3O+oZXRs3TUuCTkJl
 5XHHEp78kou1ujMHh1Zs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 June 2014 22:52:40 Nicholas Krause wrote:
> disables the IRQ line in gemmi_idle before calling cpu_do_idle.
> In addition, according to the Fixme message in this file fixes
> races that may occur due to not disabling the IRQ before calling
> cpu_do_idle.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Have you actually read the comment above the function?

> diff --git a/arch/arm/mach-gemini/idle.c b/arch/arm/mach-gemini/idle.c
> index ddf8ec9..2880f5a 100644
> --- a/arch/arm/mach-gemini/idle.c
> +++ b/arch/arm/mach-gemini/idle.c
> @@ -17,8 +17,7 @@ static void gemini_idle(void)
>          * disabled.
>          */
>  
> -       /* FIXME: Enabling interrupts here is racy! */
> -       local_irq_enable();
> +       local_irq_disable();
>         cpu_do_idle();
>  }

This has the same effect as deleting the entire file. Doing that
is probably the right thing now that 8182a34d85698 ("ARM: 7760/1:
cpu_fa526_do_idle: remove WFI") has been merged, but that needs
a better changeset description to explain why it was needed before
and is not needed any more.

Please submit a new patch doing that.

	Arnd
