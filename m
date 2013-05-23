Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3EWIFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:05:40 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35248 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3EWIFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:05:35 -0400
MIME-Version: 1.0
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B49E400663F@SAFEX1MAIL4.st.com>
References: <1368796239-2049-1-git-send-email-mathias.leblanc@st.com>
	<CAHp75Vf6iCZxe4tydVTJ3nMdFx7nMuSgnk0KSzps4ULxDoJV8Q@mail.gmail.com>
	<35286B1AE75A7C47BFF0870081A31B4B49E400663F@SAFEX1MAIL4.st.com>
Date: Thu, 23 May 2013 11:05:33 +0300
Message-ID: <CAHp75VetFvYfejvSkPTMAc78_w0ThHnQsSRpsbm3kRsVv=R4Tg@mail.gmail.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mathias LEBLANC <Mathias.LEBLANC@st.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:43 AM, Mathias LEBLANC
<Mathias.LEBLANC@st.com> wrote:

> Thanks for your support, I will fix these code style problem.

I left below the comments I think should be addressed besides style.
Please, comment what you think about them.

> However in a first time, can we publish this SPI driver?

It's up to SPI subsystem maintainer, though I couldn't consider the
quality of the driver is enough to include to upstream. You may try to
ask Greg to go to staging if you have real demand of this.

> I think that it will be preferable to submit it and apply some patch if it's only coding style error.

I don't support the way of submitting patch on top of submiting
something that must be just fixed.

> I have fix errors in this patch that has been discovered in the I2C patch, so I don't know what's stop this submission.
> I think that's driver is more criticized than the I2C driver although it's the same base.

I hope you understand it's not an exuce.

> I know that's important to have good code in the kernel source and I'm agree about that,

Good.

> I propose it be published as a first release and I fix coding style problem in a second time.

See above.

>> +++ b/drivers/char/tpm/tpm_spi_stm_st33.c

>> +enum stm33zp24_int_flags {
>> +       TPM_GLOBAL_INT_ENABLE = 0x80,
>> +       TPM_INTF_CMD_READY_INT = 0x080,
>
> What the difference? It looks like first constant is not belong to this enum.
>
>> +static int spi_write8_reg(struct tpm_chip *tpm, u8 tpm_register,
>> +                     u8 *tpm_data, u16 tpm_size) {
>> +       u8 data = 0;
>> +       int total_length = 0, nbr_dummy_bytes;
>> +       int value = 0;
>> +       struct spi_device *dev =
>> +                (struct spi_device __force *)tpm->vendor.iobase;
>> +       struct st33zp24_platform_data *platform_data = dev->dev.platform_data;
>> +       u8 *data_buffer = platform_data->tpm_spi_buffer[0];
>
> It seems a bad idea to have buffers in platform_data. I bet the buffers should be part of other struct. What did I miss?
>
>> +       struct spi_transfer xfer = {
>> +               .tx_buf  = data_buffer,
>> +               .rx_buf  = platform_data->tpm_spi_buffer[1],
>> +       };
>
> ... even this entire structure.
> Can you consider to use spi_message API ?

>> +static unsigned long wait_for_serirq_timeout(struct tpm_chip *chip,
>> +        bool condition, unsigned long timeout) {
>> +       long status = 0;
>> +       struct spi_device *client;
>> +       struct st33zp24_platform_data *pin_infos;
>> +
>> +       client = (struct spi_device __force *)chip->vendor.iobase;
>
> Is there any better storage for this pointer? It seems an abuse of iobase member.

>> +       chip->vendor.iobase = (void __iomem *)dev;
>
> Don't like this one. Try to find better way to drag pointer.


--
With Best Regards,
Andy Shevchenko
