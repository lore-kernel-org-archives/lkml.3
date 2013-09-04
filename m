Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3IDSMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:12:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53310 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3IDSMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:12:05 -0400
Message-ID: <522777F1.50502@wwwdotorg.org>
Date: Wed, 04 Sep 2013 12:12:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM changes for 3.12
References: <20130903121046.GE22899@redhat.com> <20130904101826.GA2744@ulmo> <20130904103855.GC7402@redhat.com>
In-Reply-To: <20130904103855.GC7402@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 04:38 AM, Gleb Natapov wrote:
> Copying Marek, Aneesh and Alex since this came through PPC kvm tree.
> 
> On Wed, Sep 04, 2013 at 12:18:28PM +0200, Thierry Reding wrote:
>> On Tue, Sep 03, 2013 at 03:10:46PM +0300, Gleb Natapov wrote:
>> [...]
>>> Aneesh Kumar K.V (5):
>>>       mm/cma: Move dma contiguous changes into a seperate config
>>
>> Hi Gleb,
>>
>> This commit is going to cause runtime regressions on various ARM
>> platforms because it renames a symbol but fails to update all default
>> configurations that select the symbol. A quick grep shows that three ARM
>> platforms are affected:
>>
>> 	$ git grep CONFIG_CMA=y
>> 	arch/arm/configs/keystone_defconfig:CONFIG_CMA=y
>> 	arch/arm/configs/omap2plus_defconfig:CONFIG_CMA=y
>> 	arch/arm/configs/tegra_defconfig:CONFIG_CMA=y
>>
>> I've been digging around a bit and it seems like the original patch from
>> Aneesh had the defconfig changes but they were dropped because they "...
>> require separate handling to avoid pointless merge conflicts."[0]
>>
> Marek, that's your words. What do you think about ARM problem?
> 
>> While I can't speak for Keystone or OMAP, at least on Tegra this causes
>> issues because we use CMA for framebuffer allocation. Since we only have
>> CMA selected but not the new DMA_CMA, large DMA allocations will fail.
>>
> Make config suppose to ask you about new option though, does it?

"make oldconfig" quite possibly might, but "make tegra_defconfig"
doesn't, and "make tegra_defconfig; make zImage" is a workflow that has
historically generated a perfectly working kernel for Tegra, and hence
people use that flow.
