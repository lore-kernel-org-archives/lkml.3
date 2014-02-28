Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaB1W36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:29:58 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:38289 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbaB1W3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:29:55 -0500
Message-ID: <53110DE1.6070204@mm-sol.com>
Date: Sat, 01 Mar 2014 00:29:53 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v9 3/3] mmc: sdhci-msm: Add platform_execute_tunning implementation
References: <1393586675-14628-1-git-send-email-gdjakov@mm-sol.com> <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com> <20140228205119.GJ7308@joshc.qualcomm.com>
In-Reply-To: <20140228205119.GJ7308@joshc.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.02.14, 22:51, Josh Cartwright wrote:
[..]
>> +		sg_init_one(&sg, data_buf, sizeof(data_buf));
>> +		memset(data_buf, 0, sizeof(data_buf));
>> +		mmc_wait_for_req(mmc, &mrq);
>> +
>> +		if (!cmd.error && !data.error &&
>> +		    !memcmp(data_buf, tuning_block_pattern, sizeof(data_buf))) {
> 
> This memcmp is broken, sizeof(data_buf) is likely not what you want,
> maybe you want 'size'?  Same thing for sg_init_one()/memset() above.
> 
> From sparse:
> 
> drivers/mmc/host/sdhci-msm.c: In function â€˜sdhci_msm_execute_tuningâ€™:
> drivers/mmc/host/sdhci-msm.c:461:53: warning: argument to â€˜sizeofâ€™ in â€˜memcmpâ€™ call is the same expression as the first source; did you mean to provide an explicit length? [-Wsizeof-pointer-memaccess]
>        !memcmp(data_buf, tuning_block_pattern, sizeof(data_buf))) {
> 

Nice catch, Josh! Thanks for reviewing!

BR,
Georgi
