Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbaJHPFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:05:07 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37302 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaJHPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:05:04 -0400
Message-ID: <54355299.4000501@linaro.org>
Date: Wed, 08 Oct 2014 16:04:57 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 04/15] clk: divider: Make generic for usage elsewhere
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org> <1409957256-23729-5-git-send-email-sboyd@codeaurora.org> <542EE5FE.9080806@codeaurora.org> <54342287.7020005@linaro.org> <54343038.2060007@codeaurora.org>
In-Reply-To: <54343038.2060007@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/10/14 19:26, Stephen Boyd wrote:
> On 10/07/2014 10:27 AM, Srinivas Kandagatla wrote:
>> Hi Stephen,
>>
>> Just noticed this regression while testing the patch on Arndale board.
>>
>> https://bugs.linaro.org/show_bug.cgi?id=740
>
> If you return value it works correctly right?
>
I think you are right, ..
 From last message from bugs.linaro.org:

"
That seems to be it!

This change:
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -366,7 +366,7 @@ int divider_get_val(unsigned long rate, unsigned long
parent

         min_t(unsigned int, value, div_mask(width));

-       return 0;
+       return value;
  }
  EXPORT_SYMBOL_GPL(divider_get_val);

- makes Arndale to boot; rootfs on mmc mounts OK.
"

thanks,
srini
