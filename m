Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaIWRpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:45:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42791 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaIWRp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:45:28 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] ARM: qcom: Fix SCM interface for big-endian kernels
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <5421B0FF.4060307@codeaurora.org>
Date: Tue, 23 Sep 2014 12:45:25 -0500
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D8A10276-E912-4268-AAB8-48A0C8C7E62D@codeaurora.org>
References: <1411425393-5537-1-git-send-email-sboyd@codeaurora.org> <F694D53D-F606-4B35-AED9-9B3927E4E9F1@codeaurora.org> <5421B0FF.4060307@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 23, 2014, at 12:42 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 09/23/14 09:47, Kumar Gala wrote:
>> On Sep 22, 2014, at 5:36 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> 
>>> The secure environment only runs in little-endian mode, so any
>>> buffers shared with the secure environment should have their
>>> contents converted to little-endian. We also mark such elements
>>> with __le32 to allow sparse to catch such problems.
>>> 
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>> drivers/soc/qcom/scm-boot.c |  8 ++++----
>>> drivers/soc/qcom/scm.c      | 34 ++++++++++++++++++----------------
>>> 2 files changed, 22 insertions(+), 20 deletions(-)
>>> 
>>> diff --git a/drivers/soc/qcom/scm-boot.c b/drivers/soc/qcom/scm-boot.c
>>> index 60ff7b482141..3e4d77b371c6 100644
>>> --- a/drivers/soc/qcom/scm-boot.c
>>> +++ b/drivers/soc/qcom/scm-boot.c
>>> @@ -27,12 +27,12 @@
>>> int scm_set_boot_addr(phys_addr_t addr, int flags)
>>> {
>>> 	struct {
>>> -		unsigned int flags;
>>> -		phys_addr_t  addr;
>>> +		__le32 flags;
>>> +		__le32 addr;
>> Hmm, was phys_addr_t wrong here before?  I ask because don’t we support LPAE on some systems?
> 
> Yes it was wrong. It is exactly 32 bits wide.

So we should probably have a patch to fix the interface scm_set_boot_addr() to take a u32 addr instead of a phys_addr_t

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

