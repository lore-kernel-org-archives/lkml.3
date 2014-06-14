Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaFNWMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:12:35 -0400
Received: from avasout05.plus.net ([84.93.230.250]:58324 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaFNWMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:12:33 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2014 18:12:33 EDT
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.1 cv=DIIB4k9b c=1 sm=1 tr=0
 a=fkd5KTHJFGKPA0tsLFcInQ==:117 a=fkd5KTHJFGKPA0tsLFcInQ==:17 a=gJibsqi4AAAA:8
 a=0Bzu9jTXAAAA:8 a=MvqziL5F8ecA:10 a=iYpfILVWdnsA:10 a=8nJEP1OIZ-IA:10
 a=pGLkceISAAAA:8 a=Vf6cYym6wm6hfEkr848A:9 a=wPNLvfGTeEIA:10 a=MSl-tDqOz04A:10
Message-ID: <539CC75F.2080105@baker-net.org.uk>
Date: Sat, 14 Jun 2014 23:06:23 +0100
From: Adam Baker <linux@baker-net.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nick <xerofoify@gmail.com>, emilio@elopez.com.ar
CC: maxime.ripard@free-electrons.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Frees gate after if statement in clk-sunxi.c
References: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/14 19:11, Nick wrote:
> Signed-off-by: Nick <xerofoify@gmail.com>
> ---
>   drivers/clk/sunxi/clk-sunxi.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 4264834..6f4fc51 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -42,6 +42,7 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
>   	u32 rate;
>
>   	if (of_property_read_u32(node, "clock-frequency", &rate))
> +		kree(gate);
>   		return;

There are no braces around this so the function of this code as written 
is an unconditional return and the return shouldn't be indented. I 
suspect, without reading the rest of the file, that that isn't what you 
intended.

>
>   	/* allocate fixed-rate and gate clock structs */
>

Adam
