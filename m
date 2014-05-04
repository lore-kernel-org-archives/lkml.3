Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaEDK3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 06:29:16 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:32941 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbaEDK3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 06:29:14 -0400
Message-ID: <53661390.708@mev.co.uk>
Date: Sun, 4 May 2014 11:16:48 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>, <devel@driverdev.osuosl.org>
CC: <hsweeten@visionengravers.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: ii_pci20kc: fix usage of uninit scalar
 in ii20k_attach()
References: <20140504022609.7b1ba9c1@spike>
In-Reply-To: <20140504022609.7b1ba9c1@spike>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/14 01:26, Christian Engelmayer wrote:
> This driver supports the PCI-20001C-1a and PCI-20001C-2a carrier boards.
> The -2a version has 32 on-board DIO channels. In case this variant is
> detected, local variable 'has_dio' is set accordingly. Otherwise it is
> left uninitialized and the following subdevice instantiation depends on
> the stack. Detected by Coverity - CID 1077830.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>   drivers/staging/comedi/drivers/ii_pci20kc.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
> index 3558ab3..2516ce8 100644
> --- a/drivers/staging/comedi/drivers/ii_pci20kc.c
> +++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
> @@ -461,6 +461,7 @@ static int ii20k_attach(struct comedi_device *dev,
>   	id = readb(devpriv->ioaddr + II20K_ID_REG);
>   	switch (id & II20K_ID_MASK) {
>   	case II20K_ID_PCI20001C_1A:
> +		has_dio = false;
>   		break;
>   	case II20K_ID_PCI20001C_2A:
>   		has_dio = true;
>

Thanks¬

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
