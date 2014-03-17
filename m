Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbaCQPRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:17:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933452AbaCQPRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:17:06 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5326C0C3.6000105@redhat.com>
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com> <8569d2b4-0593-4f7a-859c-3848670f718d@email.android.com> <5326C0C3.6000105@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE instructions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 17 Mar 2014 08:16:35 -0700
To: Paolo Bonzini <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Message-ID: <fb38ff9d-8c00-4b02-b0da-2db989f7190e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After seeing the sheer number of one-off additions, I'm wondering if going through the opcode map systematically and see what is still missing might not be a bad idea.

On March 17, 2014 2:30:43 AM PDT, Paolo Bonzini <pbonzini@redhat.com> wrote:
>Il 15/03/2014 23:42, H. Peter Anvin ha scritto:
>> Stupid question... what instructions do NOT need emulsion in KVM? It
>would seem that at least anything that touches memory would?
>
>Yes, indeed.  Anything that touches memory can be used on MMIO and then
>
>needs emulation.
>
>Paolo
>
>> On March 15, 2014 1:01:58 PM PDT, Igor Mammedov <imammedo@redhat.com>
>wrote:
>>> MS HCK test fails on 32-bit Windows 8.1 due to missing MOVAPS
>>> instruction emulation, this series adds it and while at it,
>>> it adds emulation of MOVAPD which is trivial to implement on
>>> top of MOVAPS.
>>>
>>> Igor Mammedov (2):
>>>  KVM: x86 emulator: emulate MOVAPS
>>>  KVM: x86 emulator: emulate MOVAPD
>>>
>>> arch/x86/kvm/emulate.c | 8 +++++++-
>>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
