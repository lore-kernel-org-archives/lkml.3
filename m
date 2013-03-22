Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab3CVPnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:43:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab3CVPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:43:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/5] ARM: ux500: Do not supply DMA platform data when booting u8540 platform
Date: Fri, 22 Mar 2013 15:43:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org> <1363966065-2478-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1363966065-2478-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221543.14165.arnd@arndb.de>
X-Provags-ID: V02:K0:siP+DOS2BqufuAp1edr9aSk7ha4OWfACOZM381ZGHc+
 /dbSGBxmgDrkfrezLAYlPMdexHzxsg4FYxqztzjjqsXSUlRNZ/
 t9J3gW7BRFKxzgzK1h1dcd8os9Bp5PRy2Egb9wxhypYsGfaR70
 AKfqrZXKNZrgkayhF2ph4Tf7IZY/7gOZLbNIato+N0EugxfvEt
 X5hReDxWqPg+nDJpnh7a1HBjmcrZl/BfCL27Y0Rc6bWdegY0dm
 FnI0ZHy1Ipamk4O++zWzvJm6SGzZ4X5MpIg0O4Efmvs7HWqFPx
 WhHFlHjyQGo+Q47ov9bA5eTg9Dzh/D+e4nunw0NyZYi/ehkC2x
 WOP1RY8NfYQEiVB6IKVA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 March 2013, Lee Jones wrote:
>         /* automatically probe child nodes of db8500 device */
>         of_platform_populate(NULL, u8500_local_bus_nodes, u8500_auxdata_lookup, parent);
> +
> +       if (of_machine_is_compatible("st-ericsson,u8540"))
> +               of_platform_populate(NULL, u8500_local_bus_nodes,
> +                                    u8540_auxdata_uart_lookup, parent);
> +       else
> +               of_platform_populate(NULL, u8500_local_bus_nodes,
> +                                    u8500_auxdata_uart_lookup, parent);
>  }
>  

Does this still work on u8500? I did not think you could call 
of_platform_populate twice on the root node and still get the result
you want.

	Arnd
