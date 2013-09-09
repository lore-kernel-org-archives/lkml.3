Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3IIHFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 03:05:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329Ab3IIHFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 03:05:50 -0400
Date: Mon, 9 Sep 2013 09:05:45 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: sparc32 defconfig build broken due to commit ebd97be63 (PCI:
 remove ARCH_SUPPORTS_MSI kconfig option)
Message-ID: <20130909090545.7c90880b@skate>
In-Reply-To: <522D1DAE.5010100@roeck-us.net>
References: <522D1DAE.5010100@roeck-us.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Guenter Roeck,

On Sun, 08 Sep 2013 18:00:30 -0700, Guenter Roeck wrote:

> "make ARCH=sparc32 defconfig; make ARCH=sparc32" on the current upstream kernel results in:
> 
> In file included from arch/sparc/kernel/pci_msi.c:10:0:
> arch/sparc/kernel/pci_impl.h:142:18: error: field 'stc' has incomplete type
> arch/sparc/kernel/pci_msi.c: In function 'sparc64_setup_msi_irq':
> arch/sparc/kernel/pci_msi.c:131:2: error: implicit declaration of function 'irq_alloc' [-Werror=implicit-function-declaration]
> arch/sparc/kernel/pci_msi.c:173:2: error: implicit declaration of function 'irq_free' [-Werror=implicit-function-declaration]
> cc1: all warnings being treated as errors
> make[2]: *** [arch/sparc/kernel/pci_msi.o] Error 1
> 
> Bisect points to commit ebd97be635 (PCI: remove ARCH_SUPPORTS_MSI kconfig option).
> After reverting this commit, sparc32:defconfig builds fine.
> 
> sparc64 defconfig is unaffected.

Thanks for the report, I'll have a look very soon.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
