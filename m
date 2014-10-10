Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJJSWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:22:16 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62362 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaJJSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:22:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com
Subject: Re: [PATCH] ARM: keystone: add bus notifier to set dma_pfn_offset for pci devices
Date: Fri, 10 Oct 2014 20:22:07 +0200
Message-ID: <7733803.LRHUrkheId@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com>
References: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S1QapBI8TXmNiprvjJHA3vgGAL05Vu3VnVVvv7uPGzS
 dN9IeSOq8MCjbc6kpjtt6Y+Q8MPmDP9KqexNCr5bQhE05Ep8dJ
 WegNX1t0EJaTLIpLe90IdGMWTI3+LS+SYRvE+poa4YgCs69mWr
 sWKE2e74X5vM1GgbkHrAQjuhOLNIJnHYWKxuWU21Q99LRX0Dbq
 uk0ZUMp4wfwdV/y5L4nVvF6nO6IxzIxGLwghngejtHFVQDhhBW
 THVu01fMB4gCQo6IDgnsefo4WG/BVFsoIhmFUAk0c6rp4UyxTs
 4N9DBlDR1aASMj0juMLIoLyrakyeWrNCjL23reSDCX8GFE1Vgy
 O86BCYK9TORslbnvSbAI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2014 11:15:37 Murali Karicheri wrote:
> @@ -54,6 +55,8 @@ static void __init keystone_init(void)
>         keystone_pm_runtime_init();
>         if (platform_nb.notifier_call)
>                 bus_register_notifier(&platform_bus_type, &platform_nb);
> +       if (platform_nb.notifier_call)
> +               bus_register_notifier(&pci_bus_type, &platform_nb);
>         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> 

No, this looks very wrong. Santosh spent an enormous effort on obsoleting
the platform notifier block by adding the range parser to the platform
device probe path.

You should really remove platform_nb and all associated code rather than
adding more code to it.

NAK

	Arnd
