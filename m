Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaK3OOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 09:14:31 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65000 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaK3OOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 09:14:30 -0500
Message-ID: <547B27D0.6020200@gmail.com>
Date: Sun, 30 Nov 2014 22:21:04 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: Marc Zyngier <marc.zyngier@arm.com>, "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: arm: vgic: Let one looping code instead of two looping
 code
References: <547A9A7C.1080508@gmail.com> <20141130100718.GA484@cbox> <547C7570.1020006@gmail.com> <20141130110842.GA83910@macair>
In-Reply-To: <20141130110842.GA83910@macair>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/14 19:08, Christoffer Dall wrote:
> On Mon, Dec 01, 2014 at 10:04:32PM +0800, Chen Gang wrote:
>> On 11/30/2014 06:07 PM, Christoffer Dall wrote:
>>> On Sun, Nov 30, 2014 at 12:18:04PM +0800, Chen Gang wrote:
>>>> Use one looping instead of two, so can let code more simpler and get a
>>>> little better performance.
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>
>>> Performance?  Please, this is vgic_create....
>>>
>>
>> I guess your meaning is "this code is not performance sensitive", do not
>> mean "1 looping can not get a little better performance than 2 looping".
>> If what I guess is incorrect, please let me know.
>>
> 
> I doubt if this is even measureable.  Have you even looked at how this
> compiles?
> 

I did not look at the related assembly code for O2.

But for me, it must be a little better than 2 loops: as far as I know,
the compiler should/can not merge the 2 loops into 1 loop (it will
change logical working flow, at least, need notice about lock/unlock).


>>> This does nothing else than introduce churn.
>>>
>>
>> I don't think it does nothing, it can let code simpler than before:
>> remove the redundant looping -- the 2 looping do the same thing which
>> is commented just above the firstly looping.
> 
> I don't think there's any big benefit here.
> 

Really, no big benefit here.

>>
>> And I don't know which churn this patch will introduce. At least, no one
>> want to waste him/her time resources to intend churn, please provide
>> more details about it.
>>
>> If kvm does not like me, or does not like members to find issues based
>> on reading source code, please let me know (no reply means kvm does not
>> like me or this way), I will quit, so can save time resources both.
>>
> I appreciate your efforts and welcome anybody to contribute to the code
> base.  But you seem to be insisting on changing some insignificant
> details, and we just have bigger fish to fry right now.  Sorry.
> 
> This is not about anyone not liking someone, it is about the code and
> whether there's a need to take this patch right now or not.
> 

OK, thanks. Next, I shall try to find some bugs for it. And they are not
urgent, since they are only found by reading source code.


And could you provide any information or suggestion for kvm common test?
(e.g. "make check" in gcc or qemu). At present, I only let my kvm
related patches pass compiling, not give additional test.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
