Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3DYJgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:36:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40146 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3DYJf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:35:57 -0400
From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
To: Gleb Natapov <gleb@redhat.com>
CC: Yan Vugenfirer <yvugenfi@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wangrui (K)" <moon.wangrui@huawei.com>,
        Guantao <guantao.guan@huawei.com>,
        Guoxiaodong <guoxiaodong@huawei.com>
Subject: Re: KVM VM(windows xp) reseted when running geekbench for about 2
 days
Thread-Topic: KVM VM(windows xp) reseted when running geekbench for about 2
 days
Thread-Index: Ac48LEpguUL++1wxQxiPGnnKCoktbv//iVQAgAAIdQD//rsf4IACumiA//l0pyCADKDDgP/8TFCA
Date: Thu, 25 Apr 2013 09:35:23 +0000
Message-ID: <D3E216785288A145B7BC975F83A2ED103FE2422A@szxeml556-mbx.china.huawei.com>
References: <D3E216785288A145B7BC975F83A2ED103FE1E7A5@szxeml556-mbx.china.huawei.com>
 <20130418125532.GW8997@redhat.com>
 <9C764699-6F9C-4AD8-A6C9-34D818753452@redhat.com>
 <D3E216785288A145B7BC975F83A2ED103FE1F16A@szxeml556-mbx.china.huawei.com>
 <20130419114242.GK5807@redhat.com>
 <D3E216785288A145B7BC975F83A2ED103FE21AD4@szxeml556-mbx.china.huawei.com>
 <20130423083655.GE12401@redhat.com>
In-Reply-To: <20130423083655.GE12401@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Ha0e Ly4u P1He THnb eJOQ hCNu hyKC kqQk su55 uE0l vv5j
 yJ/P 0ZmU 1olY 26Qv
 4c0Y;6;ZwBsAGUAYgBAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwBrAHYAbQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AcwB0AEAAcgBlAGQAaABhAHQALgBjAG8AbQA7AHEAZQBtAHUALQBkAGUAdgBlAGwAQABuAG8AbgBnAG4AdQAuAG8AcgBnADsAeQB2AHUAZwBlAG4AZgBpAEAAcgBlAGQAaABhAHQALgBjAG8AbQA=;Sosha1_v1;7;{7382C944-E1F0-4567-9F31-C4768BBD7C37};aABhAG8AeQB1AC4AegBoAGEAbgBnAEAAaAB1AGEAdwBlAGkALgBjAG8AbQA=;Thu,
 25 Apr 2013 09:35:11
 GMT;UgBlADoAIABLAFYATQAgAFYATQAoAHcAaQBuAGQAbwB3AHMAIAB4AHAAKQAgAHIAZQBzAGUAdABlAGQAIAB3AGgAZQBuACAAcgB1AG4AbgBpAG4AZwAgAGcAZQBlAGsAYgBlAG4AYwBoACAAZgBvAHIAIABhAGIAbwB1AHQAIAAyACAAZABhAHkAcwA=
x-cr-puzzleid: {7382C944-E1F0-4567-9F31-C4768BBD7C37}
x-originating-ip: [10.135.68.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> >> On Thu, Apr 18, 2013 at 12:00:49PM +0000, Zhanghaoyu (A) wrote:
>> >> >>> I start 10 VMs(windows xp), then running geekbench tool on 
>> >> >>> them, about 2 days, one of them was reset, I found the reset 
>> >> >>> operation is done by int kvm_cpu_exec(CPUArchState *env) {
>> >> >>>    ...
>> >> >>>       switch (run->exit_reason)
>> >> >>>       ...
>> >> >>>        case KVM_EXIT_SHUTDOWN:
>> >> >>>            DPRINTF("shutdown\n");
>> >> >>>            qemu_system_reset_request();
>> >> >>>            ret = EXCP_INTERRUPT;
>> >> >>>            break;
>> >> >>>    ...
>> >> >>> }
>> >> >>> 
>> >> >>> KVM_EXIT_SHUTDOWN exit reason was set previously in triple fault handle handle_triple_fault().
>> >> >>> 
>> >> >> How do you know that reset was done here? This is not the only 
>> >> >> place where qemu_system_reset_request() is called.
>> >> I used gdb to debug QEMU process, and add a breakpoint in 
>> >> qemu_system_reset_request(), when the case occurred, backtrace 
>> >> shown as below,
>> >> (gdb) bt
>> >> #0  qemu_system_reset_request () at vl.c:1964
>> >> #1  0x00007f9ef9dc5991 in kvm_cpu_exec (env=0x7f9efac47100)
>> >>     at /gt/qemu-kvm-1.4/qemu-kvm-1.4/kvm-all.c:1602
>> >> #2  0x00007f9ef9d5b229 in qemu_kvm_cpu_thread_fn (arg=0x7f9efac47100)
>> >>     at /gt/qemu-kvm-1.4/qemu-kvm-1.4/cpus.c:759
>> >> #3  0x00007f9ef898b5f0 in start_thread () from 
>> >> /lib64/libpthread.so.0
>> >> #4  0x00007f9ef86fa84d in clone () from /lib64/libc.so.6
>> >> #5  0x0000000000000000 in ?? ()
>> >> 
>> >> And, I add printk log in all places where KVM_EXIT_SHUTDOWN exit reason is set, only handle_triple_fault() was called.
>> >> >
>> >> >Make sure XP is not set to auto-reset in case of BSOD. 
>> >> No, winxp is not set to auto-reset in case of BSOD. No Winxp event log reported.
>> >> >
>> >> >Best regards,
>> >> >Yan.
>> >> >
>> >> >> 
>> >> >>> What causes the triple fault?
>> >> >>> 
>> >> >> Are you asking what is triple fault or why it happened in your case?
>> >> What I asked is why triple fault happened in my case.
>> >> >> For the former see here: 
>> >> >> http://en.wikipedia.org/wiki/Triple_fault
>> >> >> For the later it is to late to tell after VM reset. You can run 
>> >> >> QEMU with -no-reboot -no-shutdown. VM will pause instead of 
>> >> >> rebooting and then you can examine what is going on.
>> >> Great thanks, I'll run QEMU with -no-reboot -no-shutdown options, if VM paused in my case, what should I examined?
>> >> 
>> >Register state "info registers" in the monitor for each vcpu. Code around the instruction that faulted.
>> 
>> I ran the QEMU with -no-reboot -no-shutdown options, the VM paused 
>> When the case happened, then I info registers in QEMU monitor, shown as below, CS =0008 00000000 ffffffff 00c09b00 DPL =0 CS32 [-RA]
>> SS =0010 00000000 ffffffff 00c09300 DPL =0 DS   [-WA]
>> DS =0023 00000000 ffffffff 00c0f300 DPL =3 DS   [-WA]
>> FS =0030 ffdff000 00001fff 00c09300 DPL =0 DS   [-WA]
>> GS =0000 00000000 ffffffff 00c00000
>> LDT=0000 00000000 ffffffff 00c00000
>> TR =0028 80042000 000020ab 00008b00 DPL=0 TSS32-busy
>> GDT=     8003f000 000003ff
>> IDT=     8003f400 000007ff
>> CR0=8001003b CR2=760d7fe4 CR3=002ec000 CR4=000006f8 
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 
>> DR3=0000000000000000 DR6=00000000ffff0ff0 DR7=0000000000000400 
>> EFER=0000000000000800 FCW=027f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80 
>> FPR0=0000000000000000 0000 FPR1=0000000000000000 0000 
>> FPR2=0000000000000000 0000 FPR3=0000000000000000 0000 
>> FPR4=0000000000000000 0000 FPR5=0000000000000000 0000 
>> FPR6=0000000000000000 0000 FPR7=0000000000000000 0000 
>> XMM00=00000000000000000000000000000000 
>> XMM01=00000000000000000000000000000000
>> XMM02=00000000000000000000000000000000 
>> XMM03=00000000000000000000000000000000
>> XMM04=00000000000000000000000000000000 
>> XMM05=00000000000000000000000000000000
>> XMM06=00000000000000000000000000000000 
>> XMM07=00000000000000000000000000000000
>> 
>> In normal case, info registers in QEMU monitor, shown as below CS 
>> =001b 00000000 ffffffff 00c0fb00 DPL=3 CS32 [-RA]
>> SS =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>> DS =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>> FS =0038 7ffda000 00000fff 0040f300 DPL=3 DS   [-WA]
>> GS =0000 00000000 ffffffff 00000100
>> LDT=0000 00000000 ffffffff 00000000
>> TR =0028 80042000 000020ab 00008b00 DPL=0 TSS32-busy
>> GDT=     8003f000 000003ff
>> IDT=     8003f400 000007ff
>> CR0=80010031 CR2=0167fd20 CR3=0af00220 CR4=000006f8 
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 
>> DR3=0000000000000000 DR6=00000000ffff0ff0 DR7=0000000000000400 
>> EFER=0000000000000800 FCW=027f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
>> FPR0=00a4000000a40a18 d830 FPR1=0012f9c07c90e900 e900 
>> FPR2=7c910202ffffffff 5d40 FPR3=000001e27c903400 f808 
>> FPR4=000005230012f87a 0000 FPR5=000000007c905d40 0001 
>> FPR6=0000000100000000 0000 FPR7=a9dfde0000000000 4018 
>> XMM00=7c917d9a0012f8d4000000007c900000 
>> XMM01=0012f8740012f8740012f87a7c900000
>> XMM02=7c917de97c97b1787c917e3f0012f87a 
>> XMM03=0012fa687c80901a0012f91800006cfd
>> XMM04=7c9102027c9034007c9102087c90e900 
>> XMM05=0000000c7c9000000012f9907c91017b
>> XMM06=00009a40000000000012f8780012f878 
>> XMM07=6365446c745200007c91340500241f18
>> 
>> N.B. in two cases, CS DPL, SS DPL, FS DPL, FPR, XMM, FSW, ST, FTW values are quite distinct.
>> 
> You do not expect registers to be the same each time, don't you? From the quick glance there is nothing unusual about those states. Is VM UP or SMP? If it is SMP you need to do "info register" for all cpus. Switch between them with "cpu index" command. Do "x/i $pc" on each cpu too and when you provide "info register" output do not cut GPR state.

Great thanks for detailed reply.
When triple fault happened, error info reported in QEMU monitor shown as below:
(qemu) KVM internal error. Suberror: 1
emulation failure
EAX=00000002 EBX=00000102 ECX=00040041 EDX=00000000
ESI=bab40120 EDI=00000000 EBP=bacdbcd0 ESP=bacdbca8
EIP=806e6b91 EFL=00010046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
FS =0030 bab40000 00001fff 00c09300 DPL=0 DS   [-WA]
GS =0000 00000000 ffffffff 00c00000
LDT=0000 00000000 ffffffff 00c00000
TR =0028 bab40d70 000020ab 00008b00 DPL=0 TSS32-busy
GDT=     bab44190 000003ff
IDT=     bab44590 000007ff
CR0=8001003b CR2=7c82b7db CR3=0af00260 CR4=000006f8
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000800
Code=?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? <??> ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 
[2013-04-24 19:09:26 CST]qemu: domain is stopped by outside operation

SMP's info registers:
(qemu) cpu 0
(qemu) info registers
EAX=42c4ebc3 EBX=ffdffc70 ECX=ffdffc70 EDX=00000037
ESI=ffdffc50 EDI=8a6be228 EBP=80551450 ESP=80551434
EIP=ba969d3e EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=1
ES =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
FS =0030 ffdff000 00001fff 00c09300 DPL=0 DS   [-WA]
GS =0000 00000000 ffffffff 00c00000
LDT=0000 00000000 ffffffff 00c00000
TR =0028 80042000 000020ab 00008b00 DPL=0 TSS32-busy
GDT=     8003f000 000003ff
IDT=     8003f400 000007ff
CR0=8001003b CR2=760d7fe4 CR3=002ec000 CR4=000006f8
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000800
FCW=027f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000

(qemu) cpu 1
(qemu) info registers
EAX=00c4fed9 EBX=42800000 ECX=bab38c70 EDX=0000b008
ESI=00000037 EDI=8a6be228 EBP=bacd3d50 ESP=bacd3d1c
EIP=806ecf73 EFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
FS =0030 bab38000 00001fff 00c09300 DPL=0 DS   [-WA]
GS =0000 00000000 ffffffff 00c00000
LDT=0000 00000000 ffffffff 00c00000
TR =0028 bab38d70 000020ab 00008b00 DPL=0 TSS32-busy
GDT=     bab3c190 000003ff
IDT=     bab3c590 000007ff
CR0=8001003b CR2=02273b88 CR3=002ec000 CR4=000006f8
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000800
FCW=027f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000

(qemu) cpu 2
(qemu) info registers
EAX=00000002 EBX=00000102 ECX=00040041 EDX=00000000
ESI=bab40120 EDI=00000000 EBP=bacdbcd0 ESP=bacdbca8
EIP=806e6b91 EFL=00010046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
FS =0030 bab40000 00001fff 00c09300 DPL=0 DS   [-WA]
GS =0000 00000000 ffffffff 00c00000
LDT=0000 00000000 ffffffff 00c00000
TR =0028 bab40d70 000020ab 00008b00 DPL=0 TSS32-busy
GDT=     bab44190 000003ff
IDT=     bab44590 000007ff
CR0=8001003b CR2=7c82b7db CR3=0af00260 CR4=000006f8
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000800
FCW=027f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000

(qemu) cpu 3
(qemu) info registers
EAX=42c4ec2f EBX=bab48c70 ECX=bab48c70 EDX=00000037
ESI=bab48c50 EDI=8a6be228 EBP=bace3d50 ESP=bace3d34
EIP=ba969d3e EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=1
ES =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0023 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
FS =0030 bab48000 00001fff 00c09300 DPL=0 DS   [-WA]
GS =0000 00000000 ffffffff 00c00000
LDT=0000 00000000 ffffffff 00c00000
TR =0028 bab48d70 000020ab 00008b00 DPL=0 TSS32-busy
GDT=     bab4c190 000003ff
IDT=     bab4c590 000007ff
CR0=8001003b CR2=0179fd20 CR3=002ec000 CR4=000006f8
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000800
FCW=027f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=00a4000000a408f8 cbe0 FPR1=0012f9c07c90e900 e900
FPR2=7c910202ffffffff 5d40 FPR3=000001e27c903400 f808
FPR4=000005230012f87a 0000 FPR5=000000007c905d40 0001
FPR6=0000000100000000 0000 FPR7=000000010012f7e0 f818
XMM00=40400000404000004040000040400000 XMM01=41300000413000004130000041300000
XMM02=40000000400000004000000040000000 XMM03=0012fa687c80901a0012f91800006cfd
XMM04=7c9102027c9034007c9102087c90e900 XMM05=0000000c7c9000000012f9907c91017b
XMM06=00009a40000000000012f8780012f878 XMM07=6365446c745200007c91340500241f18

>From above, vcpu2's info registers is identical with the error info reported in QEMU moniter.

vcpu2's 'x/20 EIP' info:
(qemu) cpu 2
(qemu) x/20 0x806e6b91
0x00000000806e6b91:  mov    0x806f12e0,%eax
0x00000000806e6b96:  mov    0x806f12e0,%eax
0x00000000806e6b9b:  mov    0x806f12e0,%eax
0x00000000806e6ba0:  mov    0x806f12e0,%eax
0x00000000806e6ba5:  mov    0x806f12e0,%eax
0x00000000806e6baa:  mov    0x806f12e0,%eax
0x00000000806e6baf:  mov    0x806f12e0,%eax
0x00000000806e6bb4:  mov    0x806f12e0,%eax
0x00000000806e6bb9:  mov    0x806f12e0,%eax
0x00000000806e6bbe:  mov    0x806f12e0,%eax
0x00000000806e6bc3:  mov    0x806f12e0,%eax
0x00000000806e6bc8:  mov    0x806f12e0,%eax
0x00000000806e6bcd:  mov    0x806f12e0,%eax
0x00000000806e6bd2:  mov    0x806f12e0,%eax
0x00000000806e6bd7:  mov    0x806f12e0,%eax
0x00000000806e6bdc:  mov    0x806f12e0,%eax
0x00000000806e6be1:  mov    0x806f12e0,%eax
0x00000000806e6be6:  mov    0x806f12e0,%eax
0x00000000806e6beb:  mov    0x806f12e0,%eax
0x00000000806e6bf0:  mov    0x806f12e0,%eax

Other three vcpus's 'x/20 EIP' info:
(qemu) cpu 0
(qemu) x/20 0xba969d3e
0x00000000ba969d3e:  push   $0x0
0x00000000ba969d40:  call   0xba96a464
0x00000000ba969d45:  pop    %ecx
0x00000000ba969d46:  mov    %eax,0x8(%ecx)
0x00000000ba969d49:  mov    %edx,0xc(%ecx)
0x00000000ba969d4c:  xor    %eax,%eax
0x00000000ba969d4e:  ret
0x00000000ba969d4f:  nop
0x00000000ba969d50:  push   %ecx
0x00000000ba969d51:  push   $0x0
0x00000000ba969d53:  call   0xba96a464
0x00000000ba969d58:  mov    (%esp),%ecx
0x00000000ba969d5b:  mov    %eax,(%ecx)
0x00000000ba969d5d:  mov    %edx,0x4(%ecx)
0x00000000ba969d60:  testb  $0x1,0x10(%ecx)
0x00000000ba969d64:  jne    0xba969d8d
0x00000000ba969d66:  mov    0xba96a974,%edx
0x00000000ba969d6c:  test   $0x10000,%edx
0x00000000ba969d72:  jne    0xba969d3c
0x00000000ba969d74:  add    $0x4,%edx

(qemu) cpu 1
(qemu) x/20 0x806ecf73
0x00000000806ecf73:  mov    0x806f12c8,%ecx
0x00000000806ecf79:  mov    %eax,%edx
0x00000000806ecf7b:  xor    %ebx,%edx
0x00000000806ecf7d:  and    %ecx,%edx
0x00000000806ecf7f:  not    %ecx
0x00000000806ecf81:  and    %ecx,%eax
0x00000000806ecf83:  not    %ecx
0x00000000806ecf85:  dec    %ecx
0x00000000806ecf86:  not    %ecx
0x00000000806ecf88:  and    %ecx,%ebx
0x00000000806ecf8a:  or     %ebx,%eax
0x00000000806ecf8c:  add    %edx,%eax
0x00000000806ecf8e:  adc    $0x0,%esi
0x00000000806ecf91:  mov    %esi,%edx
0x00000000806ecf93:  pop    %esi
0x00000000806ecf94:  pop    %ebx
0x00000000806ecf95:  ret
0x00000000806ecf96:  mov    %edi,%edi
0x00000000806ecf98:  push   %esi
0x00000000806ecf99:  mov    0x806f12e0,%eax

(qemu) cpu 3
(qemu) x/20 0xba969d3e
0x00000000ba969d3e:  push   $0x0
0x00000000ba969d40:  call   0xba96a464
0x00000000ba969d45:  pop    %ecx
0x00000000ba969d46:  mov    %eax,0x8(%ecx)
0x00000000ba969d49:  mov    %edx,0xc(%ecx)
0x00000000ba969d4c:  xor    %eax,%eax
0x00000000ba969d4e:  ret
0x00000000ba969d4f:  nop
0x00000000ba969d50:  push   %ecx
0x00000000ba969d51:  push   $0x0
0x00000000ba969d53:  call   0xba96a464
0x00000000ba969d58:  mov    (%esp),%ecx
0x00000000ba969d5b:  mov    %eax,(%ecx)
0x00000000ba969d5d:  mov    %edx,0x4(%ecx)
0x00000000ba969d60:  testb  $0x1,0x10(%ecx)
0x00000000ba969d64:  jne    0xba969d8d
0x00000000ba969d66:  mov    0xba96a974,%edx
0x00000000ba969d6c:  test   $0x10000,%edx
0x00000000ba969d72:  jne    0xba969d3c
0x00000000ba969d74:  add    $0x4,%edx

Thanks,
Zhang Haoyu
