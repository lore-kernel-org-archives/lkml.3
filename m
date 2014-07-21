Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaGUX1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:27:36 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42448 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaGUX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:27:34 -0400
Date: Tue, 22 Jul 2014 09:27:32 +1000
From: Gavin Shan <gwshan@linux.vnet.ibm.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI/AER: Forward declare struct pci_dev to avoid warning
Message-ID: <20140721232732.GA4736@shangw>
Reply-To: Gavin Shan <gwshan@linux.vnet.ibm.com>
References: <1405960243-589-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405960243-589-1-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072123-9264-0000-0000-0000069FDB28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 07:30:43PM +0300, Tuomas Tynkkynen wrote:

I guess it's same issue and fix as:

http://patchwork.ozlabs.org/patch/370629/

Thanks,
Gavin

>Forward declaring struct pci_dev in aer.h avoids this warning:
>
>In file included from include/ras/ras_event.h:11:0,
>                 from drivers/ras/ras.c:13:
>include/linux/aer.h:38:44: warning: 'struct pci_dev’ declared inside parameter list [enabled by default]
>include/linux/aer.h:38:44: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>
>Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>---
> include/linux/aer.h | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/include/linux/aer.h b/include/linux/aer.h
>index 4dbaa70..d9ec8dd 100644
>--- a/include/linux/aer.h
>+++ b/include/linux/aer.h
>@@ -7,6 +7,8 @@
> #ifndef _AER_H_
> #define _AER_H_
>
>+struct pci_dev;
>+
> #define AER_NONFATAL			0
> #define AER_FATAL			1
> #define AER_CORRECTABLE			2
>-- 
>1.8.1.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

