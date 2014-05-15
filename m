Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaEON2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:28:48 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:55624 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaEON2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com>
References: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com>
Date: Thu, 15 May 2014 10:28:46 -0300
Message-ID: <CAOMZO5C9iqLj34mJdztqZsyLNR6oHztyN2GxDY0ORp+0xU1+LA@mail.gmail.com>
Subject: Re: [PATCH] clk: divider: Fix table round up function
From: Fabio Estevam <festevam@gmail.com>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, May 7, 2014 at 1:48 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:
> Commit 1d9fe6b97 ("clk: divider: Fix best div calculation for power-of-two and
> table dividers") introduces a regression in its _table_round_up function.
>
> When the divider passed to this function is greater than the max divider
> available in the table, this function returns table's max divider.
> Problem is that it causes an infinite loop in clk_divider_bestdiv() because
> _next_div() will never return a value greater than maxdiv.
>
> Instead of returning table's max divider, this patch returns INT_MAX.
>
> Reported-by: Fabio Estevam <festevam@gmail.com>
> Reported-by: Shawn Guo <shawn.guo@freescale.com>
> Tested-by: Fabio Estevam <festevam@gmail.com>
> Cc: Mike Turquette <mike.turquette@linaro.org>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Any comments on this one? It does fix a regression.
