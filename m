Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab3CGMRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:17:36 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33598 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3CGMRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:17:34 -0500
MIME-Version: 1.0
In-Reply-To: <1362301836.13011.8.camel@mattotaupa>
References: <1362289680-3527-1-git-send-email-mc74hc00@gmail.com>
	<1362301836.13011.8.camel@mattotaupa>
Date: Thu, 7 Mar 2013 21:17:32 +0900
Message-ID: <CAHh0gOgCr2Hnj4JvK1DBXQ58Lb3o5D_beptfVDTXzbRFf676Fw@mail.gmail.com>
Subject: Re: [PATCH v2] sp5100_tco: Set the AcpiMmioSel bitmask value to 1
 instead of 2
From: Tanaka Takahisa <mc74hc00@gmail.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

2013/3/3 Paul Menzel <paulepanter@users.sourceforge.net>:
> From: Takahisa Tanaka <mc74hc00@gmail.com>
> Date: Sun, 3 Mar 2013 14:48:00 +0900
>
> The AcpiMmioSel bit is bit 1 in the AcpiMmioEn register, but the current
> sp5100_tco driver is using bit 2.
>
> See 2.3.3 Power Management (PM) Registers page 150 of the
> AMD SB800-Series Southbridges Register Reference Guide [1].
>
>         AcpiMmioEn - RW – 8/16/32 bits - [PM_Reg: 24h]
>         Field Name        Bits  Default  Description
>         AcpiMMioDecodeEn  0     0b       Set to 1 to enable AcpiMMio space.
>         AcpiMMIoSel       1     0b       Set AcpiMMio registers to be memory-mapped or IO-mapped space.
>                                          0: Memory-mapped space
>                                          1: I/O-mapped space
>
> The sp5100_tco driver expects zero as a value of AcpiMmioSel (bit 1).
>
> Fortunately, no problems were caused by this typo, because the default
> value of the undocumented misused bit 2 seems to be zero.
>
> However, the sp5100_tco driver should use the correct bitmask value.
>
> [1] http://support.amd.com/us/Embedded_TechDocs/45482.pdf
>
> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
> CC: stable@vger.kernel.org
> Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
> ---
> v2: Hopefully improved the commit message.
>
>  drivers/watchdog/sp5100_tco.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
> index 71594a0..2b28c00 100644
> --- a/drivers/watchdog/sp5100_tco.h
> +++ b/drivers/watchdog/sp5100_tco.h
> @@ -57,7 +57,7 @@
>  #define SB800_PM_WATCHDOG_DISABLE      (1 << 2)
>  #define SB800_PM_WATCHDOG_SECOND_RES   (3 << 0)
>  #define SB800_ACPI_MMIO_DECODE_EN      (1 << 0)
> -#define SB800_ACPI_MMIO_SEL            (1 << 2)
> +#define SB800_ACPI_MMIO_SEL            (1 << 1)
>
>
>  #define SB800_PM_WDT_MMIO_OFFSET       0xB00
> --
> 1.7.10.4

I'm sorry for late reply.
Thank you for improving the commit log.


Regards,
Takahisa
