Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387Ab3GLURZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:17:25 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63559 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283Ab3GLURV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL=oSkWTGEbYLxAU1PwGbgoyeiOgFV31Gd4yj1JkDECBg@mail.gmail.com>
References: <1373659660-31123-1-git-send-email-keescook@chromium.org>
	<CAGXu5jL=oSkWTGEbYLxAU1PwGbgoyeiOgFV31Gd4yj1JkDECBg@mail.gmail.com>
Date: Fri, 12 Jul 2013 13:17:21 -0700
X-Google-Sender-Auth: cnt07uvQ-92lV5NhYbGKGz4msUs
Message-ID: <CAGXu5jK8fb-wJGbQdM=2iPR=qwY30U--yATjgdwDtfJOhFK8dw@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86, boot: add mmio serial during compressed boot
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-serial@vger.kernel.org, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend, gmail tricked me into HTML mode...]

On Fri, Jul 12, 2013 at 1:15 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jul 12, 2013 at 1:07 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> Allows "console=uart[8250],mmio[32],0xADDR[,BAUDn8[,BASE_BAUD]]" to
>> be recognized during compressed boot early console setup, and during
>> boot console setup. Replaces defines with common serial defines. Adds
>> suport for mmio-based serial devices to compressed-boot early console,
>> and plumbs support for defining the base baud rate for UART clock
>> calculations (since mmio serial cards may not have the standard rate,
>> resulting in incorrect baud rates for mmio devices).
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> diff --git a/include/uapi/linux/serial_reg.h
>> b/include/uapi/linux/serial_reg.h
>> index e632260..bdeaf5a 100644
>> --- a/include/uapi/linux/serial_reg.h
>> +++ b/include/uapi/linux/serial_reg.h
>> @@ -333,12 +333,13 @@
>>
>>  #define UART_RSA_TCR_SWITCH (1 << 0) /* Timer on */
>>
>> +#define SERIAL_BAUD_BASE (1843200/16)
>>  /*
>>   * The RSA DSV/II board has two fixed clock frequencies.  One is the
>>   * standard rate, and the other is 8 times faster.
>>   */
>> -#define SERIAL_RSA_BAUD_BASE (921600)
>> -#define SERIAL_RSA_BAUD_BASE_LO (SERIAL_RSA_BAUD_BASE / 8)
>> +#define SERIAL_RSA_BAUD_BASE_LO SERIAL_BAUD_BASE
>> +#define SERIAL_RSA_BAUD_BASE (SERIAL_RSA_BAUD_BASE * 8)
>
>
> Argh, just found this typo during an allyesconfig build. Above should be:
>
> #define SERIAL_RSA_BAUD_BASE (SERIAL_BAUD_BASE * 8)
>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security



--
Kees Cook
Chrome OS Security
