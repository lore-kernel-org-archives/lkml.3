Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3DVHG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:06:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49076 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab3DVHG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:06:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5174E185.1040806@jp.fujitsu.com>
Date: Mon, 22 Apr 2013 16:06:45 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: wei@aristanetworks.com
CC: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] intel-iommu: Disable DMA Remapping when intel_iommu=off
References: <1366441080-5937-1-git-send-email-wei@aristanetworks.com> <5174CB26.9060908@jp.fujitsu.com> <CANwcMEZF+ehPeFuucRqcKSiNNoXL6bDy+GTHBHYjr3DfoZY7vg@mail.gmail.com>
In-Reply-To: <CANwcMEZF+ehPeFuucRqcKSiNNoXL6bDy+GTHBHYjr3DfoZY7vg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/22 15:50), Wei Hu wrote:
> On Sun, Apr 21, 2013 at 10:31 PM, Takao Indoh
> <indou.takao@jp.fujitsu.com> wrote:
>> (2013/04/20 15:58), Wei Hu wrote:
>>> On a VT-d capable machine Linux will enable IOMMU by default. If it
>>> then kexec's a second kernel with intel_iommu=off, this second kernel
>>> will leave the DMA remapping engine on with no code handling it. The
>>> symptom is at least USB and SATA drives stop working. This patch fixes
>>> the problem by always disabling DMA remapping when intel_iommu=off.
>>
>> Even when second kernel boots up with intel_iommu=on, dma-remapping need
>> to be disabled as well before it is initialized and enabled again in
>> init_dmars(). So, how about something like this?
>>
>>          for_each_drhd_unit(drhd) {
>>                  struct dmar_drhd_unit *drhd;
>>                  if (drhd->ignored)
>>                          continue;
>>
>>                  iommu = drhd->iommu;
>>                  if (iommu->gcmd & DMA_GCMD_TE)
>>                          iommu_disable_translation(iommu);
>>          }
>>
>> Note, if you agree above code and fix your patch like this, you need
>> additinal fix to set iommu->gcmd flag sinse gcmd is always zero here.
>> See first hunk of this patch.
>> https://lkml.org/lkml/2013/3/20/707
> 
> Thanks for your reply. I reviewed your patch. Are you suggesting
> keeping your change to dmar.c, and moving your change to intel-iommu.c
> (i.e. the code you just showed) up after the call to
> dmar_table_init()?
> 
 
Yes, exactly.

Thanks,
Takao Indoh

