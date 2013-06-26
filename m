Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3FZRPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:15:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:21153 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3FZRPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:15:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,945,1363158000"; 
   d="scan'208";a="356152079"
Message-ID: <1372266904.8177.83.camel@envy.home>
Subject: Re: [PATCH 7/8] pci: Add CircuitCo VENDOR ID and MinnowBoard DEVICE
 ID
From: Darren Hart <dvhart@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, linux-pci@vger.kernel.org
Date: Wed, 26 Jun 2013 10:15:04 -0700
In-Reply-To: <20130626163250.GA29299@google.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <83879b07cd4ce95f086420d1faa926c1692d63b4.1372211451.git.dvhart@linux.intel.com>
	 <20130626163250.GA29299@google.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 10:32 -0600, Bjorn Helgaas wrote:
> On Tue, Jun 25, 2013 at 06:53:27PM -0700, Darren Hart wrote:
> > Add CircuitCo's newly created VENDOR ID and their first board subsystem
> > ID for the MinnowBoard.
> > 
> > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: David Anders <danders@circuitco.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: linux-pci@vger.kernel.org
> > ---
> >  include/linux/pci_ids.h | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index c129162..b2879ce 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -149,6 +149,9 @@
> >  #define PCI_DEVICE_ID_BERKOM_A4T		0xffa4
> >  #define PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO	0xffa8
> >  
> > +#define PCI_VENDOR_ID_CIRCUITCO			0x1cc8
> > +#define PCI_DEVICE_ID_CIRCUITCO_MINNOWBOARD	0x0001
> > +
> >  #define PCI_VENDOR_ID_COMPAQ		0x0e11
> >  #define PCI_DEVICE_ID_COMPAQ_TOKENRING	0x0508
> >  #define PCI_DEVICE_ID_COMPAQ_TACHYON	0xa0fc
> > -- 
> > 1.8.1.2
> > 
> 
> Per conversation at [1], I merged the patch below to my pci/misc branch
> for v3.11:
> 
> [1] https://lkml.kernel.org/r/6c27e79870ec93f7a8c6692d4bcfebaee589fa6b.1372211451.git.dvhart@linux.intel.com

> 
> commit 9f4de80a09667538e1162fdecff96ccb5bb354a8
> Author: Darren Hart <dvhart@linux.intel.com>
> Date:   Tue Jun 25 20:08:46 2013 -0600
> 
>     PCI: Add CircuitCo vendor ID
>     
>     Add CircuitCo's newly created VENDOR ID
>     
>     [bhelgaas: sort, drop device ID (only used once)]
>     Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index c129162..8b1aa7f 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2476,6 +2476,8 @@
>  
>  #define PCI_VENDOR_ID_ASMEDIA		0x1b21
>  
> +#define PCI_VENDOR_ID_CIRCUITCO		0x1cc8
> +
>  #define PCI_VENDOR_ID_TEKRAM		0x1de1
>  #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29


Thanks Bjorn. When I reuse this Subsystem ID and there is more than one
usage, I should send a patch to pci_ids.h adding it and replace the hex
value in all drivers with the new define. Is that right?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

