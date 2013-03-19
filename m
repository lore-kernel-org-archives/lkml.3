Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3CSPEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:04:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55233 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3CSPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:04:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Mar 2013 16:04:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: Remove two unneeded checks for macros
Message-ID: <20130319160419.26197406@stein>
In-Reply-To: <1363439347.1335.129.camel@x61.thuisdomein>
References: <1363439347.1335.129.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 16 Paul Bolle wrote:
> The old IEEE 1394 driver stack was removed in v2.6.37. That made the
> checks for two Kconfig (module) macros unneeded, since they will now
> always evaluate to true. Remove these two checks.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Looks good to me, will commit it sometime soon.

> ---
> Perhaps these alias can be dropped entirely. Bat that's not my call.

Perhaps.  One could look through various distributor mkinitrds, but I
suspect that would be an impossible task.  First of all, I have no idea
what the package names could be.  Second, there seem to be quite a few
distributions which don't have any sensible public FTP/HTTP server from
which packages can be downloaded separately.

>  drivers/firewire/ohci.c | 2 --
>  drivers/firewire/sbp2.c | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
> index 45912e6..4a55b51 100644
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -3837,6 +3837,4 @@ MODULE_DESCRIPTION("Driver for PCI OHCI IEEE1394 controllers");
>  MODULE_LICENSE("GPL");
>  
>  /* Provide a module alias so root-on-sbp2 initrds don't break. */
> -#ifndef CONFIG_IEEE1394_OHCI1394_MODULE
>  MODULE_ALIAS("ohci1394");
> -#endif
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index 1162d6b..12ec0e6 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1636,9 +1636,7 @@ MODULE_LICENSE("GPL");
>  MODULE_DEVICE_TABLE(ieee1394, sbp2_id_table);
>  
>  /* Provide a module alias so root-on-sbp2 initrds don't break. */
> -#ifndef CONFIG_IEEE1394_SBP2_MODULE
>  MODULE_ALIAS("sbp2");
> -#endif
>  
>  static int __init sbp2_init(void)
>  {

-- 
Stefan Richter
-=====-===-= --== =--==
http://arcgraph.de/sr/
