Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3EPNfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:35:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3EPNfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:35:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
Date: Thu, 16 May 2013 15:35:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        linux-kernel@vger.kernel.org
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com> <201305160054.21064.arnd@arndb.de> <20130516085711.GP18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130516085711.GP18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305161535.03742.arnd@arndb.de>
X-Provags-ID: V02:K0:2DwCvEY4VTD+iel13zBspMsw71j9SpNBUEzFlztDCsQ
 uzhxBQSqTlKkXv0suSA+N4Hnw1NRnIqkJTk4M2L8bzzjSv6UPS
 IX6I2jRjD1S/1yvHSfWH0iYau/X1FC9iny523b+I6uuuiUxmE3
 B52BbBDkjNHuUJO+FBozw8vLQ6X4TsuYBJWsjIrS6dtY9O3QxN
 eRHGBrCHdYEim0MKnIZATLYec3SoVkpK4q17Uc6oBfsp0AK9A7
 JulTpkGcQT/EBxJJnPPj4wlZUDRudSGxroKCilHAbeL0PkfyW9
 Yvbww/8RWq89mBJ+vIX2TmcJI8J5e6h+Q1H587KXefIos9YPDo
 CUY/RTFJDMNJnacmNIgw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 May 2013, Russell King - ARM Linux wrote:
> Well, if its a CPU core thing, then it's even easier - the proc-*.S
> file can handle it just fine (because that's where the WFI code is.)
> Just delete the contents of the processor specific idle function, IOW:
> 
> /*
>  * cpu_fa526_do_idle()
>  */
>         .align  4
> ENTRY(cpu_fa526_do_idle)
>         mcr     p15, 0, r0, c7, c0, 4           @ Wait for interrupt
>         mov     pc, lr
> 
> remove the WFI from there.

Yes, that was what I meant.

	Arnd
