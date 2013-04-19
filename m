Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030988Ab3DSQlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:41:20 -0400
Received: from multi.imgtec.com ([194.200.65.239]:20021 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967882Ab3DSQlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:41:16 -0400
Message-ID: <5171739C.90707@imgtec.com>
Date: Fri, 19 Apr 2013 17:41:00 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [RFC PATCH v1 0/3] clk: implement remuxing during set_rate
References: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com> <515B8EAD.8020109@codeaurora.org> <CAAG0J99i-AwbGoerTzQvJ+JC9yj-3Owm3e5+6xTijo4Gihcx-Q@mail.gmail.com> <20130403213412.3383.84823@quantum>
In-Reply-To: <20130403213412.3383.84823@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_19_17_41_01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 03/04/13 22:34, Mike Turquette wrote:
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 9fdfae7..1a19186 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -126,6 +126,9 @@ struct clk_ops {
>  					unsigned long parent_rate);
>  	long		(*round_rate)(struct clk_hw *hw, unsigned long,
>  					unsigned long *);
> +	s64		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
> +					unsigned long *best_parent_rate,
> +					struct clk *best_parent_clk);

Thanks for the comments. I've sent a new patchset based on this. I've
left the return value for determine_rate the same as round_rate though
(long rather than s64), figuring that introducing s64 would be a can of
worms, and if wanting to convert code to use s64, it should probably be
done together in a separate patchset.

Cheers
James

