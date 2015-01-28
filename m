Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbbA2Bog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:44:36 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46244 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbbA2Boa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:30 -0500
MIME-Version: 1.0
In-Reply-To: <1422481377-31112-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1422481377-31112-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 28 Jan 2015 22:44:15 +0100
Message-ID: <CAKXHbyMoH-EQFwOhaMRixdcEkzsxCDqFW95jcyRabb3WeoOqcA@mail.gmail.com>
Subject: Re: [PATCH] staging: comedi: drivers: addi-data: hwdrv_apci1500:
 Change variables that is never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@gmail.com>,
        Conrad Meyer <cemeyer@uw.edu>, Fred Akers <knivey@botops.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-28 22:42 GMT+01:00 Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se>:
> Variable ar assigned a value that is never used.
> Instead use the struct variable of the same name.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
> index bfa9228..faa71a9 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
> @@ -467,8 +467,6 @@ static int apci1500_di_write(struct comedi_device *dev,
>                              unsigned int *data)
>  {
>         struct apci1500_private *devpriv = dev->private;
> -       int i_Event1InterruptStatus = 0, i_Event2InterruptStatus =
> -               0, i_RegValue;
>
>         switch (data[0]) {
>         case START:
> @@ -499,11 +497,9 @@ static int apci1500_di_write(struct comedi_device *dev,
>                                         outb(0xF4,
>                                                 devpriv->iobase +
>                                                 APCI1500_Z8536_CONTROL_REGISTER);
> -                                       i_Event1InterruptStatus = 1;
>                                         outb(APCI1500_RW_PORT_A_SPECIFICATION,
>                                                 devpriv->iobase +
>                                                 APCI1500_Z8536_CONTROL_REGISTER);
> -                                       i_RegValue =
>                                                 inb(devpriv->iobase +
>                                                 APCI1500_Z8536_CONTROL_REGISTER);
>
> @@ -549,7 +545,6 @@ static int apci1500_di_write(struct comedi_device *dev,
>                                         outb(0xD0,
>                                                 devpriv->iobase +
>                                                 APCI1500_Z8536_CONTROL_REGISTER);
> -                                       i_Event2InterruptStatus = 1;
>                                 } else {
>                                         dev_warn(dev->class_dev,
>                                                 "Event 2 not initialised\n");
> @@ -592,7 +587,6 @@ static int apci1500_di_write(struct comedi_device *dev,
>                                         outb(0xF4,
>                                                 devpriv->iobase +
>                                                 APCI1500_Z8536_CONTROL_REGISTER);
> -                                       i_Event1InterruptStatus = 0;
>                                 } else {
>                                         dev_warn(dev->class_dev,
>                                                 "Event 1 not initialised\n");
> @@ -621,7 +615,6 @@ static int apci1500_di_write(struct comedi_device *dev,
>                                         outb(0xF4,
>                                                 devpriv->iobase +
>                                                 APCI1500_Z8536_CONTROL_REGISTER);
> -                                       i_Event2InterruptStatus = 0;
>                                 } else {
>
>                                         dev_warn(dev->class_dev,
> @@ -1896,7 +1889,6 @@ static int apci1500_do_bits(struct comedi_device *dev,
>                             unsigned int *data)
>  {
>         struct apci1500_private *devpriv = dev->private;
> -       unsigned int ui_Status;
>         int i_RegValue;
>         int i_Constant;
>
> @@ -2004,8 +1996,8 @@ static int apci1500_do_bits(struct comedi_device *dev,
>
>         /* Enables the PCI interrupt */
>         outl(0x3000, devpriv->i_IobaseAmcc + 0x38);
> -       ui_Status = inl(devpriv->i_IobaseAmcc + 0x10);
> -       ui_Status = inl(devpriv->i_IobaseAmcc + 0x38);
> +       inl(devpriv->i_IobaseAmcc + 0x10);
> +       inl(devpriv->i_IobaseAmcc + 0x38);
>         outl(0x23000, devpriv->i_IobaseAmcc + 0x38);
>
>         return insn->n;
> --
> 1.7.10.4
>



Hi

Sorry,  ignore this!

Wrong commit message, sending a new patch.

Kind regards
Rickard Strandqvist
