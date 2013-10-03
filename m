Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3JCAMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:12:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51863 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab3JCAMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:12:50 -0400
Date: Wed, 02 Oct 2013 20:12:48 -0400 (EDT)
Message-Id: <20131002.201248.1498671947603340308.davem@davemloft.net>
To: linux@roeck-us.net
Cc: thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, gregory.clement@free-electrons.com,
        alior@marvell.com, ezequiel.garcia@free-electrons.com
Subject: Re: [PATCH] sparc: fix MSI build failure on Sparc32
From: David Miller <davem@davemloft.net>
In-Reply-To: <523072BC.1010209@roeck-us.net>
References: <522D1DAE.5010100@roeck-us.net>
	<1378895525-23772-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<523072BC.1010209@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 17:12:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Wed, 11 Sep 2013 06:40:12 -0700

> On 09/11/2013 03:32 AM, Thomas Petazzoni wrote:
>> Commit ebd97be635 ('PCI: remove ARCH_SUPPORTS_MSI kconfig option')
>> removes the ARCH_SUPPORTS_MSI Kconfig option that allowed
>> architectures to indicate whether they support PCI MSI or not. Now,
>> PCI MSI support can be compiled in on any architecture thanks to the
>> use of weak functions thanks to 4287d824f265 ('PCI: use weak functions
>> for MSI arch-specific functions').
>>
>> So, architecture specific code is now responsible to ensure that its
>> PCI MSI code builds in all cases, or be appropriately conditionally
>> compiled.
>>
>> On Sparc, the MSI support is only provided for Sparc64, so the
>> ARCH_SUPPORTS_MSI kconfig option was only selected for SPARC64, and
>> not for the Sparc architecture as a whole. Therefore, removing
>> ARCH_SUPPORTS_MSI broke Sparc32 configurations with CONFIG_PCI_MSI=y,
>> because the Sparc-specific MSI code is not designed to be built on
>> Sparc32.
>>
>> To solve this, this commit ensures that the Sparc MSI code is only
>> built on Sparc64. This is done thanks to a new Kconfig Makefile helper
>> option SPARC64_PCI_MSI, modeled after the existing SPARC64_PCI. The
>> SPARC64_PCI_MSI option is an hidden option that is true when both
>> Sparc64 PCI support is enabled and MSI is enabled. The
>> arch/sparc/kernel/pci_msi.c file is now only built when
>> SPARC64_PCI_MSI is true.
>>
>> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> Reported-by: Guenter Roeck <linux@roeck-us.net>
> 
> Yes, that fixes the build error.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Applied, sorry for taking so long.
