Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaFYIkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:40:15 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59884 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbaFYIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:40:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Suman Anna <s-anna@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [PATCH 6/6] mailbox/omap: add a custom of_xlate function
Date: Wed, 25 Jun 2014 10:39:32 +0200
Message-ID: <5721425.bMLltMQDlc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403660878-56350-7-git-send-email-s-anna@ti.com>
References: <1403660878-56350-1-git-send-email-s-anna@ti.com> <1403660878-56350-7-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BMZA0pUNinG0ZGP4ZPNHLXbC6oTEVwc4yCVd0OSGaPP
 iR3s/60V9/e/+ZcfqDGU7lkEf0Q/au4TnoRCLCW8lZLab4oQBa
 7d4a4HSp6nnF3+4Gw82GwDii+5hzUsWNPDqH+/f3oQU9FiHllf
 T+0F/0yDynL2/jc+MOL6ElaGgWLWz1ymzKIX/0xz8D+8DrI9bA
 LxUBu8QZC+ViJ697KN9iTfQL+07RhlvDcqM/yJ245xxKXpcjj8
 GOxgGmX3ndXc16hVWys9UPEDKFlRAY+uqfZzIlXFFjST4dmzHi
 kIJil8/+zDlMbPhfXVqqKj+spUC4Mivo0l4Bfp6UB7XVsNomGX
 VsM3nwE/oZjL0ot2NdGE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2014 20:47:58 Suman Anna wrote:
> +static struct mbox_chan *omap_mbox_of_xlate(struct mbox_controller *controller,
> +                                           const struct of_phandle_args *sp)
> +{
> +       phandle phandle = sp->args[0];
> +       struct device_node *node;
> +       struct omap_mbox_device *mdev;
> +       struct omap_mbox *mbox;
> +
> +       node = of_find_node_by_phandle(phandle);
> +       if (!node) {
> +               pr_err("could not find node phandle 0x%x\n", phandle);
> +               return NULL;
> +       }
> +
> +       mdev = container_of(controller, struct omap_mbox_device, controller);
> +       if (WARN_ON(!mdev))
> +               return NULL;
> +
> +       mbox = omap_mbox_device_find(mdev, node->name);
> +       return mbox ? mbox->chan : NULL;
> 

Wouldn't it be easier to change the omap_mbox_device_find() function to
take a phandle argument directly? You shouldn't have to walk all
nodes in the system, or match it by name if you already have the 
device node.

Also, the xlate function is normally the place where you read out
the other arguments and set them as members in your omap_mbox
structure.

	Arnd
