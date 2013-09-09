Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3IIQ10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:27:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58353 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab3IIQ1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:27:24 -0400
Message-ID: <522DF6DC.1050303@zytor.com>
Date: Mon, 09 Sep 2013 09:27:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 08:49 AM, Matthew Garrett wrote:
> Provide a coarse-grained runtime configuration option for restricting
> userspace's ability to modify the running kernel.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  Documentation/security/securelevel.txt |  23 +++++++
>  include/linux/security.h               |   8 +++
>  security/Kconfig                       |   8 +++
>  security/Makefile                      |   1 +
>  security/securelevel.c                 | 116 +++++++++++++++++++++++++++++++++
>  5 files changed, 156 insertions(+)
>  create mode 100644 Documentation/security/securelevel.txt
>  create mode 100644 security/securelevel.c
> 
> diff --git a/Documentation/security/securelevel.txt b/Documentation/security/securelevel.txt
> new file mode 100644
> index 0000000..a1355a0
> --- /dev/null
> +++ b/Documentation/security/securelevel.txt
> @@ -0,0 +1,23 @@
> +Linux securelevel interface
> +---------------------------
> +
> +The Linux securelevel interface (inspired by the BSD securelevel interface)
> +is a runtime mechanism for configuring coarse-grained kernel-level security
> +restrictions. It provides a runtime configuration variable at
> +/sys/kernel/security/securelevel which can be written to by root. The
> +following values are supported:
> +
> +-1: Permanently insecure mode. This level is equivalent to level 0, but once
> +    set cannot be changed.
> +
> +0:  Insecure mode (default). This level imposes no additional kernel
> +    restrictions.
> +
> +1:  Secure mode. If set, userspace will be unable to perform direct access
> +    to PCI devices, port IO access, access system memory directly via
> +    /dev/mem and /dev/kmem, perform kexec_load(), use the userspace
> +    software suspend mechanism, insert new ACPI code at runtime via the
> +    custom_method interface or modify CPU MSRs (on x86). Certain drivers
> +    may also limit additional interfaces.
> +

This will break or have to be redefined once you have signed kexec.

	-hpa


