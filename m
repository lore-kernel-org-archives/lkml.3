Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaFPDVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 23:21:43 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:61139 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaFPDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 23:21:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140615203058.GA22265@lukather>
References: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
	<20140615203058.GA22265@lukather>
Date: Sun, 15 Jun 2014 23:21:39 -0400
Message-ID: <CAPDOMVj0JSp-ZfvAXkeTqHscKkhmp0ZttN5NVM+BYE_X+jWCcQ@mail.gmail.com>
Subject: Re: [PATCH] Frees gate after if statement in clk-sunxi.c
From: Nick Krause <xerofoify@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New Patch Just Fixed Typo for my email client.
Signed-off-by: Nick <xerofoify@gmail.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/sunxi/clk-sunxi.
c b/drivers/clk/sunxi/clk-sunxi.c
index 4264834..6f4fc51 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -42,6 +42,7 @@ static void __init sun4i_osc_clk_setup(struct
device_node *node)
        u32 rate;

        if (of_property_read_u32(node, "clock-frequency", &rate))
+               kfree(gate);
                return;

        /* allocate fixed-rate and gate clock structs */
Cheers Nick

On Sun, Jun 15, 2014 at 4:30 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Sat, Jun 14, 2014 at 02:11:48PM -0400, Nick wrote:
>> Signed-off-by: Nick <xerofoify@gmail.com>
>
> This should be your full real name here.
>
>> ---
>>  drivers/clk/sunxi/clk-sunxi.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
>> index 4264834..6f4fc51 100644
>> --- a/drivers/clk/sunxi/clk-sunxi.c
>> +++ b/drivers/clk/sunxi/clk-sunxi.c
>> @@ -42,6 +42,7 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
>>       u32 rate;
>>
>>       if (of_property_read_u32(node, "clock-frequency", &rate))
>> +             kree(gate);
>
> There's a typo in kfree. How does that even compile?
>
> --
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
