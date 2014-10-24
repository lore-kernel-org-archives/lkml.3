Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaJXW0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:26:33 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:65208 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaJXW0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:26:31 -0400
MIME-Version: 1.0
In-Reply-To: <544ACAA3.7090203@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
 <1414163245-18555-9-git-send-email-pbonzini@redhat.com> <544A9320.6010102@amacapital.net>
 <544ACAA3.7090203@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Oct 2014 15:26:10 -0700
Message-ID: <CALCETrVYMNH8CKDTL7DChrLyNHegm3sCGVaZr9eSY5WGjoh9dg@mail.gmail.com>
Subject: Re: [PATCH 08/14] kvm: x86: don't kill guest on unknown exit reason
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 2:54 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 10/24/2014 07:57 PM, Andy Lutomirski wrote:
>> > KVM_EXIT_UNKNOWN is a kvm bug, we don't really know whether it was
>> > triggered by a priveledged application.  Let's not kill the guest: WARN
>> > and inject #UD instead.
>>
>> This scares me a bit.  For guest CPL3, it's probably okay.  For guest
>> CPL0, on the other hand, #UD might not use IST (or a task switch on
>> 32-bit guests), resulting in possible corruption if unprivileged code
>> controls SP.  Admittedly, there aren't that many contexts from which
>> that should happen (on Linux, at least), but something like #DF (or even
>> a triple fault) might be safer if the guest is at CPL0 when this happens.
>
> This in practice will only happen for VMX instructions (INVVPID in this
> patch set, INVEPT on some older kernels); all other intercepts can be
> turned on or off at will.
>
> For unknown exits we will not have exposed those instructions in the VMX
> capabilities (or perhaps we will not have exposed VMX at all in CPUID on
> the older kernels).  So #UD is the right thing to do.
>

Fair enough.

--Andy
