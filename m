Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3GCBQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:16:05 -0400
Received: from ozlabs.org ([203.10.76.45]:35247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3GCBQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:16:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chegu Vinod <chegu_vinod@hp.com>
Cc: prarit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>, "Hull\, Jim" <jim.hull@hp.com>
Subject: Re: kvm_intel: Could not allocate 42 bytes percpu data
In-Reply-To: <51D3012A.4030306@hp.com>
References: <51C897A7.50302@hp.com> <87ehbisstv.fsf@rustcorp.com.au> <51D22931.1080008@hp.com> <8761wth5ph.fsf@rustcorp.com.au> <51D3012A.4030306@hp.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 03 Jul 2013 10:07:55 +0930
Message-ID: <87hagcfpgc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chegu Vinod <chegu_vinod@hp.com> writes:
> On 7/1/2013 10:49 PM, Rusty Russell wrote:
>> Chegu Vinod <chegu_vinod@hp.com> writes:
>>> On 6/30/2013 11:22 PM, Rusty Russell wrote:
>>>> module: do percpu allocation after uniqueness check.  No, really!
>>>>
>>>> v3.8-rc1-5-g1fb9341 was supposed to stop parallel kvm loads exhausting
>>>> percpu memory on large machines:
>>>>
>>>>       Now we have a new state MODULE_STATE_UNFORMED, we can insert the
>>>>       module into the list (and thus guarantee its uniqueness) before we
>>>>       allocate the per-cpu region.
>>>>
>>>> In my defence, it didn't actually say the patch did this.  Just that
>>>> we "can".
>>>>
>>>> This patch actually *does* it.
>>>>
>>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>>> Tested-by: Noone it seems.
>>> Your following "updated" fix seems to be working fine on the larger
>>> socket count machine with HT-on.
>> OK, did you definitely revert every other workaround?
>
> Yes no other workarounds were there when your change was tested.
>
>>
>> If so, please give me a Tested-by: line...
>
> FYI.... The actual verification of your change was done by my esteemed 
> colleague :Jim Hull (cc'd) who had access to this larger socket count box.
>
>
>
> Tested-by: Jim Hull <jim.hull@hp.com>

Thanks, I've put this in my -next tree, and CC'd stable.

Cheers,
Rusty.
