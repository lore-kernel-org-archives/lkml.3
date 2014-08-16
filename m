Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaHPRde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 13:33:34 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38485 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaHPRdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 13:33:31 -0400
Date: Sat, 16 Aug 2014 20:33:25 +0300
From: Dan Aloni <dan@kernelim.com>
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, santoshsy@gmail.com,
        linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org,
        noag@codeaurora.org, draviv@codeaurora.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3] scsi: ufs-msm: add UFS controller support for
 Qualcomm MSM chips
Message-ID: <20140816173325.GA3961@gmail.com>
References: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 05:22:18PM +0300, Yaniv Gardi wrote:
> diff --git a/drivers/scsi/ufs/ufs-msm.h b/drivers/scsi/ufs/ufs-msm.h
> new file mode 100644
> index 0000000..6e93f1e
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-msm.h
> @@ -0,0 +1,158 @@
[...]
> +};
> +
> +static LIST_HEAD(phy_list);
> +

Just noticed this via a quick glance - Seems that this variable is not
referenced by any of the compilation units, what's the purpose of it?
And as a static global in a shared private, each of the including
compilation units gets a copy, which I am not sure was intended
anyway.

-- 
Dan Aloni
