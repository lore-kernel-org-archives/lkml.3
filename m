Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaI3BZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:25:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57751 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaI3BZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:25:40 -0400
Date: Mon, 29 Sep 2014 20:25:35 -0500
From: rkuo <rkuo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hexagon: Remove useless select of NO_IOPORT_MAP
Message-ID: <20140930012535.GA28236@codeaurora.org>
References: <1411586511.19525.38.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411586511.19525.38.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:21:51PM +0200, Paul Bolle wrote:
> Hexagon's primary Kconfig entry has a select for NO_IOPORT_MAP. But
> because hexagon never defines a Kconfig symbol NO_IOPORT_MAP this select
> is a nop. It can be removed.
> 
> Perhaps hexagon should add its own Kconfig entry for NO_IOPORT_MAP and
> have it default to 'y'. But since no one apparently had any problems
> with HAS_IOPORT_MAP defaulting to 'y' on hexagon, as it currently does,
> that is unlikely.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested by playing with arch/hexagon/configs/comet_defconfig. After "make
> oldconfig" the .config contains CONFIG_HAS_IOPORT_MAP=y both before and
> after this patch, as is expected.
> 
> Actually, the only difference I found in the .config file was that after
> this patch the .config file contained
>     CONFIG_HEXAGON=y
> 
> I have no idea why. Did I botch my test?
> 
>  arch/hexagon/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
> index 4dc89d1f9c48..f1817eae107a 100644
> --- a/arch/hexagon/Kconfig
> +++ b/arch/hexagon/Kconfig
> @@ -19,7 +19,6 @@ config HEXAGON
>  	select GENERIC_IRQ_SHOW
>  	select HAVE_ARCH_KGDB
>  	select HAVE_ARCH_TRACEHOOK
> -	select NO_IOPORT_MAP
>  	select GENERIC_IOMAP
>  	select GENERIC_SMP_IDLE_THREAD
>  	select STACKTRACE_SUPPORT
> -- 
> 1.9.3
> 

There seemed to be a convoluted history behind the ioport options, but yes this
is no longer needed/doesn't actually do anything.  Thanks!

Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
