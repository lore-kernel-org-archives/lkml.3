Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765229Ab3DDWYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:24:14 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39975 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761463Ab3DDWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <1363217302-14383-5-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org> <1363217302-14383-5-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Apr 2013 16:23:50 -0600
Message-ID: <CAErSpo7S3cu_OB0Hz9XtH6UN+4JssvOO9D_kykzemQ30PB7L-w@mail.gmail.com>
Subject: Re: [PATCH v3 04/27] PCI: Add is_pci_*_resource_idx() helpers
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 5:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> According to resource pointer find out if the resource is some type resource
> like bridge, sriov, or std.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/pci.h |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 127a856..efb348b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -92,6 +92,29 @@ enum {
>         DEVICE_COUNT_RESOURCE = PCI_NUM_RESOURCES,
>  };
>
> +static inline bool is_pci_std_resource_idx(int i)
> +{
> +       return i >= PCI_STD_RESOURCES && i <= PCI_STD_RESOURCE_END;
> +}
> +
> +static inline bool is_pci_rom_resource_idx(int i)
> +{
> +       return i == PCI_ROM_RESOURCE;
> +}
> +
> +static inline bool is_pci_iov_resource_idx(int i)
> +{
> +#ifdef CONFIG_PCI_IOV
> +       return i >= PCI_IOV_RESOURCES && i <= PCI_IOV_RESOURCE_END;
> +#endif
> +       return false;
> +}
> +
> +static inline bool is_pci_bridge_resource_idx(int i)
> +{
> +       return i >= PCI_BRIDGE_RESOURCES && i <= PCI_BRIDGE_RESOURCE_END;
> +}
> +
>  typedef int __bitwise pci_power_t;
>
>  #define PCI_D0         ((pci_power_t __force) 0)

1) I don't like adding more "_idx()" interfaces.

2) The only one of these that's even used is "is_pci_bridge_resource_idx()"

3) I think adding a wrapper struct with a "type" or "flags" field
would make this trivial, e.g., "pres->flags & PCI_RESOURCE_WINDOW" or
something.
