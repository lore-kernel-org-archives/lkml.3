Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbaEMPNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:13:08 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64440 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999AbaEMPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:13:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] bus/omap_l3: avoid sync initcall for modules
Date: Tue, 13 May 2014 17:12:31 +0200
Message-ID: <177753046.dmVvfiu3Rn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140512222006.GI5668@atomide.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-6-git-send-email-arnd@arndb.de> <20140512222006.GI5668@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TLC206ZjIesaTANFAAu9Je0C3G16OJaYsOzynFgBbYU
 9w4NFZdhwjR/9AXefcDOKJJ7MhDAG8xiTanTbR2bXkz1M6Xrr4
 VWkOrTncdikv5RI/sARons5v15hSxZYAjugVJBM0xhCXM/tgX1
 FZKRe6r+iy3hggUFfEgkaBq4eIJyx7pp7DjTVgw0KJuyKPAkE8
 a8Zf845nw4YNlz071zfDjEpGOWSXJJ73xQq/IaH0dQJNWXsTmx
 ITKyWCcsM7h961myTsTY+g0sQFl36n6EMqSd0pWyhonDTAmOZT
 WxePlMOyaLVi7nW0fdOFeZaufCkam/5Lc2BPf67GljQwHIZCFw
 wVgenkwCzcWuxaHJ5GYc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2014 15:20:07 Tony Lindgren wrote:
> 
> How about instead let's add this into include/linux/module.h
> like we have for other initcalls:
> 
> #define postcore_initcall(fn)           module_init(fn)
> 
> There may be others missing too from there. BTW, this driver
> might be few of the drivers that actually might need to be
> initialized early for debugging to catch bad access from
> other drivers.

There is a comment above those defines saying:

/* Don't use these in loadable modules, but some people do... */

so I'm not sure if adding more would be appreciated.

	Arnd
