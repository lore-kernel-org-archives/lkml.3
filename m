Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3IXJ5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:57:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50331 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab3IXJ5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:57:03 -0400
Message-ID: <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
In-Reply-To: <20130923162856.GC7264@otherpad.lan.raisama.net>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
    <1379861095-628-2-git-send-email-bp@alien8.de>
    <20130923162856.GC7264@otherpad.lan.raisama.net>
Date: Tue, 24 Sep 2013 11:57:00 +0200 (CEST)
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
From: "Borislav Petkov" <bp@alien8.de>
To: "Eduardo Habkost" <ehabkost@redhat.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "LKML" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Gleb Natapov" <gleb@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Andre Przywara" <andre@andrep.de>, "Joerg Roedel" <joro@8bytes.org>,
        "X86 ML" <x86@kernel.org>, "KVM" <kvm@vger.kernel.org>,
        qemu-devel@nongnu.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, September 23, 2013 6:28 pm, Eduardo Habkost wrote:
> On Sun, Sep 22, 2013 at 04:44:50PM +0200, Borislav Petkov wrote:
>> From: Borislav Petkov <bp@suse.de>
>>
>> Add a kvm ioctl which states which system functionality kvm emulates.
>> The format used is that of CPUID and we return the corresponding CPUID
>> bits set for which we do emulate functionality.
>
> Let me check if I understood the purpose of the new ioctl correctly: the
> only reason for GET_EMULATED_CPUID to exist is to allow userspace to
> differentiate features that are native or that are emulated efficiently
> (GET_SUPPORTED_CPUID) and features that are emulated not very
> efficiently (GET_EMULATED_CPUID)?

Not only that - emulated features are not reported in CPUID so they
can be enabled only when specifically and explicitly requested, i.e.
"+movbe". Basically, you want to emulate that feature for the guest but
only for this specific guest - the others shouldn't see it.

> If that's the case, how do we decide how efficient emulation should be,
> to deserve inclusion in GET_SUPPORTED_CPUID? I am guessing that the
> criterion will be: if enabling it doesn't risk making performance worse,
> it can get in GET_SUPPORTED_CPUID.

Well, in the MOVBE case, supported means, the host can execute this
instruction natively. Now, you guys say you can emulate x2apic very
efficiently and I'm guessing emulating x2apic doesn't bring any
emulation overhead, thus SUPPORTED_CPUID.

But for single instructions or group of instructions, the distinction
should be very clear.

At least this is how I see it but Gleb probably can comment too.

Thanks.

-- 
Regards/Gruss,
Boris.

