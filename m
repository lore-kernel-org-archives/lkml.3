Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3HZECS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:02:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54411 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3HZECR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:02:17 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <521AD347.1090601@roeck-us.net>
Date: Sun, 25 Aug 2013 21:02:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Steve Cotton <steve@s.cotton.clara.co.uk>
Subject: Re: Commit 9a11899 (USB: OHCI: add missing PCI PM callbacks to ohci-pci.c)
 breaks several builds
References: <521ACBEF.60006@roeck-us.net>
In-Reply-To: <521ACBEF.60006@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2013 08:30 PM, Guenter Roeck wrote:
> Broken builds:
>      mips:ath79_defconfig
>      parisc:defconfig
>      sparc32:defconfig
>      sparc64:defconfig
>      tile:defconfig
>
Add:
	powerpc:ppc64e_defconfig
	powerpc:cell_defconfig
	powerps:maple_defconfig

That makes it 8 out of 82 builds, or roughly 10% of all builds.

My qemu test build for powerpc (which has its own config file)  fails as well :(.

Guenter

> Error log:
> drivers/usb/host/ohci-pci.c: In function 'ohci_pci_init':
> drivers/usb/host/ohci-pci.c:309:35: error: 'ohci_suspend' undeclared (first use in this function)
> drivers/usb/host/ohci-pci.c:309:35: note: each undeclared identifier is reported only once for each function it appears in
> drivers/usb/host/ohci-pci.c:310:34: error: 'ohci_resume' undeclared (first use in this function)
> make[3]: *** [drivers/usb/host/ohci-pci.o] Error 1
>
> Guenter

