Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaHTA3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:29:49 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57684 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaHTA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:29:42 -0400
Message-ID: <53F3EBEE.1030107@linux.vnet.ibm.com>
Date: Wed, 20 Aug 2014 08:29:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>
CC: Gleb Natapov <gleb@kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com> <53F24A49.2010807@redhat.com> <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com> <CALzav=fNoXeStA6ETDW0tNqyXBxWN0i8N5P-Ht7jtwgS_r7qmw@mail.gmail.com> <53F2C997.6070605@linux.vnet.ibm.com> <53F30AA4.4050803@redhat.com> <53F30FCD.3080109@linux.vnet.ibm.com> <53F312CE.9090004@redhat.com>
In-Reply-To: <53F312CE.9090004@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082000-9574-0000-0000-000000B3E357
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 05:03 PM, Paolo Bonzini wrote:
> Il 19/08/2014 10:50, Xiao Guangrong ha scritto:
>> Okay, what confused me it that it seems that the single line patch
>> is ok to you. :)
> 
> No, it was late and I was confused. :)
> 
>> Now, do we really need to care the case 2? like David said:
>> "Sorry I didn't explain myself very well: Since we can get a single wrong
>> mmio exit no matter what, it has to be handled in userspace. So my point
>> was, it doesn't really help to fix that one very specific way that it can
>> happen, because it can just happen in other ways. (E.g. update memslots
>> occurs after is_noslot_pfn() and before mmio exit)."
>>
>> What's your idea?
>>
>>> I think if you always treat the low bit as zero in mmio sptes, you can 
>>> do that without losing a bit of the generation.
>>
>> What's you did is avoiding cache a invalid generation number into spte, but
>> actually if we can figure it out when we check mmio access, it's ok. Like the
>> updated patch i posted should fix it, that way avoids doubly increase the number.
> 
> Yes.
> 
>> Okay, if you're interested increasing the number doubly, there is the simpler
>> one:
> 
> This wastes a bit in the mmio spte though.  My idea is to increase the
> memslots generation twice, but drop the low bit in the mmio spte.

Yeah, really smart idea. :)

Paolo/David, would you mind making a patch for this (+ the comments in David's
patch)?

Please feel free to add my:
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

