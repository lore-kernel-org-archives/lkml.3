Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3H3LsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:48:12 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:42115 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3H3LsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
Date: Fri, 30 Aug 2013 13:48:09 +0200
Message-ID: <CABPqkBS2AD873tHnyCHeC7uwsJdP1V6=8WGUTHG+R0z2pphHjQ@mail.gmail.com>
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        michael.neuling@au1.ibm.com, ellerman@au1.ibm.com,
        svaidy@linux.vnet.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/30 Anshuman Khandual <khandual@linux.vnet.ibm.com>
>
>         This patchset is the re-spin of the original branch stack sampling
> patchset which introduced new PERF_SAMPLE_BRANCH_COND filter. This patchset
> also enables SW based branch filtering support for PPC64 platforms which have
> branch stack sampling support. With this new enablement, the branch filter support
> for PPC64 platforms have been extended to include all these combinations discussed
> below with a sample test application program.
>
>
I am trying to understand which HW has support for capturing the
branches: PPC7 or PPC8.
Then it seems you're saying that only PPC8 has the filtering support.
On PPC7 you use the
SW filter. Did I get this right?

I will look at the patch set.

>
> (1) perf record -e branch-misses:u -b ./cprog
> # Overhead  Command  Source Shared Object          Source Symbol  Target Shared Object          Target Symbol
> # ........  .......  ....................  .....................  ....................  .....................
> #
>      4.42%    cprog  cprog                 [k] sw_4_2             cprog                 [k] lr_addr
>      4.41%    cprog  cprog                 [k] symbol2            cprog                 [k] hw_1_2
>      4.41%    cprog  cprog                 [k] ctr_addr           cprog                 [k] sw_4_1
>      4.41%    cprog  cprog                 [k] lr_addr            cprog                 [k] sw_4_2
>      4.41%    cprog  cprog                 [k] sw_4_2             cprog                 [k] callme
>      4.41%    cprog  cprog                 [k] symbol1            cprog                 [k] hw_1_1
>      4.41%    cprog  cprog                 [k] success_3_1_3      cprog                 [k] sw_3_1
>      2.43%    cprog  cprog                 [k] sw_4_1             cprog                 [k] ctr_addr
>      2.43%    cprog  cprog                 [k] hw_1_2             cprog                 [k] symbol2
>      2.43%    cprog  cprog                 [k] callme             cprog                 [k] hw_1_2
>      2.43%    cprog  cprog                 [k] address1           cprog                 [k] back1
>      2.43%    cprog  cprog                 [k] back1              cprog                 [k] callme
>      2.43%    cprog  cprog                 [k] hw_2_1             cprog                 [k] address1
>      2.43%    cprog  cprog                 [k] sw_3_1_1           cprog                 [k] sw_3_1
>      2.43%    cprog  cprog                 [k] sw_3_1_2           cprog                 [k] sw_3_1
>      2.43%    cprog  cprog                 [k] sw_3_1_3           cprog                 [k] sw_3_1
>      2.43%    cprog  cprog                 [k] sw_3_1             cprog                 [k] sw_3_1_1
>      2.43%    cprog  cprog                 [k] sw_3_1             cprog                 [k] sw_3_1_2
>      2.43%    cprog  cprog                 [k] sw_3_1             cprog                 [k] sw_3_1_3
>      2.43%    cprog  cprog                 [k] callme             cprog                 [k] sw_3_1
>      2.43%    cprog  cprog                 [k] callme             cprog                 [k] sw_4_2
>      2.43%    cprog  cprog                 [k] hw_1_1             cprog                 [k] symbol1
>      2.43%    cprog  cprog                 [k] callme             cprog                 [k] hw_1_1
>      2.42%    cprog  cprog                 [k] sw_3_1             cprog                 [k] callme
>      1.99%    cprog  cprog                 [k] success_3_1_1      cprog                 [k] sw_3_1
>      1.99%    cprog  cprog                 [k] sw_3_1             cprog                 [k] success_3_1_1
>      1.99%    cprog  cprog                 [k] address2           cprog                 [k] back2
>      1.99%    cprog  cprog                 [k] hw_2_2             cprog                 [k] address2
>      1.99%    cprog  cprog                 [k] back2              cprog                 [k] callme
>      1.99%    cprog  cprog                 [k] callme             cprog                 [k] main
>      1.99%    cprog  cprog                 [k] sw_3_1             cprog                 [k] success_3_1_3
>      1.99%    cprog  cprog                 [k] hw_1_1             cprog                 [k] callme
>      1.99%    cprog  cprog                 [k] sw_3_2             cprog                 [k] callme
>      1.99%    cprog  cprog                 [k] callme             cprog                 [k] sw_3_2
>      1.99%    cprog  cprog                 [k] success_3_1_2      cprog                 [k] sw_3_1
>      1.99%    cprog  cprog                 [k] sw_3_1             cprog                 [k] success_3_1_2
>      1.99%    cprog  cprog                 [k] hw_1_2             cprog                 [k] callme
>      1.99%    cprog  cprog                 [k] sw_4_1             cprog                 [k] callme
>      0.02%    cprog  [unknown]             [k] 0xf7ba2328         [unknown]             [k] 0xf7ba2320
>      0.00%    cprog  libc-2.11.2.so        [k] _IO_file_overflow  libc-2.11.2.so        [k] _IO_file_overflow
>      0.00%    cprog  libc-2.11.2.so        [k] _IO_file_xsputn    libc-2.11.2.so        [k] _IO_file_overflow
>      0.00%    cprog  cprog                 [k] callme             cprog                 [k] hw_2_2
>
> PMU filters
> -----------
> (2) perf record -e branch-misses:u -j any_call ./cprog
>
> # Overhead  Command  Source Shared Object            Source Symbol  Target Shared Object           Target Symbol
> # ........  .......  ....................  .......................  ....................  ......................
> #
>      7.82%    cprog  cprog                 [k] sw_3_1               cprog                 [k] success_3_1_2
>      6.88%    cprog  cprog                 [k] sw_3_1               cprog                 [k] sw_3_1_2
>      6.88%    cprog  cprog                 [k] hw_1_1               cprog                 [k] symbol1
>      5.88%    cprog  cprog                 [k] sw_3_1               cprog                 [k] sw_3_1_1
>      5.88%    cprog  cprog                 [k] callme               cprog                 [k] hw_1_1
>      5.88%    cprog  cprog                 [k] sw_3_1               cprog                 [k] success_3_1_1
>      5.88%    cprog  cprog                 [k] sw_3_1               cprog                 [k] sw_3_1_3
>      5.88%    cprog  cprog                 [k] callme               cprog                 [k] hw_1_2
>      5.88%    cprog  cprog                 [k] hw_1_2               cprog                 [k] symbol2
>      5.88%    cprog  cprog                 [k] sw_4_2               cprog                 [k] lr_addr
>      5.88%    cprog  cprog                 [k] callme               cprog                 [k] sw_4_2
>      4.88%    cprog  cprog                 [k] sw_3_1               cprog                 [k] success_3_1_3
>      4.88%    cprog  cprog                 [k] callme               cprog                 [k] sw_3_2
>      4.88%    cprog  cprog                 [k] callme               cprog                 [k] hw_2_2
>      3.94%    cprog  cprog                 [k] callme               cprog                 [k] sw_3_1
>      3.94%    cprog  cprog                 [k] callme               cprog                 [k] hw_2_1
>      2.94%    cprog  cprog                 [k] main                 cprog                 [k] callme
>      2.94%    cprog  cprog                 [k] sw_4_1               cprog                 [k] ctr_addr
>      2.94%    cprog  cprog                 [k] callme               cprog                 [k] sw_4_1
>      0.01%    cprog  [unknown]             [k] 0xf79076c4           [unknown]             [k] 0xf78f22c0
>      0.00%    cprog  libc-2.11.2.so        [k] _IO_file_doallocate  libc-2.11.2.so        [k] _IO_setb
>      0.00%    cprog  libc-2.11.2.so        [k] _IO_file_doallocate  libc-2.11.2.so        [k] mmap
>      0.00%    cprog  libc-2.11.2.so        [k] _IO_file_xsputn      libc-2.11.2.so        [k] _IO_default_xsputn
>      0.00%    cprog  libc-2.11.2.so        [k] _IO_file_overflow    libc-2.11.2.so        [k] _IO_do_write
>      0.00%    cprog  ld-2.11.2.so          [k] malloc               [unknown]             [k] 0xf790b380
>
>
> (3) perf record -e branch-misses:u -j cond ./cprog
> # Overhead  Command  Source Shared Object       Source Symbol  Target Shared Object            Target Symbol
> # ........  .......  ....................  ..................  ....................  .......................
> #
>     24.85%    cprog  [unknown]             [k] 00000000        cprog                 [k] callme
>     15.71%    cprog  cprog                 [k] sw_3_1          cprog                 [k] sw_3_1
>      7.14%    cprog  cprog                 [k] sw_4_2          cprog                 [k] lr_addr
>      6.57%    cprog  [unknown]             [k] 00000000        cprog                 [k] sw_4_2
>      4.57%    cprog  cprog                 [k] hw_2_2          cprog                 [k] callme
>      4.57%    cprog  cprog                 [k] sw_3_1_1        cprog                 [k] sw_3_1
>      4.57%    cprog  cprog                 [k] sw_4_1          cprog                 [k] ctr_addr
>      4.57%    cprog  [unknown]             [k] 00000000        cprog                 [k] sw_4_1
>      4.57%    cprog  cprog                 [k] main            cprog                 [k] hw_1_1
>      4.57%    cprog  cprog                 [k] hw_1_2          cprog                 [k] hw_1_2
>      4.57%    cprog  [unknown]             [k] 00000000        cprog                 [k] main
>      4.57%    cprog  cprog                 [k] hw_2_1          cprog                 [k] callme
>      4.57%    cprog  cprog                 [k] sw_3_1_3        cprog                 [k] sw_3_1
>      4.57%    cprog  cprog                 [k] sw_3_1_2        cprog                 [k] sw_3_1
>      0.01%    cprog  [unknown]             [k] 0xf7aa25dc      [unknown]             [k] 0xf7aa27e4
>      0.00%    cprog  libc-2.11.2.so        [k] _IO_doallocbuf  libc-2.11.2.so        [k] _IO_file_doallocate
>      0.00%    cprog  [unknown]             [k] 00000000        libc-2.11.2.so        [k] _IO_file_doallocate
>      0.00%    cprog  [unknown]             [k] 00000000        libc-2.11.2.so        [k] _IO_file_stat
>
> SW filters
> ----------
> (4) perf record -e branch-misses:u -j any_ret ./cprog
> # Overhead  Command  Source Shared Object      Source Symbol  Target Shared Object   Target Symbol
> # ........  .......  ....................  .................  ....................  ..............
> #
>      7.91%    cprog  cprog                 [k] symbol1        cprog                 [k] hw_1_1
>      7.91%    cprog  cprog                 [k] success_3_1_3  cprog                 [k] sw_3_1
>      7.91%    cprog  cprog                 [k] ctr_addr       cprog                 [k] sw_4_1
>      7.91%    cprog  cprog                 [k] lr_addr        cprog                 [k] sw_4_2
>      7.91%    cprog  cprog                 [k] symbol2        cprog                 [k] hw_1_2
>      7.90%    cprog  cprog                 [k] sw_4_2         cprog                 [k] callme
>      4.34%    cprog  cprog                 [k] success_3_1_2  cprog                 [k] sw_3_1
>      4.33%    cprog  cprog                 [k] sw_4_1         cprog                 [k] callme
>      4.33%    cprog  cprog                 [k] hw_1_2         cprog                 [k] callme
>      4.33%    cprog  cprog                 [k] success_3_1_1  cprog                 [k] sw_3_1
>      4.33%    cprog  cprog                 [k] sw_3_2         cprog                 [k] callme
>      4.33%    cprog  cprog                 [k] back2          cprog                 [k] callme
>      4.33%    cprog  cprog                 [k] callme         cprog                 [k] main
>      4.33%    cprog  cprog                 [k] hw_1_1         cprog                 [k] callme
>      3.58%    cprog  cprog                 [k] sw_3_1         cprog                 [k] callme
>      3.58%    cprog  cprog                 [k] sw_3_1_1       cprog                 [k] sw_3_1
>      3.58%    cprog  cprog                 [k] sw_3_1_2       cprog                 [k] sw_3_1
>      3.58%    cprog  cprog                 [k] back1          cprog                 [k] callme
>      3.57%    cprog  cprog                 [k] sw_3_1_3       cprog                 [k] sw_3_1
>      0.00%    cprog  [unknown]             [k] 0xf7abacf4     [unknown]             [k] 0xf7abae40
>
>
> (5) perf record -e branch-misses:u -j ind_call ./cprog
> # Overhead  Command  Source Shared Object  Source Symbol  Target Shared Object  Target Symbol
> # ........  .......  ....................  .............  ....................  .............
> #
>     63.56%    cprog  cprog                 [k] sw_4_2     cprog                 [k] lr_addr
>     36.44%    cprog  cprog                 [k] sw_4_1     cprog                 [k] ctr_addr
>
>
> Mixed filters
> -------------
> (6) perf record -e branch-misses:u -j any_call,any_ret ./cprog
> Error:
> The perf.data file has no samples!
>
> NOTE: As expected. The HW filters all the branches which are calls and SW tries to find return
> branches in that given set. Both the filters are mutually exclussive, so obviously no samples
> found in the end profile.
>
> (7) perf record -e branch-misses:u -j any_call,ind_call ./cprog
> # Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object   Target Symbol
> # ........  .......  ....................  ..............  ....................  ..............
> #
>     66.69%    cprog  cprog                 [k] sw_4_2      cprog                 [k] lr_addr
>     33.31%    cprog  cprog                 [k] sw_4_1      cprog                 [k] ctr_addr
>      0.00%    cprog  [unknown]             [k] 0x0fe7f264  [unknown]             [k] 0x0ff926d0
>
>
> (8) perf record -e branch-misses:u -j any_call,any_ret,ind_call ./cprog
> Error:
> The perf.data file has no samples!
>
> (9) perf record -e branch-misses:u -j cond,any_ret ./cprog
> # Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object            Target Symbol
> # ........  .......  ....................  ..............  ....................  .......................
> #
>     46.01%    cprog  [unknown]             [k] 00000000    cprog                 [k] callme
>     13.54%    cprog  [unknown]             [k] 00000000    cprog                 [k] sw_4_2
>      8.18%    cprog  cprog                 [k] sw_3_1_2    cprog                 [k] sw_3_1
>      8.07%    cprog  [unknown]             [k] 00000000    cprog                 [k] main
>      8.07%    cprog  cprog                 [k] sw_3_1_1    cprog                 [k] sw_3_1
>      8.07%    cprog  cprog                 [k] sw_3_1_3    cprog                 [k] sw_3_1
>      8.07%    cprog  [unknown]             [k] 00000000    cprog                 [k] sw_4_1
>      0.00%    cprog  [unknown]             [k] 00000000    [unknown]             [k] 0xf7c1480c
>      0.00%    cprog  libc-2.11.2.so        [k] mmap        libc-2.11.2.so        [k] _IO_file_doallocate
>
> (10) perf record -e branch-misses:u -j cond,ind_call ./cprog
> # Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object   Target Symbol
> # ........  .......  ....................  ..............  ....................  ..............
> #
>     48.11%    cprog  [unknown]             [k] 00000000    cprog                 [k] callme
>     13.52%    cprog  [unknown]             [k] 00000000    cprog                 [k] sw_4_2
>     12.42%    cprog  cprog                 [k] sw_4_2      cprog                 [k] lr_addr
>      8.65%    cprog  [unknown]             [k] 00000000    cprog                 [k] main
>      8.65%    cprog  cprog                 [k] sw_4_1      cprog                 [k] ctr_addr
>      8.65%    cprog  [unknown]             [k] 00000000    cprog                 [k] sw_4_1
>      0.00%    cprog  [unknown]             [k] 00000000    [unknown]             [k] 0xf7a4581c
>
>
> (11) perf record -e branch-misses:u -j cond,any_ret,ind_call ./cprog
> # Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object      Target Symbol
> # ........  .......  ....................  ..............  ....................  .................
> #
>     45.91%    cprog  [unknown]             [k] 00000000    cprog                 [k] callme
>     13.26%    cprog  [unknown]             [k] 00000000    cprog                 [k] sw_4_2
>      8.17%    cprog  cprog                 [k] sw_3_1_3    cprog                 [k] sw_3_1
>      8.17%    cprog  [unknown]             [k] 00000000    cprog                 [k] sw_4_1
>      8.17%    cprog  cprog                 [k] sw_3_1_2    cprog                 [k] sw_3_1
>      8.17%    cprog  [unknown]             [k] 00000000    cprog                 [k] main
>      8.16%    cprog  cprog                 [k] sw_3_1_1    cprog                 [k] sw_3_1
>      0.00%    cprog  [unknown]             [k] 00000000    [unknown]             [k] 0xf7f87704
>      0.00%    cprog  [unknown]             [k] 00000000    libc-2.11.2.so        [k] _IO_file_sync
>
> Test application program
> ========================
> (1) Makefile:
> --------------------------------------------
> all: sample.o cprog of.cprog of.sample
>
> sample.o: sample.s
>         as -o sample.o sample.s
> cprog: cprog.c sample.o
>         gcc -o cprog cprog.c sample.o
> of.sample: sample.o
>         objdump -d sample.o > of.sample
> of.cprog: cprog
>         objdump -d cprog > of.cprog
> clean:
>         rm sample.o cprog of.sample of.cprog
> ---------------------------------------------
> (2) cprog.c
> ---------------------------------------------
> #include <stdio.h>
> #define LOOP_COUNT 100000
>
> extern void callme(void);
>
> int main(int argc, char *argv[])
> {
>         int i;
>         for(i = 0; i < LOOP_COUNT; i++)
>                 callme();
>
>         printf("end");
>         return 0;
> }
> ---------------------------------------------
> (3) sample.S
> ---------------------------------------------
> # r25, r26, r27 will be used as first level, second level
> # and third level stack for LR. Register r20, r21, r22, r23
> # r24 will be used for general programming purpose.
>
> .data
>
> msg:
>         .string "BHRB filter tests\n"
>         len = . - msg
> msg_1_1:
>         .string "Test: hw_1_1\n"
>         len_1_1 = 13
> msg_1_2:
>         .string "Test: hw_1_2\n"
>         len_1_2 = 13
> msg_2_1:
>         .string "Test: hw_2_1\n"
>         len_2_1 = 13
> msg_2_2:
>         .string "Test: hw_2_2\n"
>         len_2_2 = 13
> msg_3_1:
>         .string "Test: sw_3_1\n"
>         len_3_1 = 13
> msg_3_1_1:
>         .string "Test: sw_3_1_1\n"
>         len_3_1_1 = 15
> msg_3_1_2:
>         .string "Test: sw_3_1_2\n"
>         len_3_1_2 = 15
> msg_3_1_3:
>         .string "Test: sw_3_1_3\n"
>         len_3_1_3 = 15
> msg_3_2:
>         .string "Test: sw_3_2\n"
>         len_3_3 = 13
> msg_4_1:
>         .string "Test: sw_4_1\n"
>         len_4_1 = 13
> msg_4_2:
>         .string "Test: sw_4_2\n"
>         len_4_2 = 13
>
> hw_3_1_1_passed:
>         .string "\thw_3_1_1_passed\n\n"
>         len_hw_3_1_1_passed = 18
> hw_3_1_2_passed:
>         .string "\thw_3_1_2_passed\n\n"
>         len_hw_3_1_2_passed = 18
> hw_3_1_3_passed:
>         .string "\thw_3_1_3_passed\n\n"
>         len_hw_3_1_3_passed = 18
>
> hw_2_1_passed:
>         .string "\thw_2_1_passed\n\n"
>         len_hw_2_1_passed = 16
>
> hw_2_2_passed:
>         .string "\thw_2_2_passed\n\n"
>         len_hw_2_2_passed = 16
>
> hw_1_1_passed:
>         .string "\thw_1_1_passed\n\n"
>         len_hw_1_1_passed = 16
>
> hw_1_2_passed:
>         .string "\thw_1_2_passed\n\n"
>         len_hw_1_2_passed = 16
>
> hw_4_1_passed:
>         .string "\thw_4_1_passed\n\n"
>         len_hw_4_1_passed = 16
>
> hw_4_2_passed:
>         .string "\thw_4_2_passed\n\n"
>         len_hw_4_2_passed = 16
>
> msg_error:
>         .string "\tError\n"
>         len_error = 7
> .text
>         .global callme
>         .global hw_1_1
>         .global hw_1_2
>         .global hw_2_1
>         .global hw_2_2
>
> # HW filter test symbols
> symbol1:
>         # Print "hw_1_1_passed"
>         li      0, 4
>         li      3, 1
>         lis     4, hw_1_1_passed@ha
>         addi    4, 4, hw_1_1_passed@l
>         li      5, len_hw_1_1_passed
>         sc
>
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> hw_1_1:
>         # Save LR - second level
>         mflr 26
>
>         # Print "hw_1_1 called"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_1_1@ha
>         addi    4, 4, msg_1_1@l
>         li      5, len_1_1
>         sc
>
>         bl symbol1                      # PERF_SAMPLE_BRANCH_ANY_CALL
>
>         # Restore LR
>         mtlr 26
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> symbol2:
>         # Print "Symbol2 taken"
>         li      0, 4
>         li      3, 1
>         lis     4, hw_1_2_passed@ha
>         addi    4, 4, hw_1_2_passed@l
>         li      5, len_hw_1_2_passed
>         sc
>
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
> hw_1_2:
>         # Save LR - second level
>         mflr 26
>
>         # Print "hw_1_2 called"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_1_2@ha
>         addi    4, 4, msg_1_2@l
>         li      5, len_1_2
>         sc
>
>         li 4,20
>         cmpi 0,4,20
>         bcl 12, 4*cr0+2, symbol2        # PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND
>
>         mtlr 26
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> # HW filter test
>
> address1:
>         # Print "hw_2_1_passed"
>         li      0, 4
>         li      3, 1
>         lis     4, hw_2_1_passed@ha
>         addi    4, 4, hw_2_1_passed@l
>         li      5, len_hw_2_1_passed
>         sc
>         b  back1                        # PERF_SAMPLE_BRANCH_ANY
>
> hw_2_1:
>         # Print "hw_2_1 called"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_2_1@ha
>         addi    4, 4, msg_2_1@l
>         li      5, len_2_1
>         sc
>
>         # Simple conditional branch (equal)
>         li      20, 12
>         cmpi    3, 20, 12
>         bc      12, 4*cr3+2, address1   # PERF_SAMPLE_BRANCH_COND
>
> back1:
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> address2:
>         # Print "hw_2_2_passed"
>         li      0, 4
>         li      3, 1
>         lis     4, hw_2_2_passed@ha
>         addi    4, 4, hw_2_2_passed@l
>         li      5, len_hw_2_2_passed
>         sc
>         b  back2                        # PERF_SAMPLE_BRANCH_ANY
>
> hw_2_2:
>         # Print "hw_2_2 called"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_2_2@ha
>         addi    4, 4, msg_2_2@l
>         li      5, len_2_2
>         sc
>
>         # Simple conditional branch (less than)
>         li      20, 12
>         cmpi    4, 20, 20
>         bc      12, 4*cr4+0, address2   # PERF_SAMPLE_BRANCH_COND
> back2:
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> # SW filter test symbols
> sw_3_1_1:
>         # Print "Test: sw_3_1_1"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_3_1_1@ha
>         addi    4, 4, msg_3_1_1@l
>         li      5, len_3_1_1
>         sc
>
>         li      22,0
>         # Test the condition and return
>         li      21, 10
>         cmpi    0, 21, 10
>         bclr    12, 2                   # PERF_SAMPLE_BRANCH_ANY_RET | PERF_SAMPLE_BRANCH_COND
>
>         # Should not have come here
>         li      0, 4
>         li      3, 1
>         lis     4, msg_error@ha
>         addi    4, 4, msg_error@l
>         li      5, len_error
>         sc
>
>         # Mark the error
>         li      22, 1
>
>         # Safe fall back
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> sw_3_1_2:
>         # Print "Test: sw_3_1_2"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_3_1_2@ha
>         addi    4, 4, msg_3_1_2@l
>         li      5, len_3_1_2
>         sc
>
>         li      23, 0
>         # Test the condition and return
>         li      21, 10
>         cmpi    0, 21, 20
>         bclr    12, 0                   # PERF_SAMPLE_BRANCH_ANY_RET | PERF_SAMPLE_BRANCH_COND
>
>         # Should not have come here
>         li      0, 4
>         li      3, 1
>         lis     4, msg_error@ha
>         addi    4, 4, msg_error@l
>         li      5, len_error
>         sc
>
>         # Mark the error
>         li      23, 1
>
>         # Safe fall back
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> sw_3_1_3:
>         # Print "Test: sw_3_1_3"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_3_1_3@ha
>         addi    4, 4, msg_3_1_3@l
>         li      5, len_3_1_3
>         sc
>
>         li      24, 0
>         # Test the condition and return
>         li      21, 10
>         cmpi    0, 21, 5
>         bclr    12, 1                   # PERF_SAMPLE_BRANCH_ANY_RET | PERF_SAMPLE_BRANCH_COND
>
>         # Mark the error
>         li      24, 1
>
>         # Should not have come here
>         li      0, 4
>         li      3, 1
>         lis     4, msg_error@ha
>         addi    4, 4, msg_error@l
>         li      5, len_error
>         sc
>
>         # Safe fall back
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> success_3_1_1:
>         li      0, 4
>         li      3, 1
>         lis     4, hw_3_1_1_passed@ha
>         addi    4, 4, hw_3_1_1_passed@l
>         li      5, len_hw_3_1_1_passed
>         sc
>         blr
>
> success_3_1_2:
>         li      0, 4
>         li      3, 1
>         lis     4, hw_3_1_2_passed@ha
>         addi    4, 4, hw_3_1_2_passed@l
>         li      5, len_hw_3_1_2_passed
>         sc
>         blr
>
> success_3_1_3:
>         li      0, 4
>         li      3, 1
>         lis     4, hw_3_1_3_passed@ha
>         addi    4, 4, hw_3_1_3_passed@l
>         li      5, len_hw_3_1_3_passed
>         sc
>         blr
>
> sw_3_1:
>         # Save LR
>         mflr 26
>
>         # Print "Test: sw_3_1"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_3_1@ha
>         addi    4, 4, msg_3_1@l
>         li      5, len_3_1
>         sc
>
>         # Equal comparison condition
>         bl sw_3_1_1                     # PERF_SAMPLE_BRANCH_ANY_CALL
>         cmpi    0, 22, 0
>         bcl     12, 2, success_3_1_1    # PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND
>
>         # LT comparison condition
>         bl sw_3_1_2                     # PERF_SAMPLE_BRANCH_ANY_CALL
>         cmpi    0, 23, 0
>         bcl     12, 2, success_3_1_2    # PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND
>
>         # GT comparison condition
>         bl sw_3_1_3                     # PERF_SAMPLE_BRANCH_ANY_CALL
>         cmpi    0, 24, 0
>         bcl     12, 2, success_3_1_3    # PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND
>
>         mtlr 26
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
> sw_3_2:
>         # Print "Test: sw_3_2"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_3_2@ha
>         addi    4, 4, msg_3_2@l
>         li      5, len_3_1
>         sc
>
>         # FIXME: Anything more here ?
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> # Indirect call tests
>
> # CTR
> ctr_addr:
>         # Print "bcctr taken"
>         li      0, 4
>         li      3, 1
>         lis     4, hw_4_1_passed@ha
>         addi    4, 4, hw_4_1_passed@l
>         li      5, len_hw_4_1_passed
>         sc
>
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
> sw_4_1:
>         # Save LR
>         mflr    26
>
>         # Print "sw_4_1 called"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_4_1@ha
>         addi    4, 4, msg_4_1@l
>         li      5, len_4_1
>         sc
>
>         # Save address in CTR
>         lis     20, ctr_addr@ha
>         addi    20, 20, ctr_addr@l
>         mtctr   20
>
>
>         # Compare and jump to CTR
>         li      21, 10
>         cmpi    0, 21, 10
>         bcctrl  12, 4*cr0+2             # PERF_SAMPLE_BRANCH_IND_CALL
>
>         mtlr    26
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
> # LR
> lr_addr:
>         # Print "bclrl taken"
>         li      0, 4
>         li      3, 1
>         lis     4, hw_4_2_passed@ha
>         addi    4, 4, hw_4_2_passed@l
>         li      5, len_hw_4_2_passed
>         sc
>
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> sw_4_2:
>         # Save LR
>         mflr    26
>
>         # Print "Test: sw_4_2"
>         li      0, 4
>         li      3, 1
>         lis     4, msg_4_2@ha
>         addi    4, 4, msg_4_2@l
>         li      5, len_4_2
>         sc
>
>         # Save address in LR
>         lis     20, lr_addr@ha
>         addi    20, 20, lr_addr@l
>         mtlr    20
>
>
>         # Compare and jump to CTR
>         li      21, 10
>         cmpi    0, 21, 10
>         bclrl   12, 4*cr0+2             # PERF_SAMPLE_BRANCH_IND_CALL
>
>         # Restore LR
>         mtlr    26
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
>
> callme:
>         # Save LR
>         mflr    25
>
>         # Print "Branch filter Test"
>         li      0, 4
>         li      3, 1
>         lis     4, msg@ha
>         addi    4, 4, msg@l
>         li      5, len
>         sc
>
>         # PERF_SAMPLE_BRANCH_ANY_CALL
>         bl hw_1_1                       # PERF_SAMPLE_BRANCH_ANY_CALL
>         bl hw_1_2                       # PERF_SAMPLE_BRANCH_ANY_CALL
>         # PERF_SAMPLE_BRANCH_COND
>         bl hw_2_1                       # PERF_SAMPLE_BRANCH_ANY_CALL
>         bl hw_2_2                       # PERF_SAMPLE_BRANCH_ANY_CALL
>
>         # PERF_SAMPLE_BRANCH_ANY_RET
>         bl sw_3_1                       # PERF_SAMPLE_BRANCH_ANY_CALL
>         bl sw_3_2                       # PERF_SAMPLE_BRANCH_ANY_CALL
>         # PERF_SAMPLE_BRANCH_IND_CALL
>         bl sw_4_1                       # PERF_SAMPLE_BRANCH_ANY_CALL
>         bl sw_4_2                       # PERF_SAMPLE_BRANCH_ANY_CALL
>
>         # Restore LR
>         mtlr 25
>         blr                             # PERF_SAMPLE_BRANCH_ANY_RET
> --------------------------------------------------------------------
>
> Changes in V2
> --------------
> (1) Enabled PPC64 SW branch filtering support
> (2) Incorporated changes required for all previous comments
>
> Anshuman Khandual (6):
>   perf: New conditional branch filter criteria in branch stack sampling
>   powerpc, perf: Enable conditional branch filter for POWER8
>   perf, tool: Conditional branch filter 'cond' added to perf record
>   x86, perf: Add conditional branch filtering support
>   perf, documentation: Description for conditional branch filter
>   powerpc, perf: Enable SW filtering in branch stack sampling framework
>
>  arch/powerpc/include/asm/perf_event_server.h |   2 +-
>  arch/powerpc/perf/core-book3s.c              | 200 +++++++++++++++++++++++++--
>  arch/powerpc/perf/power8-pmu.c               |  25 ++--
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c   |   5 +
>  include/uapi/linux/perf_event.h              |   3 +-
>  tools/perf/Documentation/perf-record.txt     |   3 +-
>  tools/perf/builtin-record.c                  |   1 +
>  7 files changed, 216 insertions(+), 23 deletions(-)
>
> --
> 1.7.11.7
>
