Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3HZDa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:30:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60069 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3HZDa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:30:57 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <521ACBEF.60006@roeck-us.net>
Date: Sun, 25 Aug 2013 20:30:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Steve Cotton <steve@s.cotton.clara.co.uk>
Subject: Commit 9a11899 (USB: OHCI: add missing PCI PM callbacks to ohci-pci.c)
 breaks several builds
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Broken builds:
	mips:ath79_defconfig
	parisc:defconfig
	sparc32:defconfig
	sparc64:defconfig
	tile:defconfig

Error log:
drivers/usb/host/ohci-pci.c: In function 'ohci_pci_init':
drivers/usb/host/ohci-pci.c:309:35: error: 'ohci_suspend' undeclared (first use in this function)
drivers/usb/host/ohci-pci.c:309:35: note: each undeclared identifier is reported only once for each function it appears in
drivers/usb/host/ohci-pci.c:310:34: error: 'ohci_resume' undeclared (first use in this function)
make[3]: *** [drivers/usb/host/ohci-pci.o] Error 1

Guenter
