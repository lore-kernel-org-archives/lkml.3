Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbbA2Bm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:42:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37649 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002AbbA2Bmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:42:53 -0500
Date: Wed, 28 Jan 2015 11:26:21 -0600
From: Andy Gross <agross@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-soc@vger.kernel.org" <linux-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] soc: qcom: gsbi: Add support for ADM CRCI muxing
Message-ID: <20150128172621.GA17315@qualcomm.com>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
 <1422396644-21714-2-git-send-email-agross@codeaurora.org>
 <20150128031149.GM11960@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128031149.GM11960@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 07:11:50PM -0800, Bjorn Andersson wrote:
> On Tue 27 Jan 14:10 PST 2015, Andy Gross wrote:
> 
> This solution looks good, just some style things.
> 
> > diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
> [..]
> > +#define MAX_GSBI		12
> > +
> > +#define TCSR_ADM_CRCI_BASE	0x70
> > +
> > +struct crci_config {
> > +	u32 num_rows;
> > +	const u32 *array;
> 
> Making this:
>  const u32 (*array)[MAX_GSBI];

ok, i'll switch to do this instead and change the usage down below.

<snip>

> > +			else
> > +				val = 0;
> > +
> > +			regmap_update_bits(gsbi->tcsr,
> > +				TCSR_ADM_CRCI_BASE + 0x4*i,
> > +				config->array[i*MAX_GSBI + gsbi_num - 1], val);
> 
> To me this would be cleaner:
> 
> mask = config->array[i][gsbi_num - 1];
> if (gsbi->mode == GSBI_PRO_SPI)
> 	regmap_update_bits(gsbi->tcsr, TCSR_ADM_CRCI_BASE + i * 4, mask, mask);
> else
> 	regmap_update_bits(gsbi->tcsr, TCSR_ADM_CRCI_BASE + i * 4, mask, 0);

i had considered doing something similar.  It does make it cleaner, so I'll do
this.

> > +		}
> > +
> There should be an extra set of {} around the if statment body.

done


-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

