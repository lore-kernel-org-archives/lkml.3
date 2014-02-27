Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaB0NVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:21:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:50510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaB0NU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:20:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Thu, 27 Feb 2014 14:20:54 +0100
Message-ID: <14735193.MhDlU8yNYG@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+w8HmbNxvnI093NMRcxIkV4GECZnylmiwTaIVu473MM
 XFLZSXu6Wt7trqkcVPtAH3dVigKTI0RLEVB/qpHJOyOqof2g3j
 6gsfJ9pxs5B+Zivjqf8b7/Tvnk//Ul6xi/lJit9Ownpo/IPidf
 qwbWyToR0Fyju7n4PyEdOGHox301p+czOKIX8CXlBeGLqs7XVE
 g8/zFGpo9iJmoK8OLycC5odtOdlFpGQosvrOd7UQjaLfraT7i1
 ab+CvQolVwR7h/GZ3n2otITWTi/QaN7HaugVx/DgGn64onEGKJ
 Uq7GKhRkF4zguGfBxILsFuarC70pcgDv+MxoS+8YkldrhTDOEd
 cU/egpL/BQVsW5FVrFJo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 13:06:39 Liviu Dudau wrote:
> +       res->flags = range->flags;
> +       if (res->flags & IORESOURCE_IO) {
> +               unsigned long port;
> +               port = pci_address_to_pio(range->pci_addr);
> +               if (port == (unsigned long)-1) {
> +                       res->start = (resource_size_t)OF_BAD_ADDR;
> +                       res->end = (resource_size_t)OF_BAD_ADDR;
> +                       return;
> +               }
> 

I think this conflicts with the way that pci_address_to_pio() is
defined on powerpc, where it expects a CPU address as the input,
not a PCI i/o address.

	Arnd
