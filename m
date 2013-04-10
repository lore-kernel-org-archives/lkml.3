Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937021Ab3DJVdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:33:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59174 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936673Ab3DJVds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:33:48 -0400
Date: Wed, 10 Apr 2013 23:33:30 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: rob.herring@calxeda.com, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, thierry.reding@avionic-design.de,
        Liviu.Dudau@arm.com, grant.likely@secretlab.ca, paulus@samba.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        jg1.han@samsung.com, jgunthorpe@obsidianresearch.com,
        thomas.abraham@linaro.org, benh@kernel.crashing.org, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        monstr@monstr.eu, linux-kernel@vger.kernel.org,
        suren.reddy@samsung.com
Subject: Re: [PATCH v5 1/3] of/pci: Unify pci_process_bridge_OF_ranges from
 Microblaze and PowerPC
Message-ID: <20130410233330.4e9479b0@skate>
In-Reply-To: <1365578969-30966-2-git-send-email-Andrew.Murray@arm.com>
References: <1365578969-30966-1-git-send-email-Andrew.Murray@arm.com>
	<1365578969-30966-2-git-send-email-Andrew.Murray@arm.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Murray,

On Wed, 10 Apr 2013 08:29:26 +0100, Andrew Murray wrote:

> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> index bb115de..6852481 100644
> --- a/include/linux/of_pci.h
> +++ b/include/linux/of_pci.h
> @@ -11,4 +11,7 @@ struct device_node;
>  struct device_node *of_pci_find_child_device(struct device_node *parent,
>  					     unsigned int devfn);
>  
> +void pci_process_bridge_OF_ranges(struct pci_controller *hose,
> +			struct device_node *dev, int primary);
> +
>  #endif

In this file, 'struct pci_controller' is not defined anywhere, and not
in any header file that is included. So I get a warning at compile time
when <linux/of_pci.h> is included, but nothing has defined 'struct
pci_controller' beforehand. So I think this file should carry a change
like:

+struct pci_controller;

In my version of the patch I added it, see:

diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index bb115de..e56182f 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -4,6 +4,7 @@
 #include <linux/pci.h>
 
 struct pci_dev;
+struct pci_controller;
 struct of_irq;
 int of_irq_map_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
 
@@ -11,4 +12,7 @@ struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
 
+void pci_process_bridge_OF_ranges(struct pci_controller *hose,
+			struct device_node *dev, int primary);
+
 #endif

But otherwise, for PATCH 1/3 and 2/3,

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
