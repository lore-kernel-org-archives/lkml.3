Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaAHR5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:57:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44784 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaAHR5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:57:08 -0500
Message-ID: <52CD9139.2070302@zytor.com>
Date: Wed, 08 Jan 2014 09:56:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-5-git-send-email-jlee@suse.com>	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>	 <52CB929C.6050403@zytor.com> <1389091244.3539.6095.camel@linux-s257.site>	 <52CC2CDF.3000100@zytor.com> <1389193142.3539.6123.camel@linux-s257.site>
In-Reply-To: <1389193142.3539.6123.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 06:59 AM, joeyli wrote:
> 
> ACPICA denied AML access RTC ports.
> 
> I tried to access 0x70, 0x71 ports in ASL on a real machine, ACPICA
> denied AML access to those ports. I got the following dmesg:
> 
> hwvalid-0188 hw_validate_io_request: Denied AML access to port
> 0x0000000000000071/1
> 
> The code in acpica denied it:
> 
> linux/drivers/acpi/acpica/hwvalid.c
> 
>  * This provides ACPICA with the desired port protections and
>  * Microsoft compatibility.
>  *
>  * Description of port entries:
> [...]
>  *  RTC:   Real-time clock
>  *  CMOS:  Extended CMOS
> [...]
>  */
> static const struct acpi_port_info acpi_protected_ports[] = {
> [...]
>         {"RTC", 0x0070, 0x0071, ACPI_OSI_WIN_XP},
>         {"CMOS", 0x0074, 0x0076, ACPI_OSI_WIN_XP},
> 
> 
> Document of Windows XP:
> http://www.freelists.org/post/windows_errors/what-error-messages-really-mean-WinXP-IO-Ports-Blocked-from-Bios-AML-on-Windows-XP
> 
> If just for ACPI TAD testing, we can remove the port protection check of
> RTC ports in hwvalid.c. I have read 0x70/0x71 port success after removed
> the checking in acpica/hwvalid.c.
> 
> I will try to write RTC port in AML after remove acpica check, maybe
> have other unpredictable situation.
> 

Now *THERE* is a good use of the "no RTC bit".  In the case that bit is
set we should presumably remove these ports from the block list.

Otherwise we should use the CMOS address space, not the I/O port address
space.

	-hpa


