Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaJGJXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:23:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3774 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbaJGJXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:23:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,669,1406592000"; 
   d="scan'208";a="178883676"
Message-ID: <5433B0FE.60901@citrix.com>
Date: Tue, 7 Oct 2014 10:23:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xen.org" <Xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 08/44] kernel: Move pm_power_off to common
 code
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-9-git-send-email-linux@roeck-us.net>
In-Reply-To: <1412659726-29957-9-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 06:28, Guenter Roeck wrote:
> pm_power_off is defined for all architectures. Move it to common code.
> 
> Have all architectures call do_kernel_poweroff instead of pm_power_off.
> Some architectures point pm_power_off to machine_power_off. For those,
> call do_kernel_poweroff from machine_power_off instead.
[...]
>  arch/x86/xen/enlighten.c           |  3 +--

The xen bits:

Acked-by: David Vrabel <david.vrabel@citrix.com>

Although for a mechanical change like this I wonder if acks from all
subsystem maintainers is really necessary.

David
