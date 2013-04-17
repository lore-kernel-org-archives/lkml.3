Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966179Ab3DQItM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 04:49:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41919 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965971Ab3DQItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 04:49:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <516E61EE.5030607@jp.fujitsu.com>
Date: Wed, 17 Apr 2013 17:48:46 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: joro@8bytes.org
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        tindoh@gmail.com
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
References: <20130326144629.GB2727@8bytes.org> <51527D74.9080209@jp.fujitsu.com> <20130327103122.GK30540@8bytes.org> <51591EEE.60401@jp.fujitsu.com> <20130402140546.GA15687@8bytes.org> <515BD638.8070307@jp.fujitsu.com> <1364977479.28127.15.camel@i7.infradead.org> <20130405110616.GB6858@8bytes.org> <5164EEE6.8000707@jp.fujitsu.com> <516BC19D.4090303@jp.fujitsu.com> <20130415101829.GP6858@8bytes.org>
In-Reply-To: <20130415101829.GP6858@8bytes.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/15 19:18), Joerg Roedel wrote:
> On Mon, Apr 15, 2013 at 06:00:13PM +0900, Takao Indoh wrote:
>> On DMAR initialization during kdump boot, do you guys agree to change
>> order like this?
>>
>> Current order:
>> (1) Disable translation
>> (2) PCI initialization
>> (3) Make pgtable and enable translation.
>>
>> Order I'm proposing:
>> (1) PCI initialization
>> (2) Disable translation
>> (3) Make pgtable and enable translation.
> 
> I think this should work. In fact, translation only needs to be disabled
> while the IOMMU hardware is reprogrammed to the new data structures the
> kdump kernel set up.

Ok, I agree.

> 
>> As Joerg said, if we need to consider the case that kdump kernel is
>> compiled without dma-remapping(CONFIG_INTEL_IOMMU is off?), I can update
>> my patch to handle such a case properly by adding ifdef
>> CONFIG_INTEL_IOMMU.
> 
> Thinking about it, this case is a bit more special. If the kdump kernel
> has no IOMMU driver at all there is also no code to disable it. So
> unless we want to force the kdump kernel to have the driver when the
> first kernel had it, I think we also want some quirk (depending on
> !CONFIG_INTEL_IOMMU) that disables translation at boot.
> 
> I know, its complicated :)

yeah complicated. hmm..., this isn't limited only to iommu case, there
are many problems which are caused by difference of config between first
kernel and second one. So, to make code simple, I think we don't need to
care such a exceptional case. I mean, I think it is a matter of user
and user has to compile second kernel with dma-remapping if user want to
use it in first kernel.

Thanks,
Takao Indoh

