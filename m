Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3GCIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:44:37 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39143 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab3GCIod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:44:33 -0400
Message-ID: <51D3E464.9050707@imgtec.com>
Date: Wed, 3 Jul 2013 09:44:20 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] metag: move EXPORT_SYMBOLs in libs to metag_ksyms.c
References: <1372774074-18553-1-git-send-email-james.hogan@imgtec.com> <87bo6kfp32.fsf@rustcorp.com.au>
In-Reply-To: <87bo6kfp32.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_03_09_44_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing linux-arch and linux-kbuild)

On 03/07/13 01:45, Rusty Russell wrote:
> James Hogan <james.hogan@imgtec.com> writes:
>> Move all EXPORT_SYMBOLs in libs-y directories (arch/metag/{lib,tbx})
>> into metag_ksyms.c so that they don't get omitted by the static linker
>> if they're not used by any other statically linked code, which can
>> result in undefined symbols when building modules.
>>
>> For example a randconfig caused the following error:
>> ERROR: "csum_partial" [fs/reiserfs/reiserfs.ko] undefined!
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> ---
>> Unless there are any objections I'll apply this patch for v3.11. I'm
>> assuming *_ksyms.c is the way that this problem is normally worked
>> around.
> 
> Actually, normally those files are obj-y not lib-y.  See the top-level
> lib/.
> 
> Subtle, I know.

Hmm, subtle indeed, I hadn't noticed that.

grepping for EXPORT_SYMBOL(csum_partial) gives:

./arch/avr32/kernel/avr32_ksyms.c
./arch/sparc/lib/ksyms.c
./arch/sh/kernel/sh_ksyms_32.c
./arch/powerpc/kernel/ppc_ksyms.c
./arch/unicore32/kernel/ksyms.c
./arch/x86/um/ksyms.c
./arch/x86/kernel/x8664_ksyms_64.c
./arch/x86/kernel/i386_ksyms_32.c
./arch/cris/kernel/crisksyms.c
./arch/mips/kernel/mips_ksyms.c
./arch/xtensa/kernel/xtensa_ksyms.c
./arch/arm/kernel/armksyms.c

./arch/ia64/lib/checksum.c
./arch/alpha/lib/checksum.c
./arch/c6x/lib/checksum.c
./arch/mn10300/lib/checksum.c
./arch/cris/arch-v10/lib/old_checksum.c
./arch/h8300/lib/checksum.c
./arch/parisc/lib/checksum.c
./arch/m32r/lib/csum_partial_copy.c
./arch/m68k/lib/checksum.c
./arch/metag/lib/checksum.c
./arch/frv/lib/checksum.c

./lib/checksum.c

All of the above arches have *c*sum.o in lib-y. Should they all be
switched to obj-y or the remaining EXPORT_SYMBOLs moved to *ksyms.c if
this problem is noticed?

Thanks
James

