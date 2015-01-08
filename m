Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbbAHVWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:22:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35876 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379AbbAHVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:22:44 -0500
Message-ID: <54AEF522.1060904@codeaurora.org>
Date: Thu, 08 Jan 2015 13:22:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: Add clk_unregister_{divider,gate,mux} to close
 memory leak
References: <1420451561-12360-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1420451561-12360-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 01:52 AM, Krzysztof Kozlowski wrote:
> The common clk_register_{divider,gate,mux} functions allocated memory
> for internal data which wasn't freed anywhere. Drivers using these
> helpers could only unregister clocks but the memory would still leak.
>
> Add corresponding unregister functions which will release all resources.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---

We're trying to move away from struct clk in provider APIs. It would be
nice to have these functions take the clk_hw pointer instead, but I
guess that can come later.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

