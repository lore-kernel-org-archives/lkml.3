Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3AOSay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:30:54 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42968 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963Ab3AOSax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:30:53 -0500
Message-ID: <1358274665.2597.11.camel@joe-AO722>
Subject: Re: [PATCH 1/1] clk-divider: fix is_power_of_two()
From: Joe Perches <joe@perches.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Date: Tue, 15 Jan 2013 10:31:05 -0800
In-Reply-To: <1358245685-4392-1-git-send-email-james.hogan@imgtec.com>
References: <1358245685-4392-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 10:28 +0000, James Hogan wrote:
> The macro is_power_of_two() in clk-divider.c was defined as !(i & ~i)
> which is always true. Correct it to !(i & (i - 1)).
[]
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
[]
> @@ -29,8 +29,8 @@
[]
> -#define div_mask(d)	((1 << (d->width)) - 1)
> -#define is_power_of_two(i)	!(i & ~i)
> +#define div_mask(d)	((1 << ((d)->width)) - 1)
> +#define is_power_of_two(i)	(!((i) & ((i) - 1)))

Use is_power_of_2 in log2.h instead?


