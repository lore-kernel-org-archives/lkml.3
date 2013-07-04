Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3GDUpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 16:45:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51699 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab3GDUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 16:45:53 -0400
Message-ID: <51D5DEE7.2070400@ti.com>
Date: Thu, 4 Jul 2013 23:45:27 +0300
From: Luciano Coelho <coelho@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] clk: export __clk_get_flags for modular clock
 providers
References: <1366009186-32199-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1366009186-32199-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/15/2013 09:59 AM, Sebastian Hesselbarth wrote:
> The common clock api provides some helpers for clk-providers but does
> not export these helpers. This hinders clk-providers to be built as modules.
> This patch adds __clk_get_flags() to the list of exported symbols.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/clk/clk.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index ed87b24..3e478b8 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -450,6 +450,7 @@ unsigned long __clk_get_flags(struct clk *clk)
>   {
>   	return !clk ? 0 : clk->flags;
>   }
> +EXPORT_SYMBOL_GPL(__clk_get_flags);
>
>   bool __clk_is_enabled(struct clk *clk)
>   {
>

I think this got merged slightly wrong.  The EXPORT_SYMBOL_GPL macro 
came under clk_unprepare_unused_subtree() instead of under 
__clk_get_flags():


Of course this is not that important, but it's a bit confusing when you 
look at the code.

--
Cheers,
Luca.
