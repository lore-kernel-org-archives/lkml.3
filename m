Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3FCIKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:10:32 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:44180 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3FCIK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:10:27 -0400
Date: Mon, 3 Jun 2013 09:10:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 2/2] mfd: ssbi: Use devm_* to simplify code
Message-ID: <20130603081021.GA3370@gmail.com>
References: <1370152955-14841-1-git-send-email-sboyd@codeaurora.org>
 <1370152955-14841-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370152955-14841-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use devm_ioremap_resource and devm_kzalloc to simplify error
> paths and reduce lines of code.

The code looks fine, but you're actually doing a great deal more than
you describe in the commit message. Would you mind expanding?

I.e:

> +		dev_err(&pdev->dev, "Unknown qcom,controller-type\n");

Switching to these 'cos they're more informative.

> -	platform_set_drvdata(pdev, NULL);

Removing these because they're obsolete.

> -	.remove		= ssbi_remove,

Removing this 'cos it no longer does anything useful.

> +module_platform_driver(ssbi_driver);

Moving these because it's more succinct when init() and exit()
routines are baron.

None of the above have anything to do with devm_* managed resources.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
