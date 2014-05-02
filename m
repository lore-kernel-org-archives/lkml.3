Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaEBJxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:53:41 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35413 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaEBJxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:53:40 -0400
Message-ID: <53636B1D.8030405@redhat.com>
Date: Fri, 02 May 2014 11:53:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hu Yaohui <loki2441@gmail.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: KVM Nested L2 guest startup problems
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>
In-Reply-To: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/05/2014 03:43, Hu Yaohui ha scritto:
> Hi all,
> I have a problem running the latest version of kvm with nested configuration.
> I used to run it with kernel 3.2.2 both for L0 and L1, which works perfectly.
> When I change my L0 to kernel 3.10.36, L1 to kernel 3.12.10.
> When I start L2 guest in L1 with qemu-kvm. I get the following error
> from the qemu-kvm.

Try upgrading L0 to a more recent kernel, 3.13 should be enough.

Paolo

> <log>
> KVM: entry failed, hardware error 0x0
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000623
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000e05b EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 000f0000 0000ffff 00009b00
> SS =0000 00000000 0000ffff 00009300
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
> DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000
> Code=00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <2e>
> 66 83 3e 24 d3 00 0f 85 e2 e5 31 c0 8e d0 66 bc 00 70 00 00 66 ba 4c
> 28 0f 00 e9 07 e5
> </log>
>
> In L0, the kernel gives me error like:
> <log>
> [310681.735709] nested_vmx_exit_handled failed vm entry 7
> </log>
>
> I am wondering anyone has met the similar problem.

