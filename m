Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaJAITA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:19:00 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:42020 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbaJAIS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:18:57 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <542BB9C7.2000600@smartplayin.com>
Date: Wed, 01 Oct 2014 13:52:31 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: Archit Taneja <architt@codeaurora.org>, vinod.koul@intel.com,
        galak@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dmaengine: qcom_bam_dma: Generalize BAM register
 offset calculations
References: <1411037575-13153-1-git-send-email-architt@codeaurora.org> <1411965189-24499-1-git-send-email-architt@codeaurora.org> <20140929221406.GE11142@qualcomm.com>
In-Reply-To: <20140929221406.GE11142@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 03:44 AM, Andy Gross wrote:
> On Mon, Sep 29, 2014 at 10:03:07AM +0530, Archit Taneja wrote:
>> The BAM DMA IP comes in different versions. The register offset layout varies
>> among these versions. The layouts depend on which generation/family of SoCs they
>> belong to.
>>
>> The current SoCs(like 8084, 8074) have a layout where the Top level registers
>> come in the beginning of the address range, followed by pipe and event
>> registers. The BAM revision numbers fall above 1.4.0.
>>
>> The older SoCs (like 8064, 8960) have a layout where the pipe registers come
>> first, and the top level come later. These have BAM revision numbers lesser than
>> 1.4.0.
>>
>> It isn't suitable to have macros provide the register offsets with the layouts
>> changed. Future BAM revisions may have different register layouts too. The
>> register addresses are now calculated by referring a table which contains a base
>> offset and multipliers for pipe/evnt/ee registers.
>>
>> We have a common function bam_addr() which computes addresses for all the
>> registers. When computing address of top level/ee registers, we pass 0 to the
>> pipe argument in addr() since they don't have any multiple instances.
>>
>> Some of the unused register definitions are removed. We can add new registers as
>> we need them.
> 
> Vinod,
> 
> These changes replace the patch set I had that implemented support for the
> v.1.3.0 register set.

Andy,
With your change "dmaengine: qcom_bam_dma: Add v1.3.0 driver support"
and enabling qcom_bam_dma driver i was seeing some crashes in the kernel
on IFC6410. But after reverting you change and applying these changes
from Vinod I see IFC6410 booting fine.

Here are the crash logs in case it helps and if your changes are still
planned by you for upstream.

http://paste.ubuntu.com/8471405/

Thanks
Pramod
> 
> 
