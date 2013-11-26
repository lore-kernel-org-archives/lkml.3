Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3KZMy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:54:28 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:46890 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3KZMyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:54:24 -0500
MIME-Version: 1.0
Reply-To: jwboyer@redhat.com
In-Reply-To: <1378741786-18430-8-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<1378741786-18430-8-git-send-email-matthew.garrett@nebula.com>
Date: Tue, 26 Nov 2013 07:54:23 -0500
X-Google-Sender-Auth: 1JmU0SyBIBX0KCDWtrSbusHYONs
Message-ID: <CA+5PVA6_4o6T7gS7q5uvksUBawxV__J82KQBMC=hE_qdTK2RUA@mail.gmail.com>
Subject: Re: [PATCH 07/12] acpi: Ignore acpi_rsdp kernel parameter when
 securelevel is set
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 11:49 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> From: Josh Boyer <jwboyer@redhat.com>
>
> This option allows userspace to pass the RSDP address to the kernel, which
> makes it possible for a user to execute arbitrary code in the kernel.
> Disable this when securelevel is set.
>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Dredging up an old thread in the hopes that Matthew runs sed and resubmits...

Also, FWIW, I didn't write this.  It was derived from previous
versions of something I did write, but there's really no evidence of
anything I wrote left, so it should probably be From: you.

> ---
>  drivers/acpi/osl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index e5f416c..f6d8977 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -45,6 +45,7 @@
>  #include <linux/list.h>
>  #include <linux/jiffies.h>
>  #include <linux/semaphore.h>
> +#include <linux/security.h>
>
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
> @@ -249,7 +250,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
>  acpi_physical_address __init acpi_os_get_root_pointer(void)
>  {
>  #ifdef CONFIG_KEXEC
> -       if (acpi_rsdp)
> +       if (acpi_rsdp && (get_securelevel <= 0))

This is missing some ( ).  That means you're comparing the
get_securelevel function pointer to 0.  Pretty sure bad things will
happen.

josh
