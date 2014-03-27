Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaC0Ktl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:49:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17117 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbaC0Ktk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:49:40 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-e3-533402417127
Message-id: <5334023E.8070101@samsung.com>
Date: Thu, 27 Mar 2014 11:49:34 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.brezillon@overkiz.com, khilman@linaro.org, festevam@gmail.com,
        shawn.guo@linaro.org, nicolas.ferre@atmel.com,
        sebastian.hesselbarth@gmail.com, plagnioj@jcrosoft.com
Subject: Re: [PATCH] clk: reverse default clk provider initialization order in
 of_clk_init()
References: <1395917012-23483-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1395917012-23483-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xy7qOTCbBBkumWVlcOHeY0eLhVX+L
	r4dXMFpsenyN1eLyrjlsFk8nXGSz+Ha5md1i3cMXTBbvfzpaPF23hNmBy2PBr60sHjtn3WX3
	eHXhDovHnWt72Dw2L6n3mLT4D5vH501yAexRXDYpqTmZZalF+nYJXBmz101mKdjIWbHplWgD
	41X2LkZODgkBE4kVy16zQthiEhfurWfrYuTiEBJYyihxtHUHC4TziVGisWk6I0gVr4CWxO35
	e1hAbBYBVYn+5ReZQWw2AUOJ3qN9YDWiAhEScyduZoOoF5T4MfkeWL2IgKTEg8/TwYYyC3xh
	lDj77wjYGcICcRJP+vvBzhAScJP4+eQBWAOngLvEq6urwAYxC+hI7G+dBmXLS2xe85Z5AqPA
	LCQ7ZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkJj4uoNx6TGrQ4wCHIxK
	PLw77hsFC7EmlhVX5h5ilOBgVhLh7f9rHCzEm5JYWZValB9fVJqTWnyIkYmDU6qBUVR2X+P9
	HyYukwMt3ph94/yeayx/3DayOPXhbQ3NqbEMR6YXv922RMPncpd9vEOQXEOU5rsPk+5v0Xh2
	OZL5id/DpxPtvB/0fvp1y+dM7Nm+lXe/K8el305f5NJd1bU6evneW5cZsvWe80x2u8L1crvm
	SZ2pd8VyW+Vmvp5+6lqg0NtND6aFmyixFGckGmoxFxUnAgD3FkN4ZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/14 11:43, Sylwester Nawrocki wrote:
> This restores the default clocks registration order as parsed from
> devicetree, i.e. as before commit 1771b10d605d26ccee771a7fb4b08718
> "clk: respect the clock dependencies in of_clk_init", for when there
> is no explicit parent clock dependencies between clock providers
> specified in the device tree.
> 
> It prevents regressions (boot failure, division by 0 errors) on
> imx and exynos platforms.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Oops, I've forgotten to add:

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

> ---
>  drivers/clk/clk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 07cba07..c859adf 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -2596,7 +2596,7 @@ void __init of_clk_init(const struct of_device_id *matches)
>  
>  		parent->clk_init_cb = match->data;
>  		parent->np = np;
> -		list_add(&parent->node, &clk_provider_list);
> +		list_add_tail(&parent->node, &clk_provider_list);
>  	}
>  
>  	while (!list_empty(&clk_provider_list)) {

-- 
Regards,
Sylwester

