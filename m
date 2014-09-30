Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaI3NuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:50:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaI3Nt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:49:58 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC 0/7] Qualcomm SMEM, SMD, RPM and regulators
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 30 Sep 2014 08:49:52 -0500
Cc: Andy Gross <agross@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E6EEBBAE-C710-4280-824D-CC5D54CB2551@codeaurora.org>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
To: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 29, 2014, at 7:34 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:

> All Qualcomm platforms implements a shared heap among the processors in the
> SoC, used for sharing data with other parts of the system.
> 
> One consumer of items from this heap is the "Shared Memory Driver", a ring
> buffer based point-to-point communication mechanism used to send either stream
> or packet based data to remote processors.
> 
> Starting with 8x74 this system is used to talk to the Resource Power Manager
> (RPM), a power efficient "coprocessor" with responsibility of aggregate votes
> from the various systems in the SoC related to regulators, clocks and bus
> frequencies.
> 
> The PMIC regulators and root clocks in these platforms are only accessible via
> the RPM, so to get access to these we need the full chain of smem, smd, rpm and
> a regulator driver implemented. And that is exactly what this series provides.
> 
> 
> A key outstanding question is where in the tree we should put the
> implementation, for now I dropped them in drivers/soc/qcom but that's only
> because I don't know where to put it otherwise. I have not found any equivalent
> of the SMEM driver, SMD resembles mailbox and rpmsg - but comments in that
> patch on why it's neither.
> 
> RPM is a mfd and regulator is a regulator :)

I still don’t see why RPM support for either A-family or B-family should exist in MFD vis drivers/soc/qcom.  What benefit is there in putting this in MFD?

I think both A and B-family support should be in drivers/soc/qcom for the current time being until we determine there is some framework that makes more sense in the future.  I almost see RPM more like a bus controller than anything else.  Something like an I2C bus controller that than has some set of devices off of that bus.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

