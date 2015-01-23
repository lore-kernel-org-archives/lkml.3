Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbbAWLyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:54:47 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:45452 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbAWLyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:54:45 -0500
Message-ID: <54C2367C.4000909@ahsoftware.de>
Date: Fri, 23 Jan 2015 12:54:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: provide option to automatically delete the key
 after modules were installed
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <54C21361.1080500@suse.cz> <54C216D8.8040004@ahsoftware.de> <54C21F35.1040206@ahsoftware.de> <54C22891.6070506@suse.cz> <54C233FB.3080309@ahsoftware.de>
In-Reply-To: <54C233FB.3080309@ahsoftware.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.01.2015 um 12:43 schrieb Alexander Holler:
> Am 23.01.2015 um 11:55 schrieb Michal Marek:

>> The .x509 file contains a certificate signed by the private key, but not
>> the private key. With some scripting, it can be used to verify the
>> module signatures.
>
>
> Assuming that doesn't change (hopefully), I'll send v2 in a few minutes
> (it just compiles in order to test it). Thanks for assuring me that
> .x509 does not and will not contain the private key.

I'm happy I did that. Just deleting the private key currently doesn't 
work. A subsequent make fails:

-----------------------------
(...)
###
### Deleting the private key used to sign modules.
###
   DEPMOD  3.18.3-00076-ga775cc9
[root@krabat linux]# less signing_key.x509
"signing_key.x509" may be a binary file.  See it anyway?
[root@krabat linux]# make -j4 bzImage modules && make -j4 modules_install
   CHK     include/config/kernel.release
   CHK     include/generated/uapi/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/generated/compile.h
X.509 certificate list changed
   CHK     kernel/config_data.h
   CERTS   kernel/x509_certificate_list
   - Including cert signing_key.x509
   AS      kernel/system_certificates.o
   LD      kernel/built-in.o
   LINK    vmlinux
   LD      vmlinux.o
   MODPOST vmlinux.o
   GEN     .version
   CHK     include/generated/compile.h
   UPD     include/generated/compile.h
   CC      init/version.o
   LD      init/built-in.o
   KSYM    .tmp_kallsyms1.o
   KSYM    .tmp_kallsyms2.o
   LD      vmlinux
   SORTEX  vmlinux
   SYSMAP  System.map
   Building modules, stage 2.
   VOFFSET arch/x86/boot/voffset.h
   CC      arch/x86/boot/version.o
   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
   CC      arch/x86/boot/compressed/aslr.o
   LZMA    arch/x86/boot/compressed/vmlinux.bin.lzma
   MODPOST 747 modules
   MKPIGGY arch/x86/boot/compressed/piggy.S
   AS      arch/x86/boot/compressed/piggy.o
   LD      arch/x86/boot/compressed/vmlinux
   OBJCOPY arch/x86/boot/vmlinux.bin
   ZOFFSET arch/x86/boot/zoffset.h
   AS      arch/x86/boot/header.o
   LD      arch/x86/boot/setup.elf
   OBJCOPY arch/x86/boot/setup.bin
   BUILD   arch/x86/boot/bzImage
Setup is 16316 bytes (padded to 16384 bytes).
System is 3908 kB
CRC a049b366
Kernel: arch/x86/boot/bzImage is ready  (#682)
   INSTALL arch/x86/crypto/aes-x86_64.ko
   INSTALL arch/x86/crypto/blowfish-x86_64.ko
   INSTALL arch/x86/crypto/camellia-aesni-avx-x86_64.ko
   INSTALL arch/x86/crypto/aesni-intel.ko
Can't read private key
(...)
-----------------------------

Maybe that's the reason I've always deleted both files, can't remember.

I will see if I find the time and passion to change the Makefile in 
order to fix that. So you might either use my existing patch or wait if 
I will send a new one.

Regards,

Alexander Holler

