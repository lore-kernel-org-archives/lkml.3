Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3HAOfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:35:38 -0400
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:15945 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755984Ab3HAOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:35:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4CAKZx+lGVhxBY/2dsb2JhbAANToM7g2CnMJQGgTKDGAEBAQQjDwEFQAEQCw4EBgICBRYLAgIJAwIBAgE3DgYNAQUCAQGvQ3SRRYEojl8HgmaBJgOZCZNK
X-IronPort-AV: E=Sophos;i="4.89,795,1367942400"; 
   d="scan'208";a="356872737"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 356872737
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <51FA7228.6080306@uclinux.org>
Date: Fri, 02 Aug 2013 00:35:20 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.0.84-stable review
References: <20130625183915.443950649@linuxfoundation.org> <20130625192300.GA10427@roeck-us.net> <CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com> <20130625193951.GF15184@roeck-us.net> <CAMuHMdWK9xorBaTH+Zg9z1XU=JMsSffzGEfv5KHXnMZLX04PCw@mail.gmail.com> <51CB73E3.9000309@uclinux.org> <20130626232951.GA9629@roeck-us.net>
In-Reply-To: <20130626232951.GA9629@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Sorry, I am way behind on this...

On 27/06/13 09:29, Guenter Roeck wrote:
> On Thu, Jun 27, 2013 at 09:06:11AM +1000, Greg Ungerer wrote:
>> On 26/06/13 17:34, Geert Uytterhoeven wrote:
>>> On Tue, Jun 25, 2013 at 9:39 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>> On Tue, Jun 25, 2013 at 09:32:26PM +0200, Geert Uytterhoeven wrote:
>>>>> Hi Günther,
>>>>>
>>>>> On Tue, Jun 25, 2013 at 9:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>> Build m68k:defconfig passed
>>>>>> Build m68k:apollo_defconfig passed
>>>>>> Build m68k:m5272c3_defconfig failed
>>>>>> Build m68k:m5307c3_defconfig failed
>>>>>> Build m68k:m5249evb_defconfig failed
>>>>>> Build m68k:m5407c3_defconfig failed
>>>>>> Build m68k:mac_defconfig passed
>>>>>> Build m68k:multi_defconfig passed
>>>>>> Build m68k:sun3_defconfig passed
>>>>>> Build m68k:sun3x_defconfig passed
>>>>>> Build m68k:mvme16x_defconfig passed
>>>>>> Build m68k:hp300_defconfig passed
>>>>>
>>>>> m68k:defconfig is an alias for m68k:multi_defconfig, so you can drop
>>>>> one of them.
>>>>>
>>>>> Furthermore, m68k:multi_defconfig is the union of all m68k "classic MMU"
>>>>> defconfigs, except for sun3_defconfig (due to the incompatible MMU type).
>>>>> Hence dropping apollo_defconfig, mac_defconfig, sun3x_defconfig,
>>>>> mvme16x_defconfig, and hp300_defconfig would reduce your build coverage
>>>>> only marginally. Of course, if you have too many spare cycles ;-)
>>>>>
>>>> Thanks, I'll do that. The complete build for three releases takes 15+ hours
>>>> with i7-3700k, so reducing that a bit doesn't hurt.
>>>
>>> FYI, you still built m68k:mvme16x_defconfig for v3.9.7-95-g6a2f14b.
>>>
>>>> Would there be any useful builds to add ?
>>>
>>> You could add m68k:m5475evb_defconfig, which is the only Coldfire
>>> defconfig with MMU=y.
>>>
>>> Greg: Any other advice for Coldfire?
>>
>> I might have some, except I am not sure what we are talking about.
>> I don't have enough context from the above alone :-)
>>
> Just trying to figure out an optimal set of targets for test builds.
>
>> I take it this is test building 3.0.84?
>
> Yes
>
>> I haven't built a 3.0.x for a while, so not sure why the above
>> ColdFire targets are failing without going and trying it out.
>>
> Lots of assembler error messages, plus complaints about redefinitions and
> implicit declarations.
>
> arch/m68k/platform/coldfire/entry.S: Assembler messages:
> arch/m68k/platform/coldfire/entry.S:64: Error: Unknown operator -- statement `save_all' ignored
> arch/m68k/platform/coldfire/entry.S:91: Error: operands mismatch -- statement `moveml %a3-%a6/%d6-%d7,%sp@-' ignored
> arch/m68k/platform/coldfire/entry.S:143: Error: Unknown operator -- statement `restore_user' ignored
> arch/m68k/platform/coldfire/entry.S:192: Error: Unknown operator -- statement `rdusp' ignored
> arch/m68k/platform/coldfire/entry.S:201: Error: Unknown operator -- statement `wrusp' ignored
> In file included from arch/m68k/mm/init.c:4:0:
> arch/m68k/mm/init_no.c:45:15: error: conflicting types for ‘empty_zero_page’
> /home/groeck/src/linux-stable/arch/m68k/include/asm/pgtable_mm.h:92:14: note: previous declaration of ‘empty_zero_page’ was here
> arch/m68k/kernel/setup_no.c: In function 'setup_arch':
> arch/m68k/kernel/setup_no.c:264:2: error: implicit declaration of function 'paging_init' [-Werror=implicit-function-declaration]
> /tmp/ccjVitY8.s:120: Error: invalid instruction for this architecture; needs 68010 or higher (68010, 68020 [68k, 68ec020], 68030 [68ec030], 68040 [68ec040], 68060 [68ec060], cpu32 [68330, 68331, 68332, 68333, 68334, 68336, 68340, 68341, 68349, 68360], fidoa [fido]) -- statement `moves.l %d1,(%a2)' ignored
>
> and so on. Not that it tells me anything. I'd guess I have the wrong compiler, but it does
> build for 3.9, so maybe not. If you have an insight, please let me know.

Yes, this is the wrong compiler. You needed to use a m68k-uclinux
targeted toolchain for 3.0 and older kernels. There are changes to
the m68k arch Makefile and linker scripts on newer kernels that mean
you can now use an m68k-linux- toolchain (that is why 3.9 compiles
cleanly).

Its reasonably easy to fix this on 3.0.x kernels if you want this.
The below patch does it. I don't have any firm opinion on whether
you want to apply this to the stable 3.0.x tree. Anyone using 3.0.x
on m68knommu  has always had to use a m68k-uclinux- toolchain up to
now.

Regards
Greg



m68k: allow m68knommu targets to build with an m68k-linux toolchain

Non-mmu m68k arch targets fail to compile with a traditional m68k-linux
toolchain. Some code relies on __uClinux__ being implicitly defined.
We can just define it in our arch Makefile to satisfy this. We will
also need to add the notes section to the linker script to get a
successful build.

Singed-off-by: Greg Ungerer <gerg@uclinux.org>

--- linux-3.0.88/arch/m68k/Makefile_no.org	2013-08-01 23:47:39.953081304 
+1000
+++ linux-3.0.88/arch/m68k/Makefile_no	2013-08-01 23:50:37.453077257 +1000
@@ -107,9 +107,11 @@
  cflags-$(CONFIG_M68360)		:= -m68332

  KBUILD_AFLAGS += $(cflags-y)
+KBUILD_AFLAGS += -D__uClinux__

  KBUILD_CFLAGS += $(cflags-y)
  KBUILD_CFLAGS += -D__linux__
+KBUILD_CFLAGS += -D__uClinux__
  KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"

  head-y := arch/m68k/platform/$(cpuclass-y)/head.o
--- linux-3.0.88/arch/m68k/kernel/vmlinux.lds_no.S.org	2013-08-01 
23:58:49.913160401 +1000
+++ linux-3.0.88/arch/m68k/kernel/vmlinux.lds_no.S	2013-08-02 
00:00:34.373904823 +1000
@@ -75,6 +75,10 @@
  		*(__ex_table)
  		__stop___ex_table = .;

+		__start_notes = .;
+		*(.note.*)
+		__stop_notes = .;
+
  		*(.rodata) *(.rodata.*)
  		*(__vermagic)		/* Kernel version magic */
  		*(__markers_strings)


