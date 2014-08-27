Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957AbaH0Tfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:35:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbaH0Tfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:35:47 -0400
Message-ID: <53FE330F.8070601@infradead.org>
Date: Wed, 27 Aug 2014 12:35:43 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jos=E9_Manuel_Alarc=F3n_Rold=E1n?= 
	<jose.alarcon.roldan@gmail.com>
CC: wsa@the-dreams.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c documentation: rename variable "register" to "reg"
References: <CAGhpvooRXZTsWL58hFReD0b+2Wf-iRmW_b-uV+aihpRNVWj1WA@mail.gmail.com>
In-Reply-To: <CAGhpvooRXZTsWL58hFReD0b+2Wf-iRmW_b-uV+aihpRNVWj1WA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/14 11:12, José Manuel Alarcón Roldán wrote:
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
> Another couple of typos has been fixed as well.
> 
> 
> Signed-off-by: Jose Alarcon Roldan <jose.alarcon.roldan@gmail.com>
> ---
>  Documentation/i2c/dev-interface | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/i2c/dev-interface b/Documentation/i2c/dev-interface
> index 3e742ba..744ce70 100644
> --- a/Documentation/i2c/dev-interface
> +++ b/Documentation/i2c/dev-interface
> @@ -57,12 +57,12 @@ Well, you are all set up now. You can now use
> SMBus commands or plain

The 2 lines above should have been on one line.  Looks like your mail client is
splitting lines where they shouldn't be split.  Some clients have config
options for that...   (I fixed it in your patch.)
Please see if Documentation/email-clients.txt can help you any.

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

The line above should end with a space character as in the current source file
that is being patched.  Maybe your email client stripped it.  Please fix your
email client for future patches.

> -     i2c_smbus_write_word_data(file, register, 0x6543) */
> -  buf[0] = register;
> +  i2c_smbus_write_word_data(file, reg, 0x6543) */

The line above should be indented more since it is a continuation
of the comment above it.  I fixed that.

> +  buf[0] = reg;
>    buf[1] = 0x43;
>    buf[2] = 0x65;
> -  if (write(file, buf, 3) ! =3) {
> +  if (write(file, buf, 3) != 3) {
>      /* ERROR HANDLING: i2c transaction failed */
>    }
> 

Patch applied.  Or would you like to see if you can send the patch
with all of these minor annoying problems fixed?

Thanks.

-- 
~Randy
