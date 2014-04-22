Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaDVKDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:03:35 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:63131 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaDVKDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:03:11 -0400
Message-ID: <53563E5C.1080709@linaro.org>
Date: Tue, 22 Apr 2014 11:03:08 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-mmc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC 10/12] mmc: mmci: Add clock support for Qualcomm.
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org> <1398116945-31640-1-git-send-email-srinivas.kandagatla@linaro.org> <535599BD.1020605@codeaurora.org>
In-Reply-To: <535599BD.1020605@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou Stephen,

On 21/04/14 23:20, Stephen Boyd wrote:
> Please turn on lockdep (PROVE_LOCKING) and sleeping while atomic checks
> (DEBUG_ATOMIC_SLEEP). You cannot call clk_set_rate() in atomic context.
You are correct, there is a spinlock taken just before entering this 
code. I will fix this in next version by moving clk_set_rate out of this 
lock.

Thanks,
srini
