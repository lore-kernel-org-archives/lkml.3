Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaKJCyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 21:54:08 -0500
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.224]:7832
	"EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbaKJCyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 21:54:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgBAD0mYFSVhxBY/2dsb2JhbAANToQ7gwbQNQKBMAEBAQEBhQABAQQjVhALDQEKAgIFIQICDwJGBgEMAQUCAQGIJwG3MXiVHgEBAQEBAQEBAgEBAQEBAQEBGoEtj2gHgneBVAEEhjqgDoRgjWlagksBAQE
X-IronPort-AV: E=Sophos;i="5.07,349,1413216000"; 
   d="scan'208";a="570063852"
Message-ID: <54602679.80505@westnet.com.au>
Date: Mon, 10 Nov 2014 12:44:09 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: remove check for CONFIG_BSEIP
References: <1400572571.4912.7.camel@x220>
In-Reply-To: <1400572571.4912.7.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 20/05/14 17:56, Paul Bolle wrote:
> There used to be a Kconfig symbol BSEIP. It was PPC specific and was
> removed in v2.6.27. So the check for CONFIG_BSEIP can be removed. This
> means a few defines will be removed. None of the macros involved are
> used, so no one should care.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, applied to m68knommu for-next branch.

Regards
Greg



> ---
> Untested.
> 
>  arch/m68k/include/asm/commproc.h | 22 ----------------------
>  1 file changed, 22 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/commproc.h b/arch/m68k/include/asm/commproc.h
> index 66a36bd51aa1..c67e09279ea9 100644
> --- a/arch/m68k/include/asm/commproc.h
> +++ b/arch/m68k/include/asm/commproc.h
> @@ -480,28 +480,6 @@ typedef struct scc_enet {
>  #define SICR_ENET_CLKRT	((uint)0x0000003d)
>  #endif
>  
> -#ifdef CONFIG_BSEIP
> -/* This ENET stuff is for the MPC823 with ethernet on SCC2.
> - * This is unique to the BSE ip-Engine board.
> - */
> -#define PA_ENET_RXD	((ushort)0x0004)
> -#define PA_ENET_TXD	((ushort)0x0008)
> -#define PA_ENET_TCLK	((ushort)0x0100)
> -#define PA_ENET_RCLK	((ushort)0x0200)
> -#define PB_ENET_TENA	((uint)0x00002000)
> -#define PC_ENET_CLSN	((ushort)0x0040)
> -#define PC_ENET_RENA	((ushort)0x0080)
> -
> -/* BSE uses port B and C bits for PHY control also.
> -*/
> -#define PB_BSE_POWERUP	((uint)0x00000004)
> -#define PB_BSE_FDXDIS	((uint)0x00008000)
> -#define PC_BSE_LOOPBACK	((ushort)0x0800)
> -
> -#define SICR_ENET_MASK	((uint)0x0000ff00)
> -#define SICR_ENET_CLKRT	((uint)0x00002c00)
> -#endif
> -
>  /* SCC Event register as used by Ethernet.
>  */
>  #define SCCE_ENET_GRA	((ushort)0x0080)	/* Graceful stop complete */
> 

