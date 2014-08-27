Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbaH0T5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:57:33 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63402 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaH0T5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:57:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAGhpvoqrFQn7z942jUr2T8D1tuzS_irTqwmUynnqG55SVe3CqA@mail.gmail.com>
References: <CAGhpvoqrFQn7z942jUr2T8D1tuzS_irTqwmUynnqG55SVe3CqA@mail.gmail.com>
Date: Wed, 27 Aug 2014 22:57:29 +0300
Message-ID: <CAGhpvopiH4MWaRCDsZeOcfznW7qccQ3bM-bnMLm7fhJGdbnfkA@mail.gmail.com>
Subject: Re: [PATCH v3] i2c documentation: rename variable "register" to "reg"
From: =?UTF-8?B?Sm9zw6kgTWFudWVsIEFsYXJjw7NuIFJvbGTDoW4=?= 
	<jose.alarcon.roldan@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>, wsa@the-dreams.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-27 22:54 GMT+03:00 José Manuel Alarcón Roldán
<jose.alarcon.roldan@gmail.com>:
> The example code provided with the i2c device interface documentation
> won't compile since it uses the reserved word "register" to name a
> variable.
>
> The compiler fails with this error message:
>
>  error: expected identifier or '(' before '=' token
>    __u8 register = 0x20; /* Device register to access */
>                  ^
>
> Rename the variable "register" to simply "reg"
> in the example code.
>
> Signed-off-by: Jose Alarcon Roldan <jose.alarcon.roldan@gmail.com>
> ---
>  Documentation/i2c/dev-interface | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/i2c/dev-interface b/Documentation/i2c/dev-interface
> index 3e742ba..2ac78ae 100644
> --- a/Documentation/i2c/dev-interface
> +++ b/Documentation/i2c/dev-interface
> @@ -57,12 +57,12 @@ Well, you are all set up now. You can now use
> SMBus commands or plain
>  I2C to communicate with your device. SMBus commands are preferred if
>  the device supports them. Both are illustrated below.
>
> -  __u8 register = 0x10; /* Device register to access */
> +  __u8 reg = 0x10; /* Device register to access */
>    __s32 res;
>    char buf[10];
>
>    /* Using SMBus commands */
> -  res = i2c_smbus_read_word_data(file, register);
> +  res = i2c_smbus_read_word_data(file, reg);
>    if (res < 0) {
>      /* ERROR HANDLING: i2c transaction failed */
>    } else {
> @@ -70,11 +70,11 @@ the device supports them. Both are illustrated below.
>    }
>
>    /* Using I2C Write, equivalent of
> -     i2c_smbus_write_word_data(file, register, 0x6543) */
> -  buf[0] = register;
> +     i2c_smbus_write_word_data(file, reg, 0x6543) */
> +  buf[0] = reg;
>    buf[1] = 0x43;
>    buf[2] = 0x65;
> -  if (write(file, buf, 3) ! =3) {
> +  if (write(file, buf, 3) != 3) {
>      /* ERROR HANDLING: i2c transaction failed */
>    }
>
> --
> 1.9.1

Again something went wrong. Sorry about that :-(

--
Jose
