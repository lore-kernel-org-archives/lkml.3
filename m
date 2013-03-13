Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3CMQuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:50:20 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:27714 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3CMQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:50:19 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r7TwZzuDyg=
X-RZG-CLASS-ID: mo00
Date: Wed, 13 Mar 2013 17:50:16 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH RESEND 5/6] Drivers: hv: balloon: Implement hot-add
 functionality
Message-ID: <20130313165015.GC23945@aepfle.de>
References: <1363111313-30201-1-git-send-email-kys@microsoft.com>
 <1363111342-30242-1-git-send-email-kys@microsoft.com>
 <1363111342-30242-5-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363111342-30242-5-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, K. Y. Srinivasan wrote:

> Implement the memory hot-add functionality. With this, Linux guests can fully
> participate in the Dynamic Memory protocol implemented in the Windows hosts.

> +++ b/drivers/hv/Kconfig
> @@ -15,7 +15,7 @@ config HYPERV_UTILS
>  
>  config HYPERV_BALLOON
>  	tristate "Microsoft Hyper-V Balloon driver"
> -	depends on HYPERV
> +	depends on HYPERV && MEMORY_HOTPLUG
>  	help
>  	  Select this option to enable Hyper-V Balloon driver.

This driver now depends on CONFIG_MEMORY_HOTPLUG, which is disabled in
openSuSE i386 kernel. As a result, the hv_balloon driver disappears for
32bit kernels.

Any chance that the Kconfig dependency can be moved inside the code so
that a 32bit guest can still do balloon operations?


Olaf
