Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaGAUnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:43:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:58427 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752100AbaGAUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:43:17 -0400
Date: Tue, 1 Jul 2014 16:43:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max =
 13)
Message-ID: <20140701164310.34841e1d@gandalf.local.home>
In-Reply-To: <CALCETrUJUvhGN3hrECf9A=vHkHSNqZ2KtMyDnmrhb-uTpgP6Nw@mail.gmail.com>
References: <20140701000913.5ea51f77@gandalf.local.home>
	<CALCETrUJUvhGN3hrECf9A=vHkHSNqZ2KtMyDnmrhb-uTpgP6Nw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 22:09:18 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

> 
> for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done
> 
> after a failed build?
> 
> Let the game of section whack-a-mole begin.

As this is just a compile failure, I can work on this even while it
builds for my test boxes.

Here's the result after a build:

arch/x86/vdso/vdso32-int80.so.dbg
There are 27 section headers, starting at offset 0x2f9c:

Section Headers:
[Nr] Name                 Type         Addr     Off    Size   ES Flags Lk Inf Al
[ 0]                      NULL         00000000 000000 000000  0        0   0  0
[ 1] .hash                HASH         000000b4 0000b4 000038  4 A      2   0  4
[ 2] .dynsym              DYNSYM       000000ec 0000ec 000090 16 A      3   1  4
[ 3] .dynstr              STRTAB       0000017c 00017c 000095  0 A      0   0  1
[ 4] .gnu.version         GNU_versym   00000212 000212 000012  2 A      2   0  2
[ 5] .gnu.version_d       GNU_verdef   00000224 000224 000054  0 A      3   3  4
[ 6] .dynamic             DYNAMIC      00000278 000278 000080  8 WA     3   0  4
[ 7] .rodata              PROGBITS     000002f8 0002f8 000228  4 WA     0   0  4
[ 8] .fake_shstrtab       PROGBITS     00000520 000520 000076  0 A      0   0  4
[ 9] .note                NOTE         00000598 000598 00003c  0 A      0   0  4
[10] .eh_frame_hdr        PROGBITS     000005d4 0005d4 000024  0 A      0   0  4
[11] .eh_frame            PROGBITS     000005f8 0005f8 0000f4  0 A      0   0  4
[12] .text                PROGBITS     000006f0 0006f0 000373  0 AX     0   0 16
[13] .altinstructions     PROGBITS     00000a63 000a63 000018  0 A      0   0  1
[14] .altinstr_replacement PROGBITS     00000a7b 000a7b 000006  0 AX     0   0  1
[15] .debug_info          PROGBITS     00000000 000a81 001161  0        0   0  1
[16] .debug_abbrev        PROGBITS     00000000 001be2 0002b7  0        0   0  1
[17] .debug_loc           PROGBITS     00000000 001e99 0000e0  0        0   0  1
[18] .debug_aranges       PROGBITS     00000000 001f80 000040  0        0   0  8
[19] .debug_ranges        PROGBITS     00000000 001fc0 000060  0        0   0  1
[20] .debug_line          PROGBITS     00000000 002020 000633  0        0   0  1
[21] .debug_str           PROGBITS     00000000 002653 000733  1 MS     0   0  1
[22] .comment             PROGBITS     00000000 002d86 000011  1 MS     0   0  1
[23] .debug_frame         PROGBITS     00000000 002d98 0000dc  0        0   0  4
[24] .shstrtab            STRTAB       00000000 002e74 000127  0        0   0  1
[25] .symtab              SYMTAB       00000000 0033d4 000340 16       26  44  4
[26] .strtab              STRTAB       00000000 003714 0001e3  0        0   0  1

arch/x86/vdso/vdso32-syscall.so.dbg
There are 27 section headers, starting at offset 0x2fac:

Section Headers:
[Nr] Name                 Type         Addr     Off    Size   ES Flags Lk Inf Al
[ 0]                      NULL         00000000 000000 000000  0        0   0  0
[ 1] .hash                HASH         000000b4 0000b4 000038  4 A      2   0  4
[ 2] .dynsym              DYNSYM       000000ec 0000ec 000090 16 A      3   1  4
[ 3] .dynstr              STRTAB       0000017c 00017c 000095  0 A      0   0  1
[ 4] .gnu.version         GNU_versym   00000212 000212 000012  2 A      2   0  2
[ 5] .gnu.version_d       GNU_verdef   00000224 000224 000054  0 A      3   3  4
[ 6] .dynamic             DYNAMIC      00000278 000278 000080  8 WA     3   0  4
[ 7] .rodata              PROGBITS     000002f8 0002f8 000220  4 WA     0   0  4
[ 8] .fake_shstrtab       PROGBITS     00000518 000518 000076  0 A      0   0  4
[ 9] .note                NOTE         00000590 000590 00003c  0 A      0   0  4
[10] .eh_frame_hdr        PROGBITS     000005cc 0005cc 000024  0 A      0   0  4
[11] .eh_frame            PROGBITS     000005f0 0005f0 0000fc  0 A      0   0  4
[12] .text                PROGBITS     000006f0 0006f0 000380  0 AX     0   0 16
[13] .altinstructions     PROGBITS     00000a70 000a70 000018  0 A      0   0  1
[14] .altinstr_replacement PROGBITS     00000a88 000a88 000006  0 AX     0   0  1
[15] .debug_info          PROGBITS     00000000 000a8e 001161  0        0   0  1
[16] .debug_abbrev        PROGBITS     00000000 001bef 0002b7  0        0   0  1
[17] .debug_loc           PROGBITS     00000000 001ea6 0000e0  0        0   0  1
[18] .debug_aranges       PROGBITS     00000000 001f88 000040  0        0   0  8
[19] .debug_ranges        PROGBITS     00000000 001fc8 000060  0        0   0  1
[20] .debug_line          PROGBITS     00000000 002028 00063b  0        0   0  1
[21] .debug_str           PROGBITS     00000000 002663 000733  1 MS     0   0  1
[22] .comment             PROGBITS     00000000 002d96 000011  1 MS     0   0  1
[23] .debug_frame         PROGBITS     00000000 002da8 0000dc  0        0   0  4
[24] .shstrtab            STRTAB       00000000 002e84 000127  0        0   0  1
[25] .symtab              SYMTAB       00000000 0033e4 000340 16       26  44  4
[26] .strtab              STRTAB       00000000 003724 0001e3  0        0   0  1

arch/x86/vdso/vdso32-sysenter.so.dbg
There are 27 section headers, starting at offset 0x2fb4:

Section Headers:
[Nr] Name                 Type         Addr     Off    Size   ES Flags Lk Inf Al
[ 0]                      NULL         00000000 000000 000000  0        0   0  0
[ 1] .hash                HASH         000000b4 0000b4 000038  4 A      2   0  4
[ 2] .dynsym              DYNSYM       000000ec 0000ec 000090 16 A      3   1  4
[ 3] .dynstr              STRTAB       0000017c 00017c 000095  0 A      0   0  1
[ 4] .gnu.version         GNU_versym   00000212 000212 000012  2 A      2   0  2
[ 5] .gnu.version_d       GNU_verdef   00000224 000224 000054  0 A      3   3  4
[ 6] .dynamic             DYNAMIC      00000278 000278 000080  8 WA     3   0  4
[ 7] .rodata              PROGBITS     000002f8 0002f8 000214  4 WA     0   0  4
[ 8] .fake_shstrtab       PROGBITS     0000050c 00050c 000076  0 A      0   0  4
[ 9] .note                NOTE         00000584 000584 00003c  0 A      0   0  4
[10] .eh_frame_hdr        PROGBITS     000005c0 0005c0 000024  0 A      0   0  4
[11] .eh_frame            PROGBITS     000005e4 0005e4 000108  0 A      0   0  4
[12] .text                PROGBITS     000006f0 0006f0 000384  0 AX     0   0 16
[13] .altinstructions     PROGBITS     00000a74 000a74 000018  0 A      0   0  1
[14] .altinstr_replacement PROGBITS     00000a8c 000a8c 000006  0 AX     0   0  1
[15] .debug_info          PROGBITS     00000000 000a92 001161  0        0   0  1
[16] .debug_abbrev        PROGBITS     00000000 001bf3 0002b7  0        0   0  1
[17] .debug_loc           PROGBITS     00000000 001eaa 0000e0  0        0   0  1
[18] .debug_aranges       PROGBITS     00000000 001f90 000040  0        0   0  8
[19] .debug_ranges        PROGBITS     00000000 001fd0 000060  0        0   0  1
[20] .debug_line          PROGBITS     00000000 002030 00063c  0        0   0  1
[21] .debug_str           PROGBITS     00000000 00266c 000733  1 MS     0   0  1
[22] .comment             PROGBITS     00000000 002d9f 000011  1 MS     0   0  1
[23] .debug_frame         PROGBITS     00000000 002db0 0000dc  0        0   0  4
[24] .shstrtab            STRTAB       00000000 002e8c 000127  0        0   0  1
[25] .symtab              SYMTAB       00000000 0033ec 000350 16       26  45  4
[26] .strtab              STRTAB       00000000 00373c 0001fa  0        0   0  1

arch/x86/vdso/vdso64.so.dbg
There are 27 section headers, starting at offset 0x4460:

Section Headers:
[Nr] Name                 Type         Addr             Off      Size     ES Flags Lk Inf Al
[ 0]                      NULL         0000000000000000 00000000 00000000  0        0   0  0
[ 1] .hash                HASH         0000000000000120 00000120 00000040  4 A      2   0  8
[ 2] .dynsym              DYNSYM       0000000000000160 00000160 00000108 24 A      3   2  8
[ 3] .dynstr              STRTAB       0000000000000268 00000268 0000005e  0 A      0   0  1
[ 4] .gnu.version         GNU_versym   00000000000002c6 000002c6 00000016  2 A      2   0  2
[ 5] .gnu.version_d       GNU_verdef   00000000000002e0 000002e0 00000038  0 A      3   2  8
[ 6] .dynamic             DYNAMIC      0000000000000318 00000318 00000100 16 WA     3   0  8
[ 7] .rodata              PROGBITS     0000000000000418 00000418 00000340  8 WA     0   0  8
[ 8] .fake_shstrtab       PROGBITS     0000000000000760 00000760 00000076  0 A      0   0 32
[ 9] .note                NOTE         00000000000007d8 000007d8 0000003c  0 A      0   0  4
[10] .eh_frame_hdr        PROGBITS     0000000000000814 00000814 00000034  0 A      0   0  4
[11] .eh_frame            PROGBITS     0000000000000848 00000848 000000f8  0 A      0   0  8
[12] .text                PROGBITS     0000000000000940 00000940 00000460  0 AX     0   0 16
[13] .altinstructions     PROGBITS     0000000000000da0 00000da0 00000018  0 A      0   0  1
[14] .altinstr_replacement PROGBITS     0000000000000db8 00000db8 00000006  0 AX     0   0  1
[15] .rela.dyn            RELA         0000000000000dc0 00000dc0 00000000 24 A      2   0  8
[16] .debug_info          PROGBITS     0000000000000000 00000dc0 0000171c  0        0   0  1
[17] .debug_abbrev        PROGBITS     0000000000000000 000024dc 00000468  0        0   0  1
[18] .debug_loc           PROGBITS     0000000000000000 00002944 0000026c  0        0   0  1
[19] .debug_aranges       PROGBITS     0000000000000000 00002bb0 00000060  0        0   0  1
[20] .debug_ranges        PROGBITS     0000000000000000 00002c10 000006e0  0        0   0  1
[21] .debug_line          PROGBITS     0000000000000000 000032f0 0000085f  0        0   0  1
[22] .debug_str           PROGBITS     0000000000000000 00003b4f 000007d5  1 MS     0   0  1
[23] .comment             PROGBITS     0000000000000000 00004324 00000011  1 MS     0   0  1
[24] .shstrtab            STRTAB       0000000000000000 00004335 00000124  0        0   0  1
[25] .symtab              SYMTAB       0000000000000000 00004b20 00000468 24       26  38  8
[26] .strtab              STRTAB       0000000000000000 00004f88 00000156  0        0   0  1

arch/x86/vdso/vdso.so.dbg
There are 24 section headers, starting at offset 0x4300:

Section Headers:
[Nr] Name                 Type         Addr             Off      Size     ES Flags Lk Inf Al
[ 0]                      NULL         0000000000000000 00000000 00000000  0        0   0  0
[ 1] .hash                HASH         0000000000000120 00000120 00000040  4 A      2   0  8
[ 2] .dynsym              DYNSYM       0000000000000160 00000160 00000108 24 A      3   2  8
[ 3] .dynstr              STRTAB       0000000000000268 00000268 0000005e  0 A      0   0  1
[ 4] .gnu.version         GNU_versym   00000000000002c6 000002c6 00000016  2 A      2   0  2
[ 5] .gnu.version_d       GNU_verdef   00000000000002e0 000002e0 00000038  0 A      3   2  8
[ 6] .note                NOTE         0000000000000318 00000318 00000018  0 A      0   0  4
[ 7] .eh_frame_hdr        PROGBITS     0000000000000330 00000330 00000034  0 A      0   0  4
[ 8] .eh_frame            PROGBITS     0000000000000368 00000368 000000f8  0 A      0   0  8
[ 9] .dynamic             DYNAMIC      0000000000000460 00000460 000000f0 16 WA     3   0  8
[10] .altinstructions     PROGBITS     0000000000000550 00000550 00000018  0 A      0   0  1
[11] .altinstr_replacement PROGBITS     0000000000000568 00000568 00000006  0 AX     0   0  1
[12] .text                PROGBITS     0000000000000600 00000600 0000048d  0 AX     0   0 16
[13] .debug_info          PROGBITS     0000000000000000 00000a8d 0000183b  0        0   0  1
[14] .debug_abbrev        PROGBITS     0000000000000000 000022c8 00000481  0        0   0  1
[15] .debug_loc           PROGBITS     0000000000000000 00002749 0000026c  0        0   0  1
[16] .debug_aranges       PROGBITS     0000000000000000 000029b5 00000060  0        0   0  1
[17] .debug_ranges        PROGBITS     0000000000000000 00002a15 000006e0  0        0   0  1
[18] .debug_line          PROGBITS     0000000000000000 000030f5 00000810  0        0   0  1
[19] .debug_str           PROGBITS     0000000000000000 00003905 000008e6  1 MS     0   0  1
[20] .comment             PROGBITS     0000000000000000 000041eb 00000011  1 MS     0   0  1
[21] .shstrtab            STRTAB       0000000000000000 000041fc 00000103  0        0   0  1
[22] .symtab              SYMTAB       0000000000000000 00004900 00000360 24       23  27  8
[23] .strtab              STRTAB       0000000000000000 00004c60 000000c8  0        0   0  1

arch/x86/vdso/vdsox32.so.dbg
There are 17 section headers, starting at offset 0xb78:

Section Headers:
[Nr] Name                 Type         Addr     Off    Size   ES Flags Lk Inf Al
[ 0]                      NULL         00000000 000000 000000  0        0   0  0
[ 1] .hash                HASH         000000b4 0000b4 000030  4 A      2   0  4
[ 2] .dynsym              DYNSYM       000000e4 0000e4 000070 16 A      3   2  4
[ 3] .dynstr              STRTAB       00000154 000154 00005e  0 A      0   0  1
[ 4] .gnu.version         GNU_versym   000001b2 0001b2 00000e  2 A      2   0  2
[ 5] .gnu.version_d       GNU_verdef   000001c0 0001c0 000038  0 A      3   2  4
[ 6] .note                NOTE         000001f8 0001f8 000018  0 A      0   0  4
[ 7] .eh_frame_hdr        PROGBITS     00000210 000210 00003c  0 A      0   0  4
[ 8] .eh_frame            PROGBITS     00000250 000250 000110  0 A      0   0  8
[ 9] .dynamic             DYNAMIC      00000360 000360 000080  8 WA     3   0  4
[10] .altinstructions     PROGBITS     000003e0 0003e0 000048  0 A      0   0  1
[11] .altinstr_replacement PROGBITS     00000428 000428 000012  0 AX     0   0  1
[12] .text                PROGBITS     00000500 000500 0005bc  0 AX     0   0 16
[13] .comment             PROGBITS     00000000 000abc 000011  1 MS     0   0  1
[14] .shstrtab            STRTAB       00000000 000acd 0000aa  0        0   0  1
[15] .symtab              SYMTAB       00000000 000e20 000230 16       16  30  4
[16] .strtab              STRTAB       00000000 001050 00011e  0        0   0  1



-- Steve
