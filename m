Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaHSFTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:19:16 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37760 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaHSFTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:19:14 -0400
Message-ID: <53F2DE4B.4060708@linux.vnet.ibm.com>
Date: Tue, 19 Aug 2014 13:19:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Matlack <dmatlack@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Avi Kivity <avi.kivity@gmail.com>, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com> <53F24A49.2010807@redhat.com> <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com> <CALzav=fNoXeStA6ETDW0tNqyXBxWN0i8N5P-Ht7jtwgS_r7qmw@mail.gmail.com> <53F2C997.6070605@linux.vnet.ibm.com> <CALzav=fceJouxxJW-m0h2OtqjeNJWfDMFpiJw5zTndbybRACpg@mail.gmail.com> <53F2D567.70700@linux.vnet.ibm.com> <CALzav=eXu8VmPpqSYikY5y5QqivJ_FD0N2bGTUPnAesJ2PvW1w@mail.gmail.com>
In-Reply-To: <CALzav=eXu8VmPpqSYikY5y5QqivJ_FD0N2bGTUPnAesJ2PvW1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081905-8256-0000-0000-000000D2B2C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 01:00 PM, David Matlack wrote:
> On Mon, Aug 18, 2014 at 9:41 PM, Xiao Guangrong
> <xiaoguangrong@linux.vnet.ibm.com> wrote:
>> On 08/19/2014 12:31 PM, David Matlack wrote:
>>> But it looks like you basically said the same thing earlier, so I think
>>> we're on the same page.
>>>
>>
>> Yes, that is what i try to explain in previous mails. :(
> 
> I'm glad we understand each other now! Sorry again for my confusion.

Yup, me too. :)

> 
>>> The single line patch I suggested was only intended to fix the "forever
>>> incorrectly exit mmio".
>>
>> My patch also fixes this case and that does not doubly increase the
>> number. I think this is the better one.
> 
> I prefer doubly increasing the generation for this reason: the updated boolean
> requires extra code on the "client-side" to check if there's an update in
> progress. And that makes it easy to get wrong. In fact, your patch
> forgot to check the updated bit in mark_mmio_spte(). Doubly increasing the
> generation requires no "client-side" code to work.

No, the updated patch is used to fix case 2 which i draw the scenario in
the last mail. I mean the original patch in this patchset which just
increase the number after srcu-sync.

Then could you tell me that your approach can do but my original patch can not?

