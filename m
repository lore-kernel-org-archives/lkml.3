Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaJCMrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:47:16 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:47197 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbaJCMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:47:11 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 08:47:11 EDT
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <542E8AF2.4030708@mev.co.uk>
Date: Fri, 03 Oct 2014 12:39:30 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, luca.ellero@brickedbrain.com,
        lisovy@gmail.com
CC: devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC
 depend on HAS_IOMEM
References: <542D640E.6010200@gmail.com>
In-Reply-To: <542D640E.6010200@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 15:41, Chen Gang wrote:
> COMEDI_II_PCI20KC needs HAS_IOMEM, so depend on it. The related error (
> with allmodconfig under um):
>
>      CC [M]  drivers/staging/comedi/drivers/ii_pci20kc.o
>    drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_attach’:
>    drivers/staging/comedi/drivers/ii_pci20kc.c:442:2: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]
>      dev->mmio = ioremap(membase, II20K_SIZE);
>      ^
>    drivers/staging/comedi/drivers/ii_pci20kc.c:442:12: warning: assignment makes pointer from integer without a cast [enabled by default]
>      dev->mmio = ioremap(membase, II20K_SIZE);
>                ^
>    drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_detach’:
>    drivers/staging/comedi/drivers/ii_pci20kc.c:512:3: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
>       iounmap(dev->mmio);
>       ^
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
