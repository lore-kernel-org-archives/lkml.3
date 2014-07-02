Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaGBNVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:21:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:62287 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753606AbaGBNVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:21:15 -0400
Date: Wed, 2 Jul 2014 09:21:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max =
 13)
Message-ID: <20140702092113.1c19f90d@gandalf.local.home>
In-Reply-To: <CALCETrUJUvhGN3hrECf9A=vHkHSNqZ2KtMyDnmrhb-uTpgP6Nw@mail.gmail.com>
References: <20140701000913.5ea51f77@gandalf.local.home>
	<CALCETrUJUvhGN3hrECf9A=vHkHSNqZ2KtMyDnmrhb-uTpgP6Nw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 22:09:18 -0700
Andy Lutomirski <luto@amacapital.net> wrote:
 
> I just successfully built your config, albeit with a different
> toolchain.  Can you do:
> 
> for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done
> 
> after a failed build?
> 
> Let the game of section whack-a-mole begin.
> 

Here's the result of:

  eu-readelf -s arch/x86/vdso/vdso64.so.dbg

-- Steve


Symbol table [ 2] '.dynsym' contains 11 entries:
 2 local symbols  String table: [ 3] '.dynstr'
  Num:            Value   Size Type    Bind   Vis          Ndx Name
    0: 0000000000000000      0 NOTYPE  LOCAL  DEFAULT    UNDEF 
    1: 0000000000000418      0 SECTION LOCAL  DEFAULT        7 
    2: 0000000000000970    612 FUNC    WEAK   DEFAULT       12 clock_gettime@@LINUX_2.6
    3: 0000000000000000      0 OBJECT  GLOBAL DEFAULT      ABS LINUX_2.6@@LINUX_2.6
    4: 0000000000000be0    338 FUNC    GLOBAL DEFAULT       12 __vdso_gettimeofday@@LINUX_2.6
    5: 0000000000000d60     61 FUNC    GLOBAL DEFAULT       12 __vdso_getcpu@@LINUX_2.6
    6: 0000000000000be0    338 FUNC    WEAK   DEFAULT       12 gettimeofday@@LINUX_2.6
    7: 0000000000000d40     21 FUNC    WEAK   DEFAULT       12 time@@LINUX_2.6
    8: 0000000000000d60     61 FUNC    WEAK   DEFAULT       12 getcpu@@LINUX_2.6
    9: 0000000000000970    612 FUNC    GLOBAL DEFAULT       12 __vdso_clock_gettime@@LINUX_2.6
   10: 0000000000000d40     21 FUNC    GLOBAL DEFAULT       12 __vdso_time@@LINUX_2.6

Symbol table [25] '.symtab' contains 47 entries:
 38 local symbols  String table: [26] '.strtab'
  Num:            Value   Size Type    Bind   Vis          Ndx Name
    0: 0000000000000000      0 NOTYPE  LOCAL  DEFAULT    UNDEF 
    1: 0000000000000120      0 SECTION LOCAL  DEFAULT        1 
    2: 0000000000000160      0 SECTION LOCAL  DEFAULT        2 
    3: 0000000000000268      0 SECTION LOCAL  DEFAULT        3 
    4: 00000000000002c6      0 SECTION LOCAL  DEFAULT        4 
    5: 00000000000002e0      0 SECTION LOCAL  DEFAULT        5 
    6: 0000000000000318      0 SECTION LOCAL  DEFAULT        6 
    7: 0000000000000418      0 SECTION LOCAL  DEFAULT        7 
    8: 0000000000000760      0 SECTION LOCAL  DEFAULT        8 
    9: 00000000000007d8      0 SECTION LOCAL  DEFAULT        9 
   10: 0000000000000814      0 SECTION LOCAL  DEFAULT       10 
   11: 0000000000000848      0 SECTION LOCAL  DEFAULT       11 
   12: 0000000000000940      0 SECTION LOCAL  DEFAULT       12 
   13: 0000000000000da0      0 SECTION LOCAL  DEFAULT       13 
   14: 0000000000000db8      0 SECTION LOCAL  DEFAULT       14 
   15: 0000000000000dc0      0 SECTION LOCAL  DEFAULT       15 
   16: 0000000000000000      0 SECTION LOCAL  DEFAULT       16 
   17: 0000000000000000      0 SECTION LOCAL  DEFAULT       17 
   18: 0000000000000000      0 SECTION LOCAL  DEFAULT       18 
   19: 0000000000000000      0 SECTION LOCAL  DEFAULT       19 
   20: 0000000000000000      0 SECTION LOCAL  DEFAULT       20 
   21: 0000000000000000      0 SECTION LOCAL  DEFAULT       21 
   22: 0000000000000000      0 SECTION LOCAL  DEFAULT       22 
   23: 0000000000000000      0 SECTION LOCAL  DEFAULT       23 
   24: 0000000000000000      0 FILE    LOCAL  DEFAULT      ABS vclock_gettime.c
   25: 0000000000000940     43 FUNC    LOCAL  DEFAULT       12 vread_tsc
   26: 0000000000000000      0 FILE    LOCAL  DEFAULT      ABS vgetcpu.c
   27: 0000000000000000      0 FILE    LOCAL  DEFAULT      ABS vdso-fakesections.c
   28: 0000000000000760    118 OBJECT  LOCAL  DEFAULT        8 fake_shstrtab
   29: 0000000000002000      0 NOTYPE  LOCAL  DEFAULT      ABS hpet_page
   30: 0000000000001000      0 NOTYPE  LOCAL  DEFAULT      ABS vvar_page
   31: 0000000000000318      0 OBJECT  LOCAL  DEFAULT      ABS _DYNAMIC
   32: 0000000000003000      0 NOTYPE  LOCAL  DEFAULT      ABS end_mapping
   33: 0000000000000418      0 NOTYPE  LOCAL  DEFAULT        7 VDSO_FAKE_SECTION_TABLE_START
   34: 0000000000001010      0 NOTYPE  LOCAL  DEFAULT      ABS vvar_vgetcpu_mode
   35: 0000000000001000      0 NOTYPE  LOCAL  DEFAULT      ABS vvar_jiffies
   36: 0000000000000758      0 NOTYPE  LOCAL  DEFAULT        7 VDSO_FAKE_SECTION_TABLE_END
   37: 0000000000001080      0 NOTYPE  LOCAL  DEFAULT      ABS vvar_vsyscall_gtod_data
   38: 0000000000000970    612 FUNC    WEAK   DEFAULT       12 clock_gettime
   39: 0000000000000000      0 OBJECT  GLOBAL DEFAULT      ABS LINUX_2.6
   40: 0000000000000be0    338 FUNC    GLOBAL DEFAULT       12 __vdso_gettimeofday
   41: 0000000000000d60     61 FUNC    GLOBAL DEFAULT       12 __vdso_getcpu
   42: 0000000000000be0    338 FUNC    WEAK   DEFAULT       12 gettimeofday
   43: 0000000000000d40     21 FUNC    WEAK   DEFAULT       12 time
   44: 0000000000000d60     61 FUNC    WEAK   DEFAULT       12 getcpu
   45: 0000000000000970    612 FUNC    GLOBAL DEFAULT       12 __vdso_clock_gettime
   46: 0000000000000d40     21 FUNC    GLOBAL DEFAULT       12 __vdso_time
