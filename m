Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3CUUv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:51:59 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39729 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3CUUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1303211206160.5662@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1303211206160.5662@chino.kir.corp.google.com>
Date: Thu, 21 Mar 2013 13:51:57 -0700
X-Google-Sender-Auth: SlfrB1OB-JMCu7hcnnznzPUjsrg
Message-ID: <CAPnjgZ2_AowYw_CsrmhtP5uXRWqYfbgDueNKYF0KAzyVCuf9=A@mail.gmail.com>
Subject: Re: [patch] drivers, mfd: fix link error
From: Simon Glass <sjg@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:08 PM, David Rientjes <rientjes@google.com> wrote:
> CONFIG_MFD_CROS_EC requires CONFIG_MFD_CORE for a couple of functions that
> are declared but not defined:
>
>         ERROR: "mfd_remove_devices" [drivers/mfd/cros_ec.ko] undefined!
>         ERROR: "mfd_add_devices" [drivers/mfd/cros_ec.ko] undefined!
>
> Fix it by selecting CONFIG_MFD_CORE anytime CONFIG_MFD_CROS_EC is enabled.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Take 2

Acked-by: Simon Glass <sjg@chromium.org>

> ---
>  drivers/mfd/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -23,6 +23,7 @@ config MFD_88PM860X
>
>  config MFD_CROS_EC
>         tristate "Support ChromeOS Embedded Controller"
> +       select MFD_CORE
>         help
>           If you say Y here you get support for the ChromeOS Embedded
>           Controller (EC) providing keyboard, battery and power services.
