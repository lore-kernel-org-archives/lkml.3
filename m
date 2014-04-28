Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaD1KTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:19:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:46774 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaD1KTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:19:49 -0400
Message-ID: <535E2B33.9030308@mev.co.uk>
Date: Mon, 28 Apr 2014 11:19:31 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] staging: comedi: addi_apci_1564: simplify the PCI
 bar reading and don't read the unused bars
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com> <1398562636-5900-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398562636-5900-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-27 02:37, Chase Southwood wrote:
> This driver only uses PCI bar 1 (devpriv->i_IobaseAmcc), and PCI bar 2
> (dev->iobase) doon't bother reading the unused PCI bars.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>
> Hartley,
>
> As far as I can tell from reading the I/O Mapping you sent me, these bar
> numbers are correct, but it seems a bit odd, so please offer correction
> if I am interpreting the document incorrectly.
>
> Thanks,
> Chase
>
>   drivers/staging/comedi/drivers/addi_apci_1564.c | 11 ++---------
>   1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
> index fe42f9d..7e42d47 100644
> --- a/drivers/staging/comedi/drivers/addi_apci_1564.c
> +++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
> @@ -65,15 +65,8 @@ static int apci1564_auto_attach(struct comedi_device *dev,
>   	if (ret)
>   		return ret;
>
> -	if (this_board->i_IorangeBase1)
> -		dev->iobase = pci_resource_start(pcidev, 1);
> -	else
> -		dev->iobase = pci_resource_start(pcidev, 0);
> -
> -	devpriv->iobase = dev->iobase;
> -	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);
> -	devpriv->i_IobaseAddon = pci_resource_start(pcidev, 2);
> -	devpriv->i_IobaseReserved = pci_resource_start(pcidev, 3);
> +	dev->iobase = pci_resource_start(pcidev, 2);
> +	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 1);

I'm sure the original resources are correct, so since 
this_board->i_IorangeBase1 is non-zero:

	dev->iobase = pci_resource_start(pcidev, 1);
	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);

I suspect the member name 'i_IobaseAmcc' is just a hangover from the 
distant past and could just be changed to 'iobasemain' or something, 
since most of the code seems to use it.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
