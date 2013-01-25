Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3AYNmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:42:22 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:64950 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319Ab3AYNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:42:20 -0500
Message-ID: <1359121338.883.8.camel@x61.thuisdomein>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 25 Jan 2013 14:42:18 +0100
In-Reply-To: <1359120339.883.4.camel@x61.thuisdomein>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	 <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
	 <1359108275.6647.4.camel@x61.thuisdomein>
	 <CACRpkdb0V=yasmJv1ygL7cq6G3uGf6+QAZ7GR5a3bb1-XJgiiA@mail.gmail.com>
	 <1359115232.6647.14.camel@x61.thuisdomein>
	 <CACRpkdbUU=TOeaHNwAw-=iTxtkQDNuS4KeVBFX4yirZa+fQ2uw@mail.gmail.com>
	 <1359120339.883.4.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2013 13:42:18.0554 (UTC) FILETIME=[CB27E1A0:01CDFB01]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 14:25 +0100, Paul Bolle wrote:
> 0) insmod-ing an updated lpc_ich.ko generated quite a bit of noise in
> dmesg:
>     <6>[19913.247530] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
>     <6>[19913.249310] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
>     <4>[19913.249332] ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20120913/utaddress-251)
>     <6>[19913.249338] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>     <4>[19913.249342] ACPI Warning: 0x00000000000011b0-0x00000000000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
>     <6>[19913.249347] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>     <4>[19913.249349] ACPI Warning: 0x0000000000001180-0x00000000000011af SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
>     <6>[19913.249353] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>     <4>[19913.249355] lpc_ich: Resource conflict(s) found affecting gpio_ich
> 
> I have no idea whatsoever what that could mean.

But please note that these messages are nothing new. I found identical
messages in all my logs (from v3.7.y kernels; I do not seem to have logs
of older releases anymore).


Paul Bolle

