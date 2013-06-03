Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3FCTRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:17:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3FCTRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:17:05 -0400
Message-ID: <51ACEBAF.6010707@codeaurora.org>
Date: Mon, 03 Jun 2013 12:17:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 2/2] mfd: ssbi: Use devm_* to simplify code
References: <1370152955-14841-1-git-send-email-sboyd@codeaurora.org> <1370152955-14841-2-git-send-email-sboyd@codeaurora.org> <20130603081021.GA3370@gmail.com>
In-Reply-To: <20130603081021.GA3370@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 01:10, Lee Jones wrote:
>> Use devm_ioremap_resource and devm_kzalloc to simplify error
>> paths and reduce lines of code.
> The code looks fine, but you're actually doing a great deal more than
> you describe in the commit message. Would you mind expanding?
>
> I.e:
>
>> +		dev_err(&pdev->dev, "Unknown qcom,controller-type\n");
> Switching to these 'cos they're more informative.
>
>> -	platform_set_drvdata(pdev, NULL);
> Removing these because they're obsolete.
>
>> -	.remove		= ssbi_remove,
> Removing this 'cos it no longer does anything useful.
>
>> +module_platform_driver(ssbi_driver);
> Moving these because it's more succinct when init() and exit()
> routines are baron.
>
> None of the above have anything to do with devm_* managed resources.
>

Ok I'll update the commit text and resend. Thanks for the review.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

