Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaBUOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:16:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaBUOQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:16:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alistair Popple <alistair@popple.id.au>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/7] IBM Akebono: Add support to the OHCI platform driver for PPC476GTR
Date: Fri, 21 Feb 2014 15:16:52 +0100
Message-ID: <16991392.luyzl1NYP3@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1392964293-13687-4-git-send-email-alistair@popple.id.au>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1392964293-13687-4-git-send-email-alistair@popple.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZvH0BXEg3sFXvWqgQLWV/PDN/OaLAQMlDaZ2QjB7Q1P
 6GpjcLXM4qXpXQircVk2yiBNEGkX2s1dAy2QLdWiWViDhGj9dy
 1cnHgCtQlY8V8kCPQNkmMUCgor81KsDR9b8xeuSVGZo5gRtmIU
 F4slVtomcC3h8tpAy8zM+FzIPvyrToYC8BvGLdNVTfJLSw9mEX
 i/Ezqf6O/Ybd0ZfCDbhQyVmVYbe4QRPLzGJhLnZpxf/L41H9sB
 p0dm56aUWacQ8Nycdt+/hSIlgO4dVIU02kiSN2CrHm5C3PDKkk
 eElw1OwlTDAzzb8jTbd58sy616+tb9HmDyQ/VjhFDYZnNRaXgM
 smrG10bqe935Qts3T2mE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 17:31:29 Alistair Popple wrote:
> 
> +static const struct of_device_id ohci_of_match[] = {
> +       { .compatible = "usb-ohci", },
> +       {},
> +};
> +
>  static const struct platform_device_id ohci_platform_table[] = {
>         { "ohci-platform", 0 },
>         { }
> @@ -198,6 +209,7 @@ static struct platform_driver ohci_platform_driver = {
>                 .owner  = THIS_MODULE,
>                 .name   = "ohci-platform",
>                 .pm     = &ohci_platform_pm_ops,
> +               .of_match_table = ohci_of_match,
>         }
>  };
>  
> 

Linux-next already has a patch to add an of_match_table in this driver,
using 

static const struct of_device_id ohci_platform_ids[] = {
        { .compatible = "generic-ohci", },
        { }
};

I think you should just use that string on your platform.

	Arnd
