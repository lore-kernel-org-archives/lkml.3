Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3DRIYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:24:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64560 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3DRIYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:24:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,499,1363158000"; 
   d="scan'208";a="39485801"
Message-ID: <4f618017941695cac811fc9c960874c4.squirrel@www.codeaurora.org>
In-Reply-To: <1366024056-8429-1-git-send-email-draviv@codeaurora.org>
References: <1366024056-8429-1-git-send-email-draviv@codeaurora.org>
Date: Thu, 18 Apr 2013 01:24:14 -0700
Subject: Re: [PATCH V2] scsi: ufs: add support for query requests
From: "Dolev Raviv" <draviv@codeaurora.org>
To: "Dolev Raviv" <draviv@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Dolev Raviv" <draviv@codeaurora.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

A minor bug was spotted, as shown blow. The fix will be submitted with the
next version.

> +static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp)
> +{
> +	u32 upiu_flags;
> +	int ret = 0;
> +
> +	if (!lrbp) {
> +		dev_err(hba->dev, "%s: lrbp can not be NULL\n", __func__);
> +		ret = -EINVAL;
> +	} else if (!lrbp->ucd_req_ptr) {
> +		dev_err(hba->dev, "%s: ucd_req_ptr can not be NULL\n",
> +			__func__);
> +		ret = -EINVAL;
> +	} else if (!lrbp->utr_descriptor_ptr) {
> +		dev_err(hba->dev, "%s: utr_descriptor_ptr can not be NULL\n",
> +			__func__);
> +		ret = -EINVAL;
> +	}
> +	if (!ret)
> +		goto exit;
should be:
if (ret)

Thanks,
Dolev

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


