Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbbAVPc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:32:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbbAVPcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:32:52 -0500
Message-ID: <54C11815.8070501@redhat.com>
Date: Thu, 22 Jan 2015 16:32:37 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mario Smarduch <m.smarduch@samsung.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: KVM: HAVE_KVM_ARCH_DIRTY_LOG_PROTECT?
References: <1421918381.13638.43.camel@x220> <54C101B9.1050804@redhat.com> <1421938175.13638.58.camel@x220>
In-Reply-To: <1421938175.13638.58.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/01/2015 15:49, Paul Bolle wrote:
>> > Ah, there are two Kconfig symbols added by mistake.
>> > 
>> > +config HAVE_KVM_ARCH_DIRTY_LOG_PROTECT
>> > + bool
>> > +
>> > +config KVM_GENERIC_DIRTYLOG_READ_PROTECT
>> > + bool
> This one is actually used (so my 800 line perl monster didn't bark):
>     $ git grep -n KVM_GENERIC_DIRTYLOG_READ_PROTECT next-20150122
>     next-20150122:arch/arm/kvm/Kconfig:27:  select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>     next-20150122:arch/arm64/kvm/Kconfig:30:        select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>     next-20150122:arch/x86/kvm/Kconfig:42:  select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>     next-20150122:virt/kvm/Kconfig:47:config KVM_GENERIC_DIRTYLOG_READ_PROTECT
>     next-20150122:virt/kvm/kvm_main.c:998:#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> 

Yes, the mistake is adding two symbols instead of one. :)

Paolo
