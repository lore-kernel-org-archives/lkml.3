Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3DJEsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 00:48:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32818 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3DJEr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 00:47:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5164EEE6.8000707@jp.fujitsu.com>
Date: Wed, 10 Apr 2013 13:47:34 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: joro@8bytes.org, dwmw2@infradead.org
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, tindoh@gmail.com
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com> <20130326144629.GB2727@8bytes.org> <51527D74.9080209@jp.fujitsu.com> <20130327103122.GK30540@8bytes.org> <51591EEE.60401@jp.fujitsu.com> <20130402140546.GA15687@8bytes.org> <515BD638.8070307@jp.fujitsu.com> <1364977479.28127.15.camel@i7.infradead.org> <20130405110616.GB6858@8bytes.org>
In-Reply-To: <20130405110616.GB6858@8bytes.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/05 20:06), Joerg Roedel wrote:
> On Wed, Apr 03, 2013 at 09:24:39AM +0100, David Woodhouse wrote:
>> On Wed, 2013-04-03 at 16:11 +0900, Takao Indoh wrote:
>>> Yeah, you are right. I forgot such a case.
>>
>> If you disable translation and there's some device still doing DMA, it's
>> going to scribble over random areas of memory. You really want to have
>> translation enabled and all the page tables *cleared*, during kexec. I
>> think it's fair to insist that the secondary kernel should use the IOMMU
>> if the first one did.
> 
> Do we really need to insist on that? The IOMMU initialization on x86
> happens after the kernel scanned and enumerated the PCI bus. While doing
> this the kernel (at least it should) disables all devices it finds. So
> when the IOMMU init code runs we should be safe from any in-flight DMA
> and can either disable translation or re-initialize it for the kdump
> kernel. Until then translation needs to stay enabled of course, so that
> the old page-tables are still used and in-flight DMA doesn't corrupt
> any data.

So we should do in this order, right?
(1) PCI initialization. Stop all ongoing DMA here.
(2) Disable translation if already enable.
(3) Make pgtable and enable translation.

Thanks,
Takao Indoh

