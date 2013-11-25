Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3KYUEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:04:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3KYUEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:04:30 -0500
Message-ID: <5293AD4B.6030401@infradead.org>
Date: Mon, 25 Nov 2013 12:04:27 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org
CC: keescook@chromium.org, bleung@chromium.org
Subject: Re: [PATCH] platform/chrome: Add pstore platform_device
References: <1385408226-22369-1-git-send-email-olof@lixom.net>
In-Reply-To: <1385408226-22369-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/13 11:37, Olof Johansson wrote:
> Add the ramoops pstore device so that we get logs of panics across reboots.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
> 
>  drivers/platform/chrome/Kconfig           |  14 +++++
>  drivers/platform/chrome/Makefile          |   1 +
>  drivers/platform/chrome/chromeos_pstore.c | 101 ++++++++++++++++++++++++++++++
>  3 files changed, 116 insertions(+)
>  create mode 100644 drivers/platform/chrome/chromeos_pstore.c
> 
> diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kconfig
> index b13303e75a34..06c53c8132ad 100644
> --- a/drivers/platform/chrome/Kconfig
> +++ b/drivers/platform/chrome/Kconfig
> @@ -25,4 +25,18 @@ config CHROMEOS_LAPTOP
>  	  If you have a supported Chromebook, choose Y or M here.
>  	  The module will be called chromeos_laptop.
>  
> +config CHROMEOS_PSTORE
> +	tristate "Chrome OS pstore support"
> +	---help---
> +	  This module instantiates the persistent storage on x86 ChromeOS
> +	  devices. It can be used to store away console logs and crash
> +	  information across reboots.
> +
> +	  The range of memory used is 0xf00000-0x1000000, tradionally the

	                                                  traditionally

> +	  memory used to back VGA controller memory.
> +
> +	  If you have a supported Chromebook, choose Y or M here.
> +	  The module will be called chromeos_pstore.
> +
> +
>  endif # CHROMEOS_PLATFORMS


-- 
~Randy
