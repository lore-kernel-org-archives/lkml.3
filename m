Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaLCMKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:10:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbaLCMKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:10:42 -0500
Message-ID: <547EFDB4.5060709@redhat.com>
Date: Wed, 03 Dec 2014 13:10:28 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH] KVM: cpuid: mask more bits in leaf 0xd and subleaves
References: <1417525770-16485-1-git-send-email-pbonzini@redhat.com> <20141202230536.GA12980@potion.redhat.com> <547EC40E.5010506@redhat.com> <20141203120739.GA26617@potion.brq.redhat.com>
In-Reply-To: <20141203120739.GA26617@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/12/2014 13:07, Radim Krčmář wrote:
>> > Well, there is a WARN just above. :)  But I can change it to zero instead.
> Yeah, I wasn't sure about the WARN ... I can only see it trigger after
> host xcr0 changes and we are much more screwed in that case anyway :)
> (But it has a chance of catching a bug, so it isn't only bad.)
> 
> The guest expects 0 here, so I'd rather have it ...

Ok, I'll have

		if (WARN_ON_ONCE(entry[i].ecx & 1))
			continue;
	}
	entry[i].ecx = 0;
	entry[i].edx = 0;
	...

Thanks for the review!

Paolo
