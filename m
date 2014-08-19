Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaHSFA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:00:57 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56540 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaHSFAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:00:55 -0400
MIME-Version: 1.0
In-Reply-To: <53F2D567.70700@linux.vnet.ibm.com>
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com>
 <53F24A49.2010807@redhat.com> <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com>
 <CALzav=fNoXeStA6ETDW0tNqyXBxWN0i8N5P-Ht7jtwgS_r7qmw@mail.gmail.com>
 <53F2C997.6070605@linux.vnet.ibm.com> <CALzav=fceJouxxJW-m0h2OtqjeNJWfDMFpiJw5zTndbybRACpg@mail.gmail.com>
 <53F2D567.70700@linux.vnet.ibm.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 18 Aug 2014 22:00:33 -0700
Message-ID: <CALzav=eXu8VmPpqSYikY5y5QqivJ_FD0N2bGTUPnAesJ2PvW1w@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Avi Kivity <avi.kivity@gmail.com>, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 9:41 PM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
> On 08/19/2014 12:31 PM, David Matlack wrote:
>> But it looks like you basically said the same thing earlier, so I think
>> we're on the same page.
>>
>
> Yes, that is what i try to explain in previous mails. :(

I'm glad we understand each other now! Sorry again for my confusion.

>> The single line patch I suggested was only intended to fix the "forever
>> incorrectly exit mmio".
>
> My patch also fixes this case and that does not doubly increase the
> number. I think this is the better one.

I prefer doubly increasing the generation for this reason: the updated boolean
requires extra code on the "client-side" to check if there's an update in
progress. And that makes it easy to get wrong. In fact, your patch
forgot to check the updated bit in mark_mmio_spte(). Doubly increasing the
generation requires no "client-side" code to work.
