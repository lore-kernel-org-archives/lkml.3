Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3H0WTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:19:53 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:4604
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab3H0WTv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:19:51 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(z551biz98dIc89bh154dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Tue, 27 Aug 2013 15:19:46 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <linux-tegra@vger.kernel.org>, <kernel@stlinux.com>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 01/16] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1377638890-371-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1377638890-371-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3837b119-baad-4e68-8805-2bc52c0135f9@DB9EHSMHS031.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:27:55PM +0200, Sebastian Hesselbarth wrote:
> Most DT ARM machs require common clock providers initialized before timers.
> Currently, arch/arm machs use .init_time to call clk_of_init right before
> clocksource_of_init. This prevents to remove that hook and use the default
> hook instead. clk_of_init is safe to call for non-DT platforms, so add
> the call to ARM arch time_init by default. While at it, also reorder includes
> alphabetically.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v1->v2:
> - reorder includes alphabetically
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-tegra@vger.kernel.org
> Cc: kernel@stlinux.com
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/kernel/time.c |   24 ++++++++++++++----------
>  1 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
> index 98aee32..dd1028e 100644
> --- a/arch/arm/kernel/time.c
> +++ b/arch/arm/kernel/time.c
> @@ -11,25 +11,26 @@
[ ... ]
>  void __init time_init(void)
>  {
> +	/* initalize common clocks before timers */
> +	of_clk_init(NULL);
> +
>  	if (machine_desc->init_time)
>  		machine_desc->init_time();
>  	else

This forces zynq to move some initialization our clock code relies on to
init_irq(). Also, the current code already takes an approach of
doing either common init or machine specific init.
I think it might be better to move the call to of_clk_init() down into
the else branch of the if-else.
Though, this probably contradicts the purpose of the whole series.

	Sören


