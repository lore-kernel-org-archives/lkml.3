Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaCNRGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:06:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:49377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaCNRGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:06:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v7 2/6] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Fri, 14 Mar 2014 18:05:28 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <1394811272-1547-3-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1394811272-1547-3-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403141805.29204.arnd@arndb.de>
X-Provags-ID: V02:K0:HiKbEie1gE2aKer03NKY3t+KDJvluYjZ0m9zQ88ILKI
 RwXntRV3izRmSDFs7NCtPKKwgYuf2xPIMmmrsB8Z5iW2M0bgAn
 hyB0F4kzd08EWX9jYqjGFkkGqP9ZLwWmFkpHhsYNKOa2m+YLo3
 QmQvLvvX2n8U3Yja04x47Yqaim1gsEDrT3fs8al9qWcx9y4hNK
 gyZxPMLJ9YcSYHwmByzva86Atga+hJce15IetYeKzfHMf+2n81
 jDNTY2UgaKiWSRQiSLm8QiQ1jtpxk9Fxrk7wlciLlrNnKmOcrY
 f1J7K0vu1mu2Qxw6z5wu+vASs35qcp4nRUA086ussG70U4sMJj
 bV13a9uC3j3pizx0uiwKSBW3ldyT2bUf8zy1Lozl3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2014, Liviu Dudau wrote:
> +int of_pci_range_to_resource(struct of_pci_range *range,
> +       struct device_node *np, struct resource *res)
> +{
> +       res->flags = range->flags;
> +       if (res->flags & IORESOURCE_IO) {
> +               unsigned long port = -1;
> +               int err = pci_register_io_range(range->cpu_addr, range->size);
> +               if (err)
> +                       return err;
> +               port = pci_address_to_pio(range->cpu_addr);
> +               if (port == (unsigned long)-1) {
> +                       res->start = (resource_size_t)OF_BAD_ADDR;
> +                       res->end = (resource_size_t)OF_BAD_ADDR;
> +                       return -EINVAL;
> +               }

The error handling is inconsistent here: in one case you set the resource
to OF_BAD_ADDR, in the other one you don't.

	Arnd
