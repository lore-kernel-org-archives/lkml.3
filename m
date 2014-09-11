Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaIKKDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:03:46 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:63472 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaIKKDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:03:44 -0400
Message-ID: <5411737D.4070801@imgtec.com>
Date: Thu, 11 Sep 2014 11:03:41 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, <linux-mips@linux-mips.org>,
        <nbd@openwrt.org>, <james.hogan@imgtec.com>, <jchandra@broadcom.com>,
        <paul.burton@imgtec.com>, <david.daney@cavium.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <macro@linux-mips.org>, <manuel.lauss@gmail.com>,
        <jerinjacobk@gmail.com>, <chenhc@lemote.com>, <blogic@openwrt.org>
Subject: Re: [PATCH V2] MIPS: bugfix of coherentio variable default setup
References: <20140908191002.13852.47842.stgit@linux-yegoshin>
In-Reply-To: <20140908191002.13852.47842.stgit@linux-yegoshin>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leonid,

On 09/08/2014 08:10 PM, Leonid Yegoshin wrote:
> Patch commit b6d92b4a6bdb880b39789c677b952c53a437028d
> 
>     MIPS: Add option to disable software I/O coherency.
> 
>     Some MIPS controllers have hardware I/O coherency. This patch
>     detects those and turns off software coherency. A new kernel
>     command line option also allows the user to manually turn
>     software coherency on or off.
> 
> in fact enforces L2 cache flushes even on systems with IOCU.
> The default value of coherentio is 0 and is not changed even with IOCU.
> It is a serious performance problem because it destroys all IOCU performance
> advantages.
> 
> It is fixed by setting coherentio to tri-state with default value as (-1) and
> setup a final value during platform coherency setup.
> 
> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> [...]
> diff --git a/arch/mips/mti-malta/malta-setup.c b/arch/mips/mti-malta/malta-setup.c
> index db7c9e5..48039fd 100644
> --- a/arch/mips/mti-malta/malta-setup.c
> +++ b/arch/mips/mti-malta/malta-setup.c
> @@ -147,13 +147,17 @@ static void __init plat_setup_iocoherency(void)
>  	if (plat_enable_iocoherency()) {
>  		if (coherentio == 0)
>  			pr_info("Hardware DMA cache coherency disabled\n");
> -		else
> +		else {
> +			coherentio = 1;
>  			pr_info("Hardware DMA cache coherency enabled\n");
> +		}
>  	} else {
>  		if (coherentio == 1)
>  			pr_info("Hardware DMA cache coherency unsupported, but enabled from command line!\n");
> -		else
> +		else {
> +			coherentio = 0;
>  			pr_info("Software DMA cache coherency enabled\n");
> +		}

This is not acceptable coding style for the kernel. See
Documentation/CodingStyle, Chapter 3. Since you are adding braces in the
"else" case, you should also add them in the "if" case as well.

-- 
markos
