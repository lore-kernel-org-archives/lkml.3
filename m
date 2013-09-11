Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3IKNkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:40:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62625 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3IKNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:40:17 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <523072BC.1010209@roeck-us.net>
Date: Wed, 11 Sep 2013 06:40:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH] sparc: fix MSI build failure on Sparc32
References: <522D1DAE.5010100@roeck-us.net> <1378895525-23772-1-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1378895525-23772-1-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 03:32 AM, Thomas Petazzoni wrote:
> Commit ebd97be635 ('PCI: remove ARCH_SUPPORTS_MSI kconfig option')
> removes the ARCH_SUPPORTS_MSI Kconfig option that allowed
> architectures to indicate whether they support PCI MSI or not. Now,
> PCI MSI support can be compiled in on any architecture thanks to the
> use of weak functions thanks to 4287d824f265 ('PCI: use weak functions
> for MSI arch-specific functions').
>
> So, architecture specific code is now responsible to ensure that its
> PCI MSI code builds in all cases, or be appropriately conditionally
> compiled.
>
> On Sparc, the MSI support is only provided for Sparc64, so the
> ARCH_SUPPORTS_MSI kconfig option was only selected for SPARC64, and
> not for the Sparc architecture as a whole. Therefore, removing
> ARCH_SUPPORTS_MSI broke Sparc32 configurations with CONFIG_PCI_MSI=y,
> because the Sparc-specific MSI code is not designed to be built on
> Sparc32.
>
> To solve this, this commit ensures that the Sparc MSI code is only
> built on Sparc64. This is done thanks to a new Kconfig Makefile helper
> option SPARC64_PCI_MSI, modeled after the existing SPARC64_PCI. The
> SPARC64_PCI_MSI option is an hidden option that is true when both
> Sparc64 PCI support is enabled and MSI is enabled. The
> arch/sparc/kernel/pci_msi.c file is now only built when
> SPARC64_PCI_MSI is true.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>

Yes, that fixes the build error.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

