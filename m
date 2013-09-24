Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3IXJUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:20:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34008 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3IXJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:20:19 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-1a-52415950f92d
From: Tomasz Figa <t.figa@samsung.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/6] clk: exynos-audss: convert to platform device
Date: Tue, 24 Sep 2013 11:20:05 +0200
Message-id: <3549301.xmRx49e0Zc@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org>
 <1379982078-23381-1-git-send-email-abrestic@chromium.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xy7oBkY5BBh/ajS1Wvv/LaDH/yDlW
	i7PLDrJZHPizg9Hi3KuVjBa75yxmsehdcJXNYueWG2wWmx5fY7VY2LaExeLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFk8nXGSz+H3zO5vFhOlrWSymLDrManF4xQEmi3Uvp7NYnPzTy2jx40w3i8Wr
	g20sFvM+72SyaP+7l81B0mPNvDWMHi3NPWweCz5fYfeY3XCRxeNyXy+Tx85Zd9k9Vi7/wubx
	avVMVo871/aweWxeUu/Rt2UVo8eZBUfYPT5vkvPYODc0gC+KyyYlNSezLLVI3y6BK2Pn2uSC
	p+wVu5+4NDBOYeti5OSQEDCRaO18wAphi0lcuLceKM7FISSwlFFi9dUtjBBOF5PEvxVbmUGq
	2ATUJD43PALrFhHQlZh64TQTiM0ssJJdom8/F4gtLOApse7TQhYQm0VAVWL9/iNgNq+ApsSX
	x4/B6vkF1CXebXsKZosKuEp8WriRHcTmFHCTaGu7yQKxuIFR4t6dHiaIZkGJH5PvsUAsk5fY
	t38qK4StJbF+53GmCYyCs5CUzUJSNgtJ2QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsY
	IUngyw7GxcesDjEKcDAq8fBeTHAIEmJNLCuuzD3EKMHBrCTCe8PWMUiINyWxsiq1KD++qDQn
	tfgQIxMHp1QD48paj8pH0vHOypcPRyqeuehmXRXc9yHgCpMRa/nd89cezJWbsaZ3u9uPp6vO
	rPv6aPv9SRf5YkQaJJJM9Y7JtW/dPW+aeP9qHT82qaMdWkd5l5itTTKdEhK2W8dYZFGgjdF9
	g8VtTWVn1bN1e/f+U9Kv2pgTqbHqUOvO9IOMrSHd7wunsHIJK7EUZyQaajEXFScCACtk/nPg	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I'd like to ack this series, but there is one more thing that I think
should be fixed. Please see my comment inline.

On Monday 23 of September 2013 17:21:13 Andrew Bresticker wrote:
> @@ -128,8 +135,53 @@ static void __init exynos_audss_clk_init(struct device_node *np)
>  #endif
>  
>  	pr_info("Exynos: Audss: clock setup completed\n");

nit (not the thing I mentioned above): This (and possibly other uses of
pr_*() could be replaced with dev_*().

> +
> +	return 0;
> +}
> +
> +static int exynos_audss_clk_remove(struct platform_device *pdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < EXYNOS_AUDSS_MAX_CLKS; i++) {
> +		if (clk_table[i])

I believe clk_register_* functions return ERR_PTR() in case of failure,
not NULL, so this should be accounted for either here or at probe time.
Possibly checking for registration error in probe() would be the best
solution, although bloating the code a bit (but what error path isn't?).

Best regards,
Tomasz

