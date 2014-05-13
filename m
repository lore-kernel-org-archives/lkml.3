Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074AbaEMPMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:12:16 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:46090 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910AbaEMPMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <1399940993-1773-4-git-send-email-robherring2@gmail.com>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
	<1399940993-1773-4-git-send-email-robherring2@gmail.com>
Date: Tue, 13 May 2014 10:12:11 -0500
X-Google-Sender-Auth: 173_uyp23FLSpRcXmtiZn_NYGao
Message-ID: <CAL_JsqL0wWi0Pz6NirzEVWeHKqrRiGB6Q+9JYp6ew5KTeeY0dQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] clk: sunxi: avoid double DT matching
From: Rob Herring <robh@kernel.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 7:29 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
>
> Use for_each_matching_node_and_match instead of for_each_matching_node plus
> of_match_node to avoid searching the DT twice for each node.
>
> The sunxi DT scanning code should really be re-worked rather than have
> its own private matching infrastructure. It is working around needing a
> function pointer and a data pointer for each compatible match.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: "Emilio López" <emilio@elopez.com.ar>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/clk/sunxi/clk-sunxi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index bd7dc73..7977106 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -1278,8 +1278,7 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
>         const struct of_device_id *match;
>         void (*setup_function)(struct device_node *, const void *) = function;
>
> -       for_each_matching_node(np, clk_match) {
> -               match = of_match_node(clk_match, np);
> +       for_each_matching_node_and_match(np, clk_match, match) {

I missed folding in a fix and this should be &match instead of match.

Rob

>                 data = match->data;
>                 setup_function(np, data);
>         }
> --
> 1.9.1
>
