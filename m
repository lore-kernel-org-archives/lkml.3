Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3AYQkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:40:52 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59822 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3AYQku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:40:50 -0500
Date: Fri, 25 Jan 2013 11:40:48 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        tglx@linutronix.de
Message-ID: <1344460915.280514.1359132048723.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <20130125073735.GC18243@gmail.com>
Subject: Re: [tip:x86/platform] x86: Add TS-5500 platform support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> This patch still appears to have some problems with certain
> (rare) LEDS .config variations:
> 
>  arch/x86/built-in.o: In function `ts5500_init':
>  ts5500.c:(.init.text+0xdae6): undefined reference to
>  `led_classdev_register'
> 
> Config attached.
> 
> Please fix & resend.

I think the attached config might not be the right one. This issue
happens when the ts5500 support is selected (CONFIG_TS5500=y) but
the LED class (CONFIG_NEW_LEDS and CONFIG_LEDS_CLASS) is not.

Thanks for pointing this out.
The following patch below solves this issue. Is it ok, or should
I resend to whole board support patch?

Thanks,
Vivien

--------


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df5815e..9394759 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2191,6 +2191,8 @@ config TS5500
        bool "Technologic Systems TS-5500 platform support"
        depends on MELAN
        select CHECK_SIGNATURE
+       select NEW_LEDS
+       select LEDS_CLASS
        ---help---
          This option enables system support for the Technologic Systems TS-5500.
