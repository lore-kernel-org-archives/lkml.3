Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaDVOLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:11:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaDVOLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:11:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Date: Tue, 22 Apr 2014 16:11:39 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com> <000a01cf592e$67e592e0$37b0b8a0$%han@samsung.com>
In-Reply-To: <000a01cf592e$67e592e0$37b0b8a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221611.40087.arnd@arndb.de>
X-Provags-ID: V02:K0:MjE2wVerGL09e6nODQW7QgCjR4YFUqkXtZ3w8+5Gs62
 gczI+VCTq5S1jW9HDSEijx2GkBJRlkkwZZELZMHfq/Z4s3Ob+M
 1DuWPAiaQzuco+UXsvXIRrXr8pY0nnYw2r9/MEIxWgvpXAvHkR
 gZDwnkOggfRoMSE9PnY2ydoI7pr5M99G53gvSsXBQAq3QmVUJt
 +7htPG+0YAV044rJ46yCClvdrLGHZgHKC304K8m43L/xxa7F1Z
 cX5OmCiggCGoVWxweoG//cxNfAGL7BY/9oBvwp7kuS2DYulRbF
 +tqAJjjBq7sY1cp6qEu5EADk1LIULs03PeQ9c56FgpnxOrWNL/
 2riwHpw4TMafVNu/hT4U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2014, Jingoo Han wrote:
> Samsung GH7 has four PCIe controllers which can be used as root
> complex for PCIe interface.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/pci/host/Kconfig      |    2 +-
>  drivers/pci/host/pci-exynos.c |  135 ++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 126 insertions(+), 11 deletions(-)

Can you explain how much the GH7 and Exynos front-ends actually have in
common? Would it make sense to have a separate driver for gh7?

Also, if gh7 is expected to run a full firmware, I think you should
do all the setup in the firmware before booting Linux, and just
do the required run-time operations in the driver itself.

	Arnd
