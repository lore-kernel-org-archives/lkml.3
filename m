Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaITNTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 09:19:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41250 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756028AbaITNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 09:19:53 -0400
Date: Sat, 20 Sep 2014 15:19:50 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, computersforpeace@gmail.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH 1/2] bus: brcmstb_gisb: register the fault code hook
Message-ID: <20140920151950.443b7ea9@free-electrons.com>
In-Reply-To: <1411155880-23447-2-git-send-email-f.fainelli@gmail.com>
References: <1411155880-23447-1-git-send-email-f.fainelli@gmail.com>
	<1411155880-23447-2-git-send-email-f.fainelli@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Florian Fainelli,

On Fri, 19 Sep 2014 12:44:39 -0700, Florian Fainelli wrote:

> -void __init brcmstb_hook_fault_code(void)
> +static int __init brcmstb_hook_fault_code(void)
>  {
>  	hook_fault_code(22, brcmstb_bus_error_handler, SIGBUS, 0,
>  			"imprecise external abort");
> +	return 0;
>  }
> +arch_initcall(brcmstb_hook_fault_code)

I don't have the entire context, but if your platform is part of
multi-platform, it means that regardless of which platform is actually
booting your system, you will register your fault hook. Is this the
intended behavior?

Generally speaking, in a multiplatform context, many arch_initcall()
should have a conditional to check whether we're really on a platform
where the initcall is needed.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
