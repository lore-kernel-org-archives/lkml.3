Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618Ab3HIJMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:12:09 -0400
Received: from multi.imgtec.com ([194.200.65.239]:33706 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965312Ab3HIJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:12:08 -0400
Message-ID: <5204B25C.70102@imgtec.com>
Date: Fri, 9 Aug 2013 10:11:56 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1 04/14] clk: Add set_rate_and_parent() op
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org> <1374713022-6049-5-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1374713022-6049-5-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_08_09_10_11_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 25/07/13 01:43, Stephen Boyd wrote:
> Some of Qualcomm's clocks can change their parent and rate at the
> same time with a single register write. Add support for this
> hardware to the common clock framework by adding a new
> set_rate_and_parent() op. When the clock framework determines
> that both the parent and the rate are going to change during
> clk_set_rate() it will call the .set_rate_and_parent() op if
> available and fall back to calling .set_parent() followed by
> .set_rate() otherwise.
> 
> Cc: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Aside from the nit below, I can't see anything wrong with this patch.
Reviewed-by: James Hogan <james.hogan@imgtec.com>

> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 484f8ad..1f7eabb 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -108,6 +108,18 @@ struct clk_hw;
>   *		which is likely helpful for most .set_rate implementation.
>   *		Returns 0 on success, -EERROR otherwise.
>   *
> + * @set_rate_and_parent: Change the rate and the parent of this clock. The
> + *		requested rate is specified by the second argument, which
> + *		should typically be the return of .round_rate call.  The
> + *		third argument gives the parent rate which is likely helpful
> + *		for most .set_rate_and_parent implementation. The fourth
> + *		argument gives the parent index. It is optional (and

nit: s/It/This callback/ or add newline or something - I completely
misread it the first time, thinking you were referring to the parent
index argument :)

> + *		unnecessary) for clocks with 0 or 1 parents as well as
> + *		for clocks that can tolerate switching the rate and the parent
> + *		separately via calls to .set_parent and .set_rate.
> + *		Returns 0 on success, -EERROR otherwise.
> + *
> + *
>   * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
>   * implementations to split any work between atomic (enable) and sleepable
>   * (prepare) contexts.  If enabling a clock requires code that might sleep,

Thanks
James

