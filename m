Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3HFSdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:33:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52442 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3HFSdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:33:03 -0400
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <52014031.7000202@codeaurora.org>
Date: Tue, 6 Aug 2013 13:33:06 -0500
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <633DB2E9-8043-4C38-94EE-1A1FA25722C5@codeaurora.org>
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org> <76477E73-B68A-4025-875E-4BA30F5E175A@codeaurora.org> <52014031.7000202@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 6, 2013, at 1:28 PM, Rohit Vaswani wrote:

> On 8/6/2013 8:47 AM, Kumar Gala wrote:
>> On Aug 5, 2013, at 6:02 PM, Rohit Vaswani wrote:
>> 
>>> This patch adds basic board support for MSM8974 Dragonboard
>>> which belongs to the Snapdragon 800 family.
>>> For now, just support a basic machine with device tree.
>> I think the board is APQ8074 and not MSM8974.
>> 
>>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>>> ---
>>> arch/arm/boot/dts/Makefile        |  3 ++-
>>> arch/arm/boot/dts/msm8974-db.dts  | 26 ++++++++++++++++++++++++++
>>> arch/arm/mach-msm/Kconfig         | 21 ++++++++++++++++++---
>>> arch/arm/mach-msm/Makefile        |  1 +
>>> arch/arm/mach-msm/board-dt-8974.c | 23 +++++++++++++++++++++++
>>> 5 files changed, 70 insertions(+), 4 deletions(-)
>>> create mode 100644 arch/arm/boot/dts/msm8974-db.dts
>>> create mode 100644 arch/arm/mach-msm/board-dt-8974.c
>>> 
>>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>>> index 641b3c9a..62cea36 100644
>>> --- a/arch/arm/boot/dts/Makefile
>>> +++ b/arch/arm/boot/dts/Makefile
>>> @@ -97,7 +97,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
>>> 	kirkwood-openblocks_a6.dtb
>>> dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
>>> dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
>>> -	msm8960-cdp.dtb
>>> +	msm8960-cdp.dtb \
>>> +	msm8974-db.dtb
>>> dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>>> 	armada-370-mirabox.dtb \
>>> 	armada-370-rd.dtb \
>>> diff --git a/arch/arm/boot/dts/msm8974-db.dts b/arch/arm/boot/dts/msm8974-db.dts
>>> new file mode 100644
>>> index 0000000..badfc61
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/msm8974-db.dts
>>> @@ -0,0 +1,26 @@
>>> +/dts-v1/;
>>> +
>>> +/include/ "skeleton.dtsi"
>> We should change msm8974.dts to msm8974.dtsi and include it for the board.
> 
> We can do that once we have something separate/new to add to the dtsi file.

Why wait, we should just do this to start with.  Even if the msm8974-db.dts is just:

/include/ "msm8974.dtsi"

{
	model = "Qualcomm MSM8974 Dragonboard";
	compatible = "qcom,msm8974-db", "qcom,msm8974";
}

Plus, we can do things like "disable" additional cores or such in the board.dts and have the SoC one have all 4 cores, etc in it.

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

