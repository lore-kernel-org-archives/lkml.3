Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab3BSQvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:51:24 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:41612 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab3BSQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:51:22 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rDcwfYOOLE=
X-RZG-CLASS-ID: mo00
Date: Tue, 19 Feb 2013 17:51:18 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org, kys@microsoft.com,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Message-ID: <20130219165118.GA17715@aepfle.de>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21.rev5638 (2013-02-08)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, Haiyang Zhang wrote:

> @@ -508,6 +544,18 @@ static int __init vesafb_init(void)
>  	int ret;
>  	char *option = NULL;
>  
> +#if IS_ENABLED(CONFIG_HYPERV_FB)
> +	/*
> +	 * On Hyper-V both the emulated and synthetic video devices are
> +	 * available. To avoid conflicts, we disable vesafb for the emulated
> +	 * video if hyperv_fb is configured.
> +	 */
> +	if (is_hyperv()) {
> +		pr_info("Disabled vesafb on Hyper-V.\n");
> +		return -ENODEV;
> +	}
> +#endif

What is the reason for this hook? Is it not possible to claim the
display like its appearently done by other drivers (like radeonfb can
take over display from vesafb)?

Olaf
