Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab3IFKpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:45:38 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47738 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3IFKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:45:36 -0400
Message-ID: <5229B248.7030002@ozlabs.ru>
Date: Fri, 06 Sep 2013 20:45:28 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v9 12/13] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1377679070-3515-1-git-send-email-aik@ozlabs.ru> <1377679841-3822-1-git-send-email-aik@ozlabs.ru> <20130901120609.GJ22899@redhat.com> <52240295.7050608@ozlabs.ru> <20130903105315.GY22899@redhat.com> <1378353909.4321.126.camel@pasglop> <20130906065715.GG13021@redhat.com>
In-Reply-To: <20130906065715.GG13021@redhat.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 04:57 PM, Gleb Natapov wrote:
> On Thu, Sep 05, 2013 at 02:05:09PM +1000, Benjamin Herrenschmidt wrote:
>> On Tue, 2013-09-03 at 13:53 +0300, Gleb Natapov wrote:
>>>> Or supporting all IOMMU links (and leaving emulated stuff as is) in on
>>>> "device" is the last thing I have to do and then you'll ack the patch?
>>>>
>>> I am concerned more about API here. Internal implementation details I
>>> leave to powerpc experts :)
>>
>> So Gleb, I want to step in for a bit here.
>>
>> While I understand that the new KVM device API is all nice and shiny and that this
>> whole thing should probably have been KVM devices in the first place (had they
>> existed or had we been told back then), the point is, the API for handling
>> HW IOMMUs that Alexey is trying to add is an extension of an existing mechanism
>> used for emulated IOMMUs.
>>
>> The internal data structure is shared, and fundamentally, by forcing him to
>> use that new KVM device for the "new stuff", we create a oddball API with
>> an ioctl for one type of iommu and a KVM device for the other, which makes
>> the implementation a complete mess in the kernel (and you should care :-)
>>
> Is it unfixable mess? Even if Alexey will do what you suggested earlier?
> 
>   - Convert *both* existing TCE objects to the new
>       KVM_CREATE_DEVICE, and have some backward compat code for the old one.
> 
> The point is implementation usually can be changed, but for API it is
> much harder to do so.
> 
>> So for something completely new, I would tend to agree with you. However, I
>> still think that for this specific case, we should just plonk-in the original
>> ioctl proposed by Alexey and be done with it.
>>
> Do you think this is the last extension to IOMMU code, or we will see
> more and will use same justification to continue adding ioctls?


Ok. I give up :) I implemented KVM device the way you suggested. Could you
please have a look? It is "[PATCH v10 12/13] KVM: PPC: Add support for
IOMMU in-kernel handling", attached to this thread. Thanks!



-- 
Alexey
