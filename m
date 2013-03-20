Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3CTLUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:20:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57579 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3CTLUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:20:09 -0400
Message-ID: <51499B5B.7020105@ti.com>
Date: Wed, 20 Mar 2013 16:49:55 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>
Subject: Re: [PATCH v2 1/3] ARM: davinci: clk framework support for enable/disable
 functionality
References: <1363761714-15034-1-git-send-email-avinashphilip@ti.com> <1363761714-15034-2-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1363761714-15034-2-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/2013 12:11 PM, Philip Avinash wrote:
> DAVINCI clock framework currently not supporting clock enable/disable
> functionality on clock nodes. In DAVINCI platform EHRPWM module requires

Wrong. clock enable/disable is supported in the DaVinci clock
implementation, but just for PSC clocks.

> support for clock enable/disable for TBCLK support. Hence this patch
> adds support for enabling/disabling clocks depends on the availability
> of the functionality.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
> 	- Add support for clock enable/disable functionality.
> 
> :100644 100644 d458558... aa89e5e... M	arch/arm/mach-davinci/clock.c
> :100644 100644 8694b39... 1e4e836... M	arch/arm/mach-davinci/clock.h
>  arch/arm/mach-davinci/clock.c |    4 ++++
>  arch/arm/mach-davinci/clock.h |    2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
> index d458558..aa89e5e 100644
> --- a/arch/arm/mach-davinci/clock.c
> +++ b/arch/arm/mach-davinci/clock.c
> @@ -35,6 +35,8 @@ static void __clk_enable(struct clk *clk)
>  {
>  	if (clk->parent)
>  		__clk_enable(clk->parent);
> +	if (clk->clk_enable)
> +		clk->clk_enable(clk);

Why ignore usecount in this case?

>  	if (clk->usecount++ == 0 && (clk->flags & CLK_PSC))

if clk->enable is available, no need to check for 'clk->flags & CLK_PSC'

Thanks,
Sekhar
