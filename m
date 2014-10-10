Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaJJHy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:54:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56551 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbaJJHy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:54:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,690,1406584800"; 
   d="scan'208";a="100378549"
Date: Fri, 10 Oct 2014 09:54:16 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Wolfram Sang <wsa@the-dreams.de>
cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, cocci@systeme.lip6.fr,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Cocci] [RFC] drop owner assignment from platform_drivers
In-Reply-To: <20141010072439.GA1741@katana>
Message-ID: <alpine.DEB.2.10.1410100951250.2402@hadrien>
References: <20141010072439.GA1741@katana>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @match1@
> declarer name module_platform_driver;
> declarer name module_platform_driver_probe;
> identifier __driver;
> @@
> (
> 	module_platform_driver(__driver);
> |
> 	module_platform_driver_probe(__driver, ...);
> )
>
> @fix1 depends on match1@
> identifier match1.__driver;
> @@
> 	static struct platform_driver __driver = {
> 		.driver = {
> -			.owner = THIS_MODULE,
> 		}
> 	};
>
> @match2@
> identifier __driver;
> @@
> (
> 	platform_driver_register(&__driver)
> |
> 	platform_driver_probe(&__driver, ...)
> |
> 	platform_create_bundle(&__driver, ...)
> )
>
> @fix2 depends on match2@
> identifier match2.__driver;
> @@
> 	static struct platform_driver __driver = {
> 		.driver = {
> -			.owner = THIS_MODULE,
> 		}
> 	};

The semantic patch looks fine.  I'm a little surprised that it doesn't
complain about the lack of a comma after

.driver = { .owner = THIS_MODULE, }

but it seems that it does not.

If you think that it would be useful to have this in the Linux kernel, so
people don't add the owner initializer back in the future, you can try

coccinelle/tools/sgen/sgen

(run make in the coccinelle/tools/sgen directory).  That will guide you
through the process of making a Linux-ready semantic patch.  Feedback
would be appreciated.

julia
