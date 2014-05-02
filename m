Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaEBPR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:17:58 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43624 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEBPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:17:57 -0400
MIME-Version: 1.0
In-Reply-To: <53636B1D.8030405@redhat.com>
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>
	<53636B1D.8030405@redhat.com>
Date: Fri, 2 May 2014 11:17:54 -0400
Message-ID: <CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>
Subject: Re: KVM Nested L2 guest startup problems
From: Hu Yaohui <loki2441@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
I have tried L0 with linux kernel 3.14.2 and L1 with linux kernel 3.14.2
L1 QEMU qemu-1.7.0
L2 QEMU qemu-1.7.0.
I still get the same error when running qemu in L1 guest.
<log>
KVM: entry failed, hardware error 0x0
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000f61
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 ffff0000 0000ffff 00009b00
SS =0000 00000000 0000ffff 00009300
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000
Code=66 83 c8 ff eb 03 66 89 c8 66 5b 66 5e 66 5f 66 5d 66 c3 90 <ea>
5b e0 00 f0 30 36 2f 32 33 2f 39 39 00 fc 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
</log>

In L0 kvm kernel module. the same error:
<log>
May  2 11:09:51 o46 kernel: [37940.019338] kvm: zapping shadow pages
for mmio generation wraparound
May  2 11:12:32 o46 kernel: [38100.616392] nested_vmx_exit_handled
failed vm entry 7
</log>

Thanks,
Yaohui

On Fri, May 2, 2014 at 5:53 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 02/05/2014 03:43, Hu Yaohui ha scritto:
>
>> Hi all,
>> I have a problem running the latest version of kvm with nested
>> configuration.
>> I used to run it with kernel 3.2.2 both for L0 and L1, which works
>> perfectly.
>> When I change my L0 to kernel 3.10.36, L1 to kernel 3.12.10.
>> When I start L2 guest in L1 with qemu-kvm. I get the following error
>> from the qemu-kvm.
>
>
> Try upgrading L0 to a more recent kernel, 3.13 should be enough.
>
> Paolo
>
>
>> <log>
>> KVM: entry failed, hardware error 0x0
>> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000623
>> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
>> EIP=0000e05b EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0000 00000000 0000ffff 00009300
>> CS =f000 000f0000 0000ffff 00009b00
>> SS =0000 00000000 0000ffff 00009300
>> DS =0000 00000000 0000ffff 00009300
>> FS =0000 00000000 0000ffff 00009300
>> GS =0000 00000000 0000ffff 00009300
>> LDT=0000 00000000 0000ffff 00008200
>> TR =0000 00000000 0000ffff 00008b00
>> GDT=     00000000 0000ffff
>> IDT=     00000000 0000ffff
>> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>> DR3=0000000000000000
>> DR6=00000000ffff0ff0 DR7=0000000000000400
>> EFER=0000000000000000
>> Code=00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <2e>
>> 66 83 3e 24 d3 00 0f 85 e2 e5 31 c0 8e d0 66 bc 00 70 00 00 66 ba 4c
>> 28 0f 00 e9 07 e5
>> </log>
>>
>> In L0, the kernel gives me error like:
>> <log>
>> [310681.735709] nested_vmx_exit_handled failed vm entry 7
>> </log>
>>
>> I am wondering anyone has met the similar problem.
>
>
