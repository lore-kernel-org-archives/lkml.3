Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbaCQRio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:38:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37216 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933027AbaCQRik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:38:40 -0400
Message-ID: <53273309.8060103@zytor.com>
Date: Mon, 17 Mar 2014 10:38:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE
 instructions
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com> <8569d2b4-0593-4f7a-859c-3848670f718d@email.android.com> <5326C0C3.6000105@redhat.com> <fb38ff9d-8c00-4b02-b0da-2db989f7190e@email.android.com> <53272A53.8090605@redhat.com>
In-Reply-To: <53272A53.8090605@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 10:01 AM, Paolo Bonzini wrote:
> the emulator).
> 
> If CS and possibly SS are valid real mode selectors, it should be
> possible to run big real mode at almost-full speed, taking exits only
> for memory accesses via other segment registers.  It is on my todo list,
> but not very high.  Depending on the exit overhead, it may be a better
> idea to revert the emulate_invalid_guest_state default to N and let
> people who care about big real mode specify Y.
> 

I'm not sure what you mean with "valid real mode selectors"; the normal
case in big real mode is that either CS = SS = 0 or CS = SS = <some
program base address>.

As Big Real Mode is part of the spec for certain things (option ROMs, as
we discussed) it probably matters, but especially with the CPUs not
supporting unrestricted mode fading into history I suspect it is fine
for BRM to be slow on those older processors.

The PM transitions that you mentioned are usually only a handful of
instructions and thus can be slow.

	-hpa


