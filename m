Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab3IIBAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 21:00:35 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60906 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3IIBAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 21:00:34 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522D1DAE.5010100@roeck-us.net>
Date: Sun, 08 Sep 2013 18:00:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: sparc32 defconfig build broken due to commit ebd97be63 (PCI: remove
 ARCH_SUPPORTS_MSI kconfig option)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"make ARCH=sparc32 defconfig; make ARCH=sparc32" on the current upstream kernel results in:

In file included from arch/sparc/kernel/pci_msi.c:10:0:
arch/sparc/kernel/pci_impl.h:142:18: error: field 'stc' has incomplete type
arch/sparc/kernel/pci_msi.c: In function 'sparc64_setup_msi_irq':
arch/sparc/kernel/pci_msi.c:131:2: error: implicit declaration of function 'irq_alloc' [-Werror=implicit-function-declaration]
arch/sparc/kernel/pci_msi.c:173:2: error: implicit declaration of function 'irq_free' [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors
make[2]: *** [arch/sparc/kernel/pci_msi.o] Error 1

Bisect points to commit ebd97be635 (PCI: remove ARCH_SUPPORTS_MSI kconfig option).
After reverting this commit, sparc32:defconfig builds fine.

sparc64 defconfig is unaffected.

Guenter
