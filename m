Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaAES50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:57:26 -0500
Received: from mail.active-venture.com ([67.228.131.205]:51068 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAES5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:57:24 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52C9AB14.8060603@roeck-us.net>
Date: Sun, 05 Jan 2014 10:57:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Karsten Keil <isdn@linux-pingi.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] isdn: Build telespci and hfc_pci only for little endian
 CPUs
References: <1388944204-13008-1-git-send-email-linux@roeck-us.net> <CAMuHMdVfr0ExtrU7bNUttJwkMXv-ZRo0A=j3gJ-=9nakP0uP+g@mail.gmail.com>
In-Reply-To: <CAMuHMdVfr0ExtrU7bNUttJwkMXv-ZRo0A=j3gJ-=9nakP0uP+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2014 10:30 AM, Geert Uytterhoeven wrote:
> On Sun, Jan 5, 2014 at 6:50 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> -       depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
>> +       depends on CPU_LITTLE_ENDIAN && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || MIPS || FRV || XTENSA))
>
> Unfortunately CPU_LITTLE_ENDIAN is only available on architectures
> that support two endiannesses. So the above will preclude e.g. x86, which is
> where most ISDN users are.
>
> One solution is to move CPU_LITTLE_ENDIAN and CPU_BIG_ENDIAN to the
> common Kconfig parts. After that, the dependency above can just become
>
>      depends on CPU_LITTLE_ENDIAN && PCI.
>

Excellent idea, but more invasive than I want to get into. I'll mark the build for the drivers
as broken for big endian ARM machines instead. The cleanup you suggested can then go in as
separate patch (if wanted).

Thanks,
Guenter

