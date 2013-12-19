Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab3LSQin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:38:43 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:63623 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3LSQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:38:39 -0500
MIME-Version: 1.0
In-Reply-To: <1387433380-18564-2-git-send-email-yinghai@kernel.org>
References: <1387433380-18564-1-git-send-email-yinghai@kernel.org>
	<1387433380-18564-2-git-send-email-yinghai@kernel.org>
Date: Thu, 19 Dec 2013 08:38:39 -0800
X-Google-Sender-Auth: sQlF4ekxHLTAcDdQNDlzjsB2c_g
Message-ID: <CAE9FiQXUAdVQf6SZ_n2Hcq5QK+dAU+ufPEORzdpQyrEOVyD-9Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 10:09 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On system with more pcie cards, we do not have enough range under 4G
> to allocate those pci devices.
>
> On 64bit system, we could try to allocate mem64 above 4G at first,
> and fall back to below 4g if it can not find any above 4g.
>
> x86 32bit without X86_PAE support will have bottom set to 0, because
> resource_size_t is 32bit.
> For 32bit kernel that resource_size_t is 64bit when pae is support.
> we are safe because iomem_resource is limited to 32bit according to
> x86_phys_bits.
>
> -v2: update bottom assigning to make it clear for non-pae support machine.
> -v3: Bjorn's change:
>         use MAX_RESOURCE instead of -1
>         use start/end instead of bottom/max
>         for all arch instead of just x86_64
> -v4: updated after PCI_MAX_RESOURCE_32 change.
> -v5: restore io handling to use PCI_MAX_RESOURCE_32 as limit.
> -v6: checking pcibios_resource_to_bus return for every bus res, to decide it
>         if we need to try high at first.
>      It supports all arches instead of just x86_64.
> -v7: split 4G limit change out to another patch according to Bjorn.
>      also use pci_clip_resource instead.
> -v8: refresh after changes in pci/resource.

looks still have other problem, will send out updated version later.
