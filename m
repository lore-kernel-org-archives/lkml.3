Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaEESlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:41:55 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60265 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaEESlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:41:53 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 May 2014 11:41:32 -0700
Message-ID: <CALCETrX+J643i-YPjATo-u6O+_MgZm_v9x-VBp5WmFm-1g0Twg@mail.gmail.com>
Subject: x86_64 allyesconfig has screwed up voffset and blows up KVM
To: X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing 39bfe90706ab0f588db7cb4d1c0e6d1181e1d2f9.  I'm not sure
what's going on here.

voffset.h contains:

#define VO__end 0xffffffff8111c7a0
#define VO__end 0xffffffff8db9a000
#define VO__text 0xffffffff81000000

because

$ nm vmlinux|grep ' _end'
ffffffff8111c7a0 t _end
ffffffff8db9a000 B _end


Booting the resulting image says:

KVM internal error. Suberror: 1
emulation failure
EAX=80000001 EBX=00000000 ECX=c0000080 EDX=00000000
ESI=00014630 EDI=0b08f000 EBP=00100000 ESP=038f14b8
EIP=00100119 EFL=00010046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0018 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
CS =0010 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0018 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0018 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
FS =0018 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
GS =0018 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
LDT=0000 00000000 ffffffff 00c00000
TR =0020 00000000 00000fff 00808b00 DPL=0 TSS64-busy
GDT=     00000000038e5320 00000030
IDT=     0000000000000000 00000000
CR0=80000011 CR2=0000000000000000 CR3=000000000b089000 CR4=00000020
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000500
Code=?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? <??>
?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??
?? ?? ?? ?? ?? ??

Linus's tree from today doesn't seem any better.
