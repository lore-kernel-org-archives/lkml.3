Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaCQQms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:42:48 -0400
Received: from [213.199.154.206] ([213.199.154.206]:41377 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbaCQQmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:42:46 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dIc89bh936eIe0eah1432I4015I14ffIzz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Mon, 17 Mar 2014 09:41:18 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: linux-next: manual merge of the tip tree with the arm-soc tree
References: <20140317163506.5770f06a77ba011e682f47ff@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140317163506.5770f06a77ba011e682f47ff@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <6b7bc052-bb06-4821-9710-50c4852425c8@AM1EHSMHS002.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 04:35PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> arch/arm/mach-zynq/Kconfig between commit ddb902cc3459 ("ARM: centralize
> common multi-platform kconfig options") from the arm-soc tree and commit
> cd325295871f ("arm: zynq: Add support for cpufreq") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-zynq/Kconfig
> index 105d39b72a25,f03e75bd0b2b..000000000000
> --- a/arch/arm/mach-zynq/Kconfig
> +++ b/arch/arm/mach-zynq/Kconfig
> @@@ -2,10 -2,19 +2,12 @@@ config ARCH_ZYN
>   	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
>   	select ARM_AMBA
>   	select ARM_GIC
> + 	select ARCH_HAS_CPUFREQ
> + 	select ARCH_HAS_OPP
>  -	select COMMON_CLK
>  -	select CPU_V7
>  -	select GENERIC_CLOCKEVENTS
>   	select HAVE_ARM_SCU if SMP
>   	select HAVE_ARM_TWD if SMP
>   	select ICST
>  -	select MIGHT_HAVE_CACHE_L2X0

The two conflicting patches mentioned above don't touch this line, I
think. I'm not sure whether this should go away.
Apart from this, things look okay to me.

	Thanks,
	Sören


