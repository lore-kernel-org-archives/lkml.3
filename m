Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaI3OO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:14:59 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15277 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbaI3OO5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:14:57 -0400
Date: Tue, 30 Sep 2014 07:15:06 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
CC: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [RFC 4/7] soc: qcom: Add Shared Memory Manager driver
Message-ID: <20140930141505.GJ28481@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-5-git-send-email-bjorn.andersson@sonymobile.com>
 <542A4AEF.2030402@smartplayin.com>
 <542A4D80.60101@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <542A4D80.60101@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29 Sep 23:28 PDT 2014, Kiran Padwal wrote:

> 
> Hi,
> 
> On Tuesday 30 September 2014 11:47 AM, Kiran Padwal wrote:
> > Hi Bjorn,
> > 
> > On Tuesday 30 September 2014 06:04 AM, Bjorn Andersson wrote:
[..]
> >> +	smem->hwlock = of_hwspin_lock_request(pdev->dev.of_node, NULL);
> > 
> > Compilation breaks while I try to compile with this patch.
> > Do I missing anything? Below is the error I am getting,
> > 
> > drivers/soc/qcom/qcom_smem.c: In function ‘qcom_smem_probe’:
> > drivers/soc/qcom/qcom_smem.c:274:2: error: implicit declaration of function ‘of_hwspin_lock_request’ [-Werror=implicit-function-declaration]
> >   smem->hwlock = of_hwspin_lock_request(pdev->dev.of_node, NULL)
> 
> I am sorry I missed the note in commit message of this patch. I did look for any such note in cover letter 
> and also googled around for any change to find this function.
> Could not find and hence posted comment. Please ignore.
> 

I respun this ontop of Suman Anna's latest hwspinlock patches [1] and [2].

The above code should now be:

        hwlock_id = of_hwspin_lock_get_id(pdev->dev.of_node, 0);
	smem->hwlock = hwspin_lock_request_specific(hwlock_id);

Will include this in the next spin.

[1] https://patchwork.kernel.org/patch/4898051/
[2] https://patchwork.kernel.org/patch/4898071/

Regards,
Bjorn
