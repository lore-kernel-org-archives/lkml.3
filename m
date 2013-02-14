Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935051Ab3BNWtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:49:20 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:32952 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab3BNWtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:49:16 -0500
MIME-Version: 1.0
In-Reply-To: <1360880818-4071454-7-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
	<1360880818-4071454-7-git-send-email-arnd@arndb.de>
Date: Thu, 14 Feb 2013 20:41:31 -0200
Message-ID: <CAOMZO5AbTC+82KKTqWXeseahsasx2q=q-4k9u14xyBYhgm2gdQ@mail.gmail.com>
Subject: Re: [PATCH 6/9] drm/pci: move drm_pcie_get_speed_cap_mask inside
 #ifdef CONFIG_PCI
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 8:26 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> commit dd66cc2e1  "drm/pci: Use PCI Express Capability accessors"
> introduced the use of the pcie_capability_read_dword function
> in the drm_pci code, which is only defined when PCI is enabled.
> While most of the file is already hidden away behind an #ifdef
> CONFIG_PCI, this function is not, and that now causes a link
> error in the ARM imx_v6_v7_defconfig configuration.
>
> Moving the function into the #ifdef section makes this work
> again on IMX, which does not have PCI support, and should
> have no impact on platforms that do.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Dave Airlie <airlied@redhat.com>

Bjorn has already sent a fix for this problem:
http://www.spinics.net/lists/arm-kernel/msg224425.html
