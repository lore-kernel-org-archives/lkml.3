Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaIINku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:40:50 -0400
Received: from mail.univention.de ([82.198.197.8]:1669 "EHLO
	mail.univention.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaIINkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:40:49 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 09:40:48 EDT
Message-ID: <540F01E2.1040806@univention.de>
Date: Tue, 09 Sep 2014 15:34:26 +0200
From: Philipp Hahn <hahn@univention.de>
Organization: Univention GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: KVM: x86: handle idiv overflow at kvm_write_tsc for stable-3.10
References: <5406CE68.8070306@univention.de> <20140903184213.GC5240@amt.cnet>
In-Reply-To: <20140903184213.GC5240@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marcelo,

On 03.09.2014 20:42, Marcelo Tosatti wrote:
> On Wed, Sep 03, 2014 at 10:16:40AM +0200, Philipp Hahn wrote:
>> can we please 8915aa27d5efbb9185357175b0acf884325565f9 get applied to
>> 3.10 too?
>>
>>> commit 8915aa27d5efbb9185357175b0acf884325565f9
>>> Author: Marcelo Tosatti <mtosatti@redhat.com>
>>> Date:   Tue Jun 11 23:31:12 2013 -0300
>>>
>>>     KVM: x86: handle idiv overflow at kvm_write_tsc
>>>
>>>     Its possible that idivl overflows (due to large delta stored in
>> usdiff,
>>>     valid scenario).
>>>
>>>     Create an exception handler to catch the overflow exception
>> (division by zero
>>>     is protected by vcpu->arch.virtual_tsc_khz check), and interpret
>> it accordingly
>>>     (delta is larger than USEC_PER_SEC).
>>>
>>>     Fixes https://bugzilla.redhat.com/show_bug.cgi?id=969644
>>>
>>>     Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>>>     Signed-off-by: Gleb Natapov <gleb@redhat.com>
...
>> Tested-by: Philipp Hahn <hahn@univention.de>
...
> Yes, can you send the patch accordingly to the stable guidelines please?

Maybe I'm to stupid right now, but I find
linux/Documentation/stable_kernel_rules.txt unclear on what I'm supposed
to do:

1. cherry-pick the patch myself?
2. amend the commit message by adding the original commit it
3. where should the name of the stable branch go?
4. amend the commit message by adding myself as a tester? Or do I need
to sign it off?
5. send that patch to <mailto:stable@vger.kernel.org>.

It did seem to have worked, as I never received an acknowledgement nor
is it listed in
<http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git>.
Maybe you can do it and cc: me so I can do it right next time myself.

Thanks.

Philipp
