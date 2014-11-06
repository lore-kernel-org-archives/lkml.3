Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaKFWkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:40:37 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:43554 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaKFWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:40:26 -0500
Message-ID: <545BF8C7.7070206@laposte.net>
Date: Thu, 06 Nov 2014 23:40:07 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "aaron.lu"@intel.com, tj@kernel.org, rjw@rjwysocki.net,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: new test
References: <545B7352.2040408@laposte.net> <27240C0AC20F114CBF8149A2696CBE4A01EB8625@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01EB8625@SHSMSX101.ccr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------060203060507060207030202"
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrheeggdejjecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtsehmtdgrrgdtfeejnecuhfhrohhmpeeurghrthhouceomhhishhtvghrrdhfrhgvvghmrghnsehlrghpohhsthgvrdhnvghtqe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060203060507060207030202
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello Liu Chuansheng,

I have good news, your patch based on /drivers/pci/quirks.c works very
well,

I have no problems after a standby mode, my JMB363/368 SATA/IDE JMicron
Pcie works without problems


Le 06/11/2014 15:33, Liu, Chuansheng a écrit :
> Thanks Barto. 
> 
> Could you try below patch? I made the change in file quirks.c.
>   
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> 
> index 90acb32..b40485f 100644
> 
> --- a/drivers/pci/quirks.c
> 
> +++ b/drivers/pci/quirks.c
> 
> @@ -29,6 +29,21 @@
> 
> #include "pci.h"
> 
>  /*
> 
> + * For JMicron chips, we need to disable the async_suspend method,
> otherwise
> 
> + * they will hit the power-on issue when doing device resume, add one quick
> 
> + * solution to disable the async_suspend method.
> 
> + */
> 
> +static void pci_async_suspend_fixup(struct pci_dev *pdev)
> 
> +{
> 
> +        /* 
> 
> +         * disabling the async_suspend method for JMicron chips to
> 
> +         * avoid device resuming issue.
> 
> +         */
> 
> +        device_disable_async_suspend(&pdev->dev);
> 
> +}
> 
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID,
> pci_async_suspend_fixup);
> 
> +
> 
> +/*
> 
>   * Decoding should be disabled for a PCI device during BAR sizing to avoid
> 
>   * conflict. But doing so may cause problems on host bridge and perhaps
> other
> 
>   * key system devices. For devices that need to have mmio decoding
> always-on,
> 
>  
> 
>  
> 

--------------060203060507060207030202
Content-Type: text/x-patch;
 name="jmicron2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jmicron2.patch"

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 90acb32..b40485f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -29,6 +29,21 @@
#include "pci.h"
 /*
+ * For JMicron chips, we need to disable the async_suspend method, otherwise
+ * they will hit the power-on issue when doing device resume, add one quick
+ * solution to disable the async_suspend method.
+ */
+static void pci_async_suspend_fixup(struct pci_dev *pdev)
+{
+        /*
+         * disabling the async_suspend method for JMicron chips to
+         * avoid device resuming issue.
+         */
+        device_disable_async_suspend(&pdev->dev);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, pci_async_suspend_fixup);
+
+/*
  * Decoding should be disabled for a PCI device during BAR sizing to avoid
  * conflict. But doing so may cause problems on host bridge and perhaps other
  * key system devices. For devices that need to have mmio decoding always-on,

--------------060203060507060207030202--
