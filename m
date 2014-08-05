Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaHEWfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:35:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43283 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaHEWfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <1406344128-27055-4-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
	<1406344128-27055-4-git-send-email-wangyijing@huawei.com>
Date: Tue, 5 Aug 2014 17:35:04 -0500
Message-ID: <CALRxmdB0Ltt3_G=D4i7x47pHCtCKo8RHgn-hgN+u=px22dimOA@mail.gmail.com>
Subject: Re: [RFC PATCH 03/11] PCI/MSI: Refactor pci_dev_msi_enabled()
From: Stuart Yoder <b08248@gmail.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: linux-kernel@vger.kernel.org, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Paul.Mundt@huawei.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arch@vger.kernel.org,
        arnab.basu@freescale.com, virtualization@lists.linux-foundation.org,
        Hanjun Guo <guohanjun@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:08 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> Pci_dev_msi_enabled() is used to check whether device
> MSI/MSIX enabled. Refactor this function  to suuport
> checking only device MSI or MSIX enabled.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

So this patch refactors things so that checks like this:
   > -       if (!dev->msi_enabled)

are moved into a function:
   > +       if (!pci_dev_msi_enabled(dev, MSI_TYPE))

Can you explain a bit more why this  needed.   Is it just cleanup?

Thanks,
Stuart
