Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3EQJnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:43:41 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:22358
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab3EQJng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:43:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Ic89bhc85dh1432Ic857hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd25he5bhf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1bceh1d0ch1d2eh1d3fh34h1155h)
X-WSS-ID: 0MMXSCI-01-27M-02
X-M-MSG: 
Message-ID: <5195FBBD.6060808@amd.com>
Date: Fri, 17 May 2013 11:43:25 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Wolfram Gloger <wg@malloc.de>
Subject: Re: 3.9 breaks EFI boot on E350
References: <51935981.3010808@amd.com> <CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com> <5193A7C3.4010503@amd.com> <CAE9FiQV8x5NPBJVyiv0wE3jyqTvSMNWxgkDQRXf5LxifgCXbtw@mail.gmail.com> <5194A9CF.3080509@amd.com> <5194D5E6.2070605@amd.com> <CAE9FiQU4AQmQ6gzUK5gcnVebGPCNjAWFxh5=wXdEbZ_gHM4KaQ@mail.gmail.com> <5194F9DF.4030409@amd.com> <CAE9FiQWNDn8uHUAe+CSvYdJXeJi57G+9RBxs688+VaFRS-GXBA@mail.gmail.com>
In-Reply-To: <CAE9FiQWNDn8uHUAe+CSvYdJXeJi57G+9RBxs688+VaFRS-GXBA@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="------------030704090009060508060202"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------030704090009060508060202
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 16.05.2013 17:42, schrieb Yinghai Lu:
> On Thu, May 16, 2013 at 8:23 AM, Christian K=F6nig
> <christian.koenig@amd.com> wrote:
>> Am 16.05.2013 17:17, schrieb Yinghai Lu:
>>
>>> On Thu, May 16, 2013 at 5:49 AM, Christian K=F6nig
>>> <christian.koenig@amd.com> wrote:
>>>> Am 16.05.2013 11:41, schrieb Christian K=F6nig:
>>>>
>>>> Ups, the board DOES have a serial port, and I've got a log now that =
shows
>>>> the mentioned patch above isn't the root cause.
>>>>
>>>> After commit 8d57470d8f859635deffe3919d7d4867b488b85a it indeed cras=
hes
>>>> very
>>>> early in the boot sequence, but commit
>>>> 98e7a989979b185f49e86ddaed2ad6890299d9f0 fixes that and now it crash=
es
>>>> while
>>>> trying to unpack the initrd with a completely different backtrace.
>>>>
>>> ok, did you post the boot log for that failing boot ?
>>
>> Yes, the bootlog is attached, but I also send it as "3.9 breaks EFI bo=
ot on
>> E350 v2" to LKML with a request for help.
> can you boot with appending with "memtest"?

Sure, bootlog with memtest is attached.

Christian.

>
> Thanks
>
> Yinghai
>


--------------030704090009060508060202
Content-Type: text/plain; charset="UTF-8"; name="bootlog_with_memtest.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="bootlog_with_memtest.txt"
Content-Description: bootlog_with_memtest.txt

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-030900-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201304291257 SMP Mon Apr 29 16:58:15 UTC 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.9.0-030900-generic root=UUID=f7d7dd2b-3dec-4d67-ae48-6c6c8d8ae7ff ro console=ttyS0,115200 memtest
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006ea07fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006ea08000-0x000000006ea55fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006ea56000-0x000000006f47efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006f47f000-0x000000006f87bfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006f87c000-0x000000006f87cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000006f87d000-0x000000006f883fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006f884000-0x000000006fc97fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006fc98000-0x000000006fef2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006fef3000-0x000000006fefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0x6f470000  ACPI 2.0=0x6f470000  SMBIOS=0xf04c0  MPS=0xfd480 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x0000000000077000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x0000000000077000-0x0000000000078000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x0000000000078000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000001000000-0x0000000002498000) (20MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000002498000-0x000000003620a000) (829MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x000000003620a000-0x00000000370fd000) (14MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x00000000370fd000-0x0000000047eac000) (269MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000047eac000-0x0000000060e2a000) (399MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000060e2a000-0x0000000060e30000) (0MB)
[    0.000000] efi: mem11: type=1, attr=0xf, range=[0x0000000060e30000-0x0000000060e4e000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000060e4e000-0x0000000063690000) (40MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x0000000063690000-0x00000000638d1000) (2MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x00000000638d1000-0x0000000063d07000) (4MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x0000000063d07000-0x0000000063eea000) (1MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x0000000063eea000-0x0000000063eef000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x0000000063eef000-0x0000000063ef0000) (0MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x0000000063ef0000-0x0000000064027000) (1MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x0000000064027000-0x0000000064055000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x0000000064055000-0x000000006405b000) (0MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x000000006405b000-0x00000000640bf000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x00000000640bf000-0x00000000640c0000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x00000000640c0000-0x00000000640c4000) (0MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x00000000640c4000-0x00000000640c5000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x00000000640c5000-0x000000006e3fd000) (163MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x000000006e3fd000-0x000000006e808000) (4MB)
[    0.000000] efi: mem27: type=2, attr=0xf, range=[0x000000006e808000-0x000000006e812000) (0MB)
[    0.000000] efi: mem28: type=3, attr=0xf, range=[0x000000006e812000-0x000000006ea08000) (1MB)
[    0.000000] efi: mem29: type=0, attr=0xf, range=[0x000000006ea08000-0x000000006ea17000) (0MB)
[    0.000000] efi: mem30: type=0, attr=0xf, range=[0x000000006ea17000-0x000000006ea56000) (0MB)
[    0.000000] efi: mem31: type=10, attr=0xf, range=[0x000000006ea56000-0x000000006ec65000) (2MB)
[    0.000000] efi: mem32: type=10, attr=0xf, range=[0x000000006ec65000-0x000000006f47f000) (8MB)
[    0.000000] efi: mem33: type=6, attr=0x800000000000000f, range=[0x000000006f47f000-0x000000006f799000) (3MB)
[    0.000000] efi: mem34: type=6, attr=0x800000000000000f, range=[0x000000006f799000-0x000000006f7aa000) (0MB)
[    0.000000] efi: mem35: type=6, attr=0x800000000000000f, range=[0x000000006f7aa000-0x000000006f7ac000) (0MB)
[    0.000000] efi: mem36: type=6, attr=0x800000000000000f, range=[0x000000006f7ac000-0x000000006f845000) (0MB)
[    0.000000] efi: mem37: type=5, attr=0x800000000000000f, range=[0x000000006f845000-0x000000006f850000) (0MB)
[    0.000000] efi: mem38: type=5, attr=0x800000000000000f, range=[0x000000006f850000-0x000000006f87c000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf, range=[0x000000006f87c000-0x000000006f87d000) (0MB)
[    0.000000] efi: mem40: type=10, attr=0xf, range=[0x000000006f87d000-0x000000006f884000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf, range=[0x000000006f884000-0x000000006f9d3000) (1MB)
[    0.000000] efi: mem42: type=3, attr=0xf, range=[0x000000006f9d3000-0x000000006fc71000) (2MB)
[    0.000000] efi: mem43: type=4, attr=0xf, range=[0x000000006fc71000-0x000000006fc86000) (0MB)
[    0.000000] efi: mem44: type=3, attr=0xf, range=[0x000000006fc86000-0x000000006fc98000) (0MB)
[    0.000000] efi: mem45: type=6, attr=0x800000000000000f, range=[0x000000006fc98000-0x000000006fef3000) (2MB)
[    0.000000] efi: mem46: type=4, attr=0xf, range=[0x000000006fef3000-0x000000006ff00000) (0MB)
[    0.000000] efi: mem47: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem48: type=11, attr=0x8000000000000001, range=[0x00000000fec10000-0x00000000fec11000) (0MB)
[    0.000000] efi: mem49: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed01000) (0MB)
[    0.000000] efi: mem50: type=11, attr=0x8000000000000001, range=[0x00000000fed61000-0x00000000fed71000) (0MB)
[    0.000000] efi: mem51: type=11, attr=0x8000000000000001, range=[0x00000000fed80000-0x00000000fed90000) (0MB)
[    0.000000] efi: mem52: type=11, attr=0x8000000000000001, range=[0x00000000fef00000-0x0000000100000000) (17MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x6ff00 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] total RAM covered: 1791M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] found SMP MP-table at [mem 0x000fd6e0-0x000fd6ef] mapped at [ffff8800000fd6e0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x6e600000-0x6e7fffff]
[    0.000000] init_memory_mapping: [mem 0x6c000000-0x6e5fffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
[    0.000000] init_memory_mapping: [mem 0x6e800000-0x6ea07fff]
[    0.000000] init_memory_mapping: [mem 0x6f87c000-0x6f87cfff]
[    0.000000] init_memory_mapping: [mem 0x6f884000-0x6fc97fff]
[    0.000000] init_memory_mapping: [mem 0x6fef3000-0x6fefffff]
[    0.000000] early_memtest: # of tests: 17
[    0.000000]   0000010000 - 0000073000 pattern 4c494e5558726c7a
[    0.000000]   00000739f0 - 0000077000 pattern 4c494e5558726c7a
[    0.000000]   0000078000 - 0000099000 pattern 4c494e5558726c7a
[    0.000000]   0000100000 - 0001000000 pattern 4c494e5558726c7a
[    0.000000]   0001f7c000 - 003620a000 pattern 4c494e5558726c7a
[    0.000000]   00370fd000 - 0063690000 pattern 4c494e5558726c7a
[    0.000000]   00638d1000 - 0063d07000 pattern 4c494e5558726c7a
[    0.000000]   0063eea000 - 0063eef000 pattern 4c494e5558726c7a
[    0.000000]   0063ef0000 - 0064027000 pattern 4c494e5558726c7a
[    0.000000]   0064055000 - 006405b000 pattern 4c494e5558726c7a
[    0.000000]   00640bf000 - 00640c0000 pattern 4c494e5558726c7a
[    0.000000]   00640c4000 - 00640c5000 pattern 4c494e5558726c7a
[    0.000000]   006e3fd000 - 006e80f000 pattern 4c494e5558726c7a
[    0.000000]   0000010000 - 0000073000 pattern eeeeeeeeeeeeeeee
[    0.000000]   00000739f0 - 0000077000 pattern eeeeeeeeeeeeeeee
[    0.000000]   0000078000 - 0000099000 pattern eeeeeeeeeeeeeeee
[    0.000000]   0000100000 - 0001000000 pattern eeeeeeeeeeeeeeee
[    0.000000]   0001f7c000 - 003620a000 pattern eeeeeeeeeeeeeeee
[    0.000000]   00370fd000 - 0063690000 pattern eeeeeeeeeeeeeeee
[    0.000000]   00638d1000 - 0063d07000 pattern eeeeeeeeeeeeeeee
[    0.000000]   0063eea000 - 0063eef000 pattern eeeeeeeeeeeeeeee
[    0.000000]   0063ef0000 - 0064027000 pattern eeeeeeeeeeeeeeee
[    0.000000]   0064055000 - 006405b000 pattern eeeeeeeeeeeeeeee
[    0.000000]   00640bf000 - 00640c0000 pattern eeeeeeeeeeeeeeee
[    0.000000]   00640c4000 - 00640c5000 pattern eeeeeeeeeeeeeeee
[    0.000000]   006e3fd000 - 006e80f000 pattern eeeeeeeeeeeeeeee
[    0.000000]   0000010000 - 0000073000 pattern dddddddddddddddd
[    0.000000]   00000739f0 - 0000077000 pattern dddddddddddddddd
[    0.000000]   0000078000 - 0000099000 pattern dddddddddddddddd
[    0.000000]   0000100000 - 0001000000 pattern dddddddddddddddd
[    0.000000]   0001f7c000 - 003620a000 pattern dddddddddddddddd
[    0.000000]   00370fd000 - 0063690000 pattern dddddddddddddddd
[    0.000000]   00638d1000 - 0063d07000 pattern dddddddddddddddd
[    0.000000]   0063eea000 - 0063eef000 pattern dddddddddddddddd
[    0.000000]   0063ef0000 - 0064027000 pattern dddddddddddddddd
[    0.000000]   0064055000 - 006405b000 pattern dddddddddddddddd
[    0.000000]   00640bf000 - 00640c0000 pattern dddddddddddddddd
[    0.000000]   00640c4000 - 00640c5000 pattern dddddddddddddddd
[    0.000000]   006e3fd000 - 006e80f000 pattern dddddddddddddddd
[    0.000000]   0000010000 - 0000073000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   00000739f0 - 0000077000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   0000078000 - 0000099000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   0000100000 - 0001000000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   0001f7c000 - 003620a000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   00370fd000 - 0063690000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   00638d1000 - 0063d07000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   0063eea000 - 0063eef000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   0063ef0000 - 0064027000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   0064055000 - 006405b000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   00640bf000 - 00640c0000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   00640c4000 - 00640c5000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   006e3fd000 - 006e80f000 pattern bbbbbbbbbbbbbbbb
[    0.000000]   0000010000 - 0000073000 pattern 7777777777777777
[    0.000000]   00000739f0 - 0000077000 pattern 7777777777777777
[    0.000000]   0000078000 - 0000099000 pattern 7777777777777777
[    0.000000]   0000100000 - 0001000000 pattern 7777777777777777
[    0.000000]   0001f7c000 - 003620a000 pattern 7777777777777777
[    0.000000]   00370fd000 - 0063690000 pattern 7777777777777777
[    0.000000]   00638d1000 - 0063d07000 pattern 7777777777777777
[    0.000000]   0063eea000 - 0063eef000 pattern 7777777777777777
[    0.000000]   0063ef0000 - 0064027000 pattern 7777777777777777
[    0.000000]   0064055000 - 006405b000 pattern 7777777777777777
[    0.000000]   00640bf000 - 00640c0000 pattern 7777777777777777
[    0.000000]   00640c4000 - 00640c5000 pattern 7777777777777777
[    0.000000]   006e3fd000 - 006e80f000 pattern 7777777777777777
[    0.000000]   0000010000 - 0000073000 pattern cccccccccccccccc
[    0.000000]   00000739f0 - 0000077000 pattern cccccccccccccccc
[    0.000000]   0000078000 - 0000099000 pattern cccccccccccccccc
[    0.000000]   0000100000 - 0001000000 pattern cccccccccccccccc
[    0.000000]   0001f7c000 - 003620a000 pattern cccccccccccccccc
[    0.000000]   00370fd000 - 0063690000 pattern cccccccccccccccc
[    0.000000]   00638d1000 - 0063d07000 pattern cccccccccccccccc
[    0.000000]   0063eea000 - 0063eef000 pattern cccccccccccccccc
[    0.000000]   0063ef0000 - 0064027000 pattern cccccccccccccccc
[    0.000000]   0064055000 - 006405b000 pattern cccccccccccccccc
[    0.000000]   00640bf000 - 00640c0000 pattern cccccccccccccccc
[    0.000000]   00640c4000 - 00640c5000 pattern cccccccccccccccc
[    0.000000]   006e3fd000 - 006e80f000 pattern cccccccccccccccc
[    0.000000]   0000010000 - 0000073000 pattern 9999999999999999
[    0.000000]   00000739f0 - 0000077000 pattern 9999999999999999
[    0.000000]   0000078000 - 0000099000 pattern 9999999999999999
[    0.000000]   0000100000 - 0001000000 pattern 9999999999999999
[    0.000000]   0001f7c000 - 003620a000 pattern 9999999999999999
[    0.000000]   00370fd000 - 0063690000 pattern 9999999999999999
[    0.000000]   00638d1000 - 0063d07000 pattern 9999999999999999
[    0.000000]   0063eea000 - 0063eef000 pattern 9999999999999999
[    0.000000]   0063ef0000 - 0064027000 pattern 9999999999999999
[    0.000000]   0064055000 - 006405b000 pattern 9999999999999999
[    0.000000]   00640bf000 - 00640c0000 pattern 9999999999999999
[    0.000000]   00640c4000 - 00640c5000 pattern 9999999999999999
[    0.000000]   006e3fd000 - 006e80f000 pattern 9999999999999999
[    0.000000]   0000010000 - 0000073000 pattern 6666666666666666
[    0.000000]   00000739f0 - 0000077000 pattern 6666666666666666
[    0.000000]   0000078000 - 0000099000 pattern 6666666666666666
[    0.000000]   0000100000 - 0001000000 pattern 6666666666666666
[    0.000000]   0001f7c000 - 003620a000 pattern 6666666666666666
[    0.000000]   00370fd000 - 0063690000 pattern 6666666666666666
[    0.000000]   00638d1000 - 0063d07000 pattern 6666666666666666
[    0.000000]   0063eea000 - 0063eef000 pattern 6666666666666666
[    0.000000]   0063ef0000 - 0064027000 pattern 6666666666666666
[    0.000000]   0064055000 - 006405b000 pattern 6666666666666666
[    0.000000]   00640bf000 - 00640c0000 pattern 6666666666666666
[    0.000000]   00640c4000 - 00640c5000 pattern 6666666666666666
[    0.000000]   006e3fd000 - 006e80f000 pattern 6666666666666666
[    0.000000]   0000010000 - 0000073000 pattern 3333333333333333
[    0.000000]   00000739f0 - 0000077000 pattern 3333333333333333
[    0.000000]   0000078000 - 0000099000 pattern 3333333333333333
[    0.000000]   0000100000 - 0001000000 pattern 3333333333333333
[    0.000000]   0001f7c000 - 003620a000 pattern 3333333333333333
[    0.000000]   00370fd000 - 0063690000 pattern 3333333333333333
[    0.000000]   00638d1000 - 0063d07000 pattern 3333333333333333
[    0.000000]   0063eea000 - 0063eef000 pattern 3333333333333333
[    0.000000]   0063ef0000 - 0064027000 pattern 3333333333333333
[    0.000000]   0064055000 - 006405b000 pattern 3333333333333333
[    0.000000]   00640bf000 - 00640c0000 pattern 3333333333333333
[    0.000000]   00640c4000 - 00640c5000 pattern 3333333333333333
[    0.000000]   006e3fd000 - 006e80f000 pattern 3333333333333333
[    0.000000]   0000010000 - 0000073000 pattern 8888888888888888
[    0.000000]   00000739f0 - 0000077000 pattern 8888888888888888
[    0.000000]   0000078000 - 0000099000 pattern 8888888888888888
[    0.000000]   0000100000 - 0001000000 pattern 8888888888888888
[    0.000000]   0001f7c000 - 003620a000 pattern 8888888888888888
[    0.000000]   00370fd000 - 0063690000 pattern 8888888888888888
[    0.000000]   00638d1000 - 0063d07000 pattern 8888888888888888
[    0.000000]   0063eea000 - 0063eef000 pattern 8888888888888888
[    0.000000]   0063ef0000 - 0064027000 pattern 8888888888888888
[    0.000000]   0064055000 - 006405b000 pattern 8888888888888888
[    0.000000]   00640bf000 - 00640c0000 pattern 8888888888888888
[    0.000000]   00640c4000 - 00640c5000 pattern 8888888888888888
[    0.000000]   006e3fd000 - 006e80f000 pattern 8888888888888888
[    0.000000]   0000010000 - 0000073000 pattern 4444444444444444
[    0.000000]   00000739f0 - 0000077000 pattern 4444444444444444
[    0.000000]   0000078000 - 0000099000 pattern 4444444444444444
[    0.000000]   0000100000 - 0001000000 pattern 4444444444444444
[    0.000000]   0001f7c000 - 003620a000 pattern 4444444444444444
[    0.000000]   00370fd000 - 0063690000 pattern 4444444444444444
[    0.000000]   00638d1000 - 0063d07000 pattern 4444444444444444
[    0.000000]   0063eea000 - 0063eef000 pattern 4444444444444444
[    0.000000]   0063ef0000 - 0064027000 pattern 4444444444444444
[    0.000000]   0064055000 - 006405b000 pattern 4444444444444444
[    0.000000]   00640bf000 - 00640c0000 pattern 4444444444444444
[    0.000000]   00640c4000 - 00640c5000 pattern 4444444444444444
[    0.000000]   006e3fd000 - 006e80f000 pattern 4444444444444444
[    0.000000]   0000010000 - 0000073000 pattern 2222222222222222
[    0.000000]   00000739f0 - 0000077000 pattern 2222222222222222
[    0.000000]   0000078000 - 0000099000 pattern 2222222222222222
[    0.000000]   0000100000 - 0001000000 pattern 2222222222222222
[    0.000000]   0001f7c000 - 003620a000 pattern 2222222222222222
[    0.000000]   00370fd000 - 0063690000 pattern 2222222222222222
[    0.000000]   00638d1000 - 0063d07000 pattern 2222222222222222
[    0.000000]   0063eea000 - 0063eef000 pattern 2222222222222222
[    0.000000]   0063ef0000 - 0064027000 pattern 2222222222222222
[    0.000000]   0064055000 - 006405b000 pattern 2222222222222222
[    0.000000]   00640bf000 - 00640c0000 pattern 2222222222222222
[    0.000000]   00640c4000 - 00640c5000 pattern 2222222222222222
[    0.000000]   006e3fd000 - 006e80f000 pattern 2222222222222222
[    0.000000]   0000010000 - 0000073000 pattern 1111111111111111
[    0.000000]   00000739f0 - 0000077000 pattern 1111111111111111
[    0.000000]   0000078000 - 0000099000 pattern 1111111111111111
[    0.000000]   0000100000 - 0001000000 pattern 1111111111111111
[    0.000000]   0001f7c000 - 003620a000 pattern 1111111111111111
[    0.000000]   00370fd000 - 0063690000 pattern 1111111111111111
[    0.000000]   00638d1000 - 0063d07000 pattern 1111111111111111
[    0.000000]   0063eea000 - 0063eef000 pattern 1111111111111111
[    0.000000]   0063ef0000 - 0064027000 pattern 1111111111111111
[    0.000000]   0064055000 - 006405b000 pattern 1111111111111111
[    0.000000]   00640bf000 - 00640c0000 pattern 1111111111111111
[    0.000000]   00640c4000 - 00640c5000 pattern 1111111111111111
[    0.000000]   006e3fd000 - 006e80f000 pattern 1111111111111111
[    0.000000]   0000010000 - 0000073000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   00000739f0 - 0000077000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   0000078000 - 0000099000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   0000100000 - 0001000000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   0001f7c000 - 003620a000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   00370fd000 - 0063690000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   00638d1000 - 0063d07000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   0063eea000 - 0063eef000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   0063ef0000 - 0064027000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   0064055000 - 006405b000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   00640bf000 - 00640c0000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   00640c4000 - 00640c5000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   006e3fd000 - 006e80f000 pattern aaaaaaaaaaaaaaaa
[    0.000000]   0000010000 - 0000073000 pattern 5555555555555555
[    0.000000]   00000739f0 - 0000077000 pattern 5555555555555555
[    0.000000]   0000078000 - 0000099000 pattern 5555555555555555
[    0.000000]   0000100000 - 0001000000 pattern 5555555555555555
[    0.000000]   0001f7c000 - 003620a000 pattern 5555555555555555
[    0.000000]   00370fd000 - 0063690000 pattern 5555555555555555
[    0.000000]   00638d1000 - 0063d07000 pattern 5555555555555555
[    0.000000]   0063eea000 - 0063eef000 pattern 5555555555555555
[    0.000000]   0063ef0000 - 0064027000 pattern 5555555555555555
[    0.000000]   0064055000 - 006405b000 pattern 5555555555555555
[    0.000000]   00640bf000 - 00640c0000 pattern 5555555555555555
[    0.000000]   00640c4000 - 00640c5000 pattern 5555555555555555
[    0.000000]   006e3fd000 - 006e80f000 pattern 5555555555555555
[    0.000000]   0000010000 - 0000073000 pattern ffffffffffffffff
[    0.000000]   00000739f0 - 0000077000 pattern ffffffffffffffff
[    0.000000]   0000078000 - 0000099000 pattern ffffffffffffffff
[    0.000000]   0000100000 - 0001000000 pattern ffffffffffffffff
[    0.000000]   0001f7c000 - 003620a000 pattern ffffffffffffffff
[    0.000000]   00370fd000 - 0063690000 pattern ffffffffffffffff
[    0.000000]   00638d1000 - 0063d07000 pattern ffffffffffffffff
[    0.000000]   0063eea000 - 0063eef000 pattern ffffffffffffffff
[    0.000000]   0063ef0000 - 0064027000 pattern ffffffffffffffff
[    0.000000]   0064055000 - 006405b000 pattern ffffffffffffffff
[    0.000000]   00640bf000 - 00640c0000 pattern ffffffffffffffff
[    0.000000]   00640c4000 - 00640c5000 pattern ffffffffffffffff
[    0.000000]   006e3fd000 - 006e80f000 pattern ffffffffffffffff
[    0.000000]   0000010000 - 0000073000 pattern 0000000000000000
[    0.000000]   00000739f0 - 0000077000 pattern 0000000000000000
[    0.000000]   0000078000 - 0000099000 pattern 0000000000000000
[    0.000000]   0000100000 - 0001000000 pattern 0000000000000000
[    0.000000]   0001f7c000 - 003620a000 pattern 0000000000000000
[    0.000000]   00370fd000 - 0063690000 pattern 0000000000000000
[    0.000000]   00638d1000 - 0063d07000 pattern 0000000000000000
[    0.000000]   0063eea000 - 0063eef000 pattern 0000000000000000
[    0.000000]   0063ef0000 - 0064027000 pattern 0000000000000000
[    0.000000]   0064055000 - 006405b000 pattern 0000000000000000
[    0.000000]   00640bf000 - 00640c0000 pattern 0000000000000000
[    0.000000]   00640c4000 - 00640c5000 pattern 0000000000000000
[    0.000000]   006e3fd000 - 006e80f000 pattern 0000000000000000
[    0.000000] RAMDISK: [mem 0x3620a000-0x370fcfff]
[    0.000000] ACPI: RSDP 000000006f470000 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 000000006f470078 0006C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 000000006f4759b8 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20130117/tbfadt-599)
[    0.000000] ACPI: DSDT 000000006f470178 0583F (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 000000006f47df80 00040
[    0.000000] ACPI: APIC 000000006f475ab0 00062 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 000000006f475b18 00044 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 000000006f475b60 0003C (v01 ALASKA    A M I 01072009 MSFT 00010013)
[    0.000000] ACPI: AAFT 000000006f475ba0 00042 (v01 ALASKA OEMAAFT  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 000000006f475be8 00038 (v01 ALASKA    A M I 01072009 AMI  00000005)
[    0.000000] ACPI: BGRT 000000006f475c20 00038 (v00 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 000000006f475c58 003DE (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 000000006f476038 0168E (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000006fefffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x6fefffff]
[    0.000000]   NODE_DATA [mem 0x6e80a000-0x6e80efff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x6ea07fff]
[    0.000000]   node   0: [mem 0x6f87c000-0x6f87cfff]
[    0.000000]   node   0: [mem 0x6f884000-0x6fc97fff]
[    0.000000]   node   0: [mem 0x6fef3000-0x6fefffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000006ea08000 - 000000006ea56000
[    0.000000] PM: Registered nosave memory: 000000006ea56000 - 000000006f47f000
[    0.000000] PM: Registered nosave memory: 000000006f47f000 - 000000006f87c000
[    0.000000] PM: Registered nosave memory: 000000006f87d000 - 000000006f884000
[    0.000000] PM: Registered nosave memory: 000000006fc98000 - 000000006fef3000
[    0.000000] e820: [mem 0x6ff00000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880063a00000 s85824 r8192 d20672 u1048576
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 446901
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.9.0-030900-generic root=UUID=f7d7dd2b-3dec-4d67-ae48-6c6c8d8ae7ff ro console=ttyS0,115200 memtest
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1577692k/1833984k available (7237k kernel code, 17628k absent, 238664k reserved, 6025k data, 1280k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 7340032 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 1600.033 MHz processor
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3200.06 BogoMIPS (lpj=6400132)
[    0.010644] pid_max: default: 32768 minimum: 301
[    0.015302] init_memory_mapping: [mem 0x640c5000-0x6e3fcfff]
[    0.021042] init_memory_mapping: [mem 0x6f47f000-0x6f844fff]
[    0.026753] init_memory_mapping: [mem 0x6f845000-0x6f87bfff]
[    0.032430] init_memory_mapping: [mem 0x6fc98000-0x6fef2fff]
[    0.040016] Security Framework initialized
[    0.044137] AppArmor: AppArmor initialized
[    0.048238] Yama: becoming mindful.
[    0.052075] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.060725] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.068512] Mount-cache hash table entries: 256
[    0.073455] Initializing cgroup subsys cpuacct
[    0.077926] Initializing cgroup subsys memory
[    0.082308] Initializing cgroup subsys devices
[    0.086763] Initializing cgroup subsys freezer
[    0.091216] Initializing cgroup subsys blkio
[    0.095497] Initializing cgroup subsys perf_event
[    0.100205] Initializing cgroup subsys hugetlb
[    0.104714] CPU: Physical Processor ID: 0
[    0.108733] CPU: Processor Core ID: 0
[    0.112408] mce: CPU supports 6 MCE banks
[    0.116443] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.116443] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.116443] tlb_flushall_shift: 5
[    0.130863] Freeing SMP alternatives: 24k freed
[    0.140161] ACPI: Core revision 20130117
[    0.150836] ACPI: All ACPI Tables successfully acquired
[    0.170874] ftrace: allocating 29507 entries in 116 pages
[    0.205634] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.251345] smpboot: CPU0: AMD E-350D APU with Radeon(tm) HD Graphics (fam: 14, model: 02, stepping: 00)
[    0.368355] Performance Events: AMD PMU driver.
[    0.372918] ... version:                0
[    0.376934] ... bit width:              48
[    0.381032] ... generic registers:      4
[    0.385046] ... value mask:             0000ffffffffffff
[    0.390358] ... max period:             00007fffffffffff
[    0.395670] ... fixed-purpose events:   0
[    0.399684] ... event mask:             000000000000000f
[    0.407514] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.415762] smpboot: Booting Node   0, Processors  #1 OK
[    0.434172] Brought up 2 CPUs
[    0.437144] smpboot: Total of 2 processors activated (6400.13 BogoMIPS)
[    0.444660] devtmpfs: initialized
[    0.451494] EVM: security.selinux
[    0.454819] EVM: security.SMACK64
[    0.458140] EVM: security.capability
[    0.461842] PM: Registering ACPI NVS region [mem 0x6ea56000-0x6f47efff] (10653696 bytes)
[    0.470342] PM: Registering ACPI NVS region [mem 0x6f87d000-0x6f883fff] (28672 bytes)
[    0.480142] regulator-dummy: no parameters
[    0.484371] NET: Registered protocol family 16
[    0.489212] ACPI: bus type PCI registered
[    0.493328] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.502631] PCI: not using MMCONFIG
[    0.506116] PCI: Using configuration type 1 for base access
[    0.511681] PCI: Using configuration type 1 for extended access
[    0.519513] bio: create slab <bio-0> at 0
[    0.523751] ACPI: Added _OSI(Module Device)
[    0.527946] ACPI: Added _OSI(Processor Device)
[    0.532388] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.537094] ACPI: Added _OSI(Processor Aggregator Device)
[    0.545751] ACPI: Executed 2 blocks of module-level executable AML code
[    0.556250] ACPI: Interpreter enabled
[    0.559940] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.569203] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.578486] ACPI: (supports S0 S3 S4 S5)
[    0.582413] ACPI: Using IOAPIC for interrupt routing
[    0.587426] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.596820] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.625824] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.643788] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.653744] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.660456] PCI host bridge to bus 0000:00
[    0.664562] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.670053] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.676229] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.682410] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.688590] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.694768] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.701640] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.708513] pci_bus 0000:00: root bus resource [mem 0x80000000-0xffffffff]
[    0.716194] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.722061] pci 0000:00:11.0: set SATA to AHCI mode
[    0.727211] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.733125] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.738987] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.744897] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.751094] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.757045] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.762908] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.768806] pci 0000:00:15.0: System wakeup disabled by ACPI
[    0.774702] pci 0000:00:15.1: System wakeup disabled by ACPI
[    0.780561] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.786479] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.793445] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.798521] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    0.805440] pci 0000:00:15.0: PCI bridge to [bus 03]
[    0.818189] pci 0000:00:15.1: PCI bridge to [bus 04]
[    0.823207] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.831207] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.840489] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11 14 15)
[    0.846659] ACPI: PCI Interrupt Link [LNKB] (IRQs *10 11 14 15)
[    0.852827] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11 14 15)
[    0.859003] ACPI: PCI Interrupt Link [LNKD] (IRQs *10 11 14 15)
[    0.865143] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11 14 15) *0
[    0.871454] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11 14 15) *0
[    0.877764] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11 14 15) *0
[    0.884072] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11 14 15) *0
[    0.890580] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.895671] ACPI: No dock devices found.
[    0.899794] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.907892] vgaarb: loaded
[    0.910601] vgaarb: bridge control possible 0000:00:01.0
[    0.916294] SCSI subsystem initialized
[    0.920051] ACPI: bus type ATA registered
[    0.924229] ACPI: bus type USB registered
[    0.928298] usbcore: registered new interface driver usbfs
[    0.933804] usbcore: registered new interface driver hub
[    0.939193] usbcore: registered new device driver usb
[    0.944484] PCI: Using ACPI for IRQ routing
[    0.959103] NetLabel: Initializing
[    0.962517] NetLabel:  domain hash size = 128
[    0.966874] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.971859] NetLabel:  unlabeled traffic allowed by default
[    0.977564] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.982515] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.990377] Switching to clocksource hpet
[    1.005985] AppArmor: AppArmor Filesystem Enabled
[    1.010790] pnp: PnP ACPI init
[    1.013866] ACPI: bus type PNP registered
[    1.018136] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    1.025322] system 00:01: [io  0x040b] has been reserved
[    1.030645] system 00:01: [io  0x04d6] has been reserved
[    1.035961] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    1.041889] system 00:01: [io  0x0c14] has been reserved
[    1.047211] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    1.053143] system 00:01: [io  0x0c52] has been reserved
[    1.058462] system 00:01: [io  0x0c6c] has been reserved
[    1.063782] system 00:01: [io  0x0c6f] has been reserved
[    1.069103] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    1.075030] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    1.080958] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    1.086887] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    1.092814] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    1.098742] system 00:01: [io  0x0800-0x089f] has been reserved
[    1.104670] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    1.110599] system 00:01: [io  0x0900-0x090f] has been reserved
[    1.116528] system 00:01: [io  0x0910-0x091f] has been reserved
[    1.122457] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    1.128386] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.135361] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.141982] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    1.148604] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    1.155225] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    1.161846] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    1.168472] system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
[    1.175267] system 00:02: [io  0x0290-0x029f] has been reserved
[    1.181688] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    1.188490] system 00:0b: [mem 0x70000000-0x7fffffff] has been reserved
[    1.195406] pnp: PnP ACPI: found 13 devices
[    1.199599] ACPI: bus type PNP unregistered
[    1.212097] pci 0000:00:04.0: BAR 14: assigned [mem 0x80000000-0x801fffff]
[    1.218980] pci 0000:00:04.0: BAR 15: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    1.226815] pci 0000:00:04.0: BAR 13: assigned [io  0x1000-0x1fff]
[    1.233000] pci 0000:00:04.0: PCI bridge to [bus 01]
[    1.237974] pci 0000:00:04.0:   bridge window [io  0x1000-0x1fff]
[    1.244079] pci 0000:00:04.0:   bridge window [mem 0x80000000-0x801fffff]
[    1.250872] pci 0000:00:04.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    1.258622] pci 0000:00:14.4: PCI bridge to [bus 02]
[    1.263606] pci 0000:00:15.0: PCI bridge to [bus 03]
[    1.268586] pci 0000:00:15.1: PCI bridge to [bus 04]
[    1.273559] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    1.279666] pci 0000:00:15.1:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    1.287825] NET: Registered protocol family 2
[    1.292540] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    1.299963] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    1.306722] TCP: Hash tables configured (established 16384 bind 16384)
[    1.313355] TCP: reno registered
[    1.316618] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    1.322658] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    1.329278] NET: Registered protocol family 1
[    1.658832] Trying to unpack rootfs image as initramfs...
[    1.679935] BUG: unable to handle kernel paging request at ffff88006e3fd000
[    1.686940] IP: [<ffffffff813661df>] memset+0x1f/0xb0
[    1.692010] PGD 1f77067 PUD 1f7a067 PMD 61420067 PTE 0
[    1.697212] Oops: 0002 [#1] SMP 
[    1.700478] Modules linked in:
[    1.703546] CPU 0 
[    1.705388] Pid: 1, comm: swapper/0 Not tainted 3.9.0-030900-generic #201304291257 To Be Filled By O.E.M. To Be Filled By O.E.M./E350M1
[    1.717743] RIP: 0010:[<ffffffff813661df>]  [<ffffffff813661df>] memset+0x1f/0xb0
[    1.725248] RSP: 0000:ffff880060af59c0  EFLAGS: 00010216
[    1.730561] RAX: 0000000000000000 RBX: 000000000001f000 RCX: 0000000000000200
[    1.737692] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88006e3fd000
[    1.744818] RBP: ffff880060af59e8 R08: 0000000000000000 R09: ffff88006e3fd000
[    1.751950] R10: ffffffff818318e0 R11: 0000000000000000 R12: 0000000000000000
[    1.759081] R13: ffffea0001b8ff40 R14: ffff88006dc03810 R15: ffff880060af5aa8
[    1.766206] FS:  0000000000000000(0000) GS:ffff880063a00000(0000) knlGS:0000000000000000
[    1.774292] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.780030] CR2: ffff88006e3fd000 CR3: 0000000001c0d000 CR4: 00000000000007f0
[    1.787163] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.794294] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.801419] Process swapper/0 (pid: 1, threadinfo ffff880060af4000, task ffff880060af8000)
[    1.809678] Stack:
[    1.811699]  ffffffff811c4566 000000000001f000 0000000000001000 ffff880060af4000
[    1.819158]  0000000000001000 ffff880060af5a98 ffffffff811365ea ffffffff812e0026
[    1.826612]  ffffffff81831800 ffff880060af5a28 0000000000000000 ffff880060af8000
[    1.834064] Call Trace:
[    1.836515]  [<ffffffff811c4566>] ? simple_write_end+0xf6/0x100
[    1.842435]  [<ffffffff811365ea>] generic_perform_write+0x13a/0x210
[    1.848701]  [<ffffffff812e0026>] ? security_inode_need_killpriv+0x16/0x20
[    1.855571]  [<ffffffff812e0026>] ? security_inode_need_killpriv+0x16/0x20
[    1.862444]  [<ffffffff8113671d>] generic_file_buffered_write+0x5d/0x90
[    1.869057]  [<ffffffff81138196>] __generic_file_aio_write+0x1b6/0x3b0
[    1.875582]  [<ffffffff8113840f>] generic_file_aio_write+0x7f/0x100
[    1.881847]  [<ffffffff8119df53>] do_sync_write+0xa3/0xe0
[    1.887246]  [<ffffffff8119e613>] vfs_write+0xb3/0x180
[    1.892386]  [<ffffffff8119eab2>] sys_write+0x52/0xa0
[    1.897440]  [<ffffffff81d0d5c0>] ? do_name.part.5+0xc9/0x234
[    1.903185]  [<ffffffff81d3810a>] ? bunzip2+0x1b1/0x1b1
[    1.908410]  [<ffffffff81d0d494>] do_copy+0x73/0x8e
[    1.913291]  [<ffffffff81d0ca5e>] flush_buffer+0x82/0xb2
[    1.918604]  [<ffffffff81d0c9dc>] ? eat+0x1c/0x1c
[    1.923308]  [<ffffffff81d0c9dc>] ? eat+0x1c/0x1c
[    1.928014]  [<ffffffff81d3839a>] gunzip+0x287/0x32f
[    1.932980]  [<ffffffff81d0cefa>] unpack_to_rootfs+0x172/0x2a5
[    1.938814]  [<ffffffff81d0c9a9>] ? md_run_setup+0x8b/0x8b
[    1.944299]  [<ffffffff81d0d979>] ? populate_rootfs.part.7+0xa5/0xa5
[    1.950652]  [<ffffffff81d0d8fe>] populate_rootfs.part.7+0x2a/0xa5
[    1.956831]  [<ffffffff81d0d9ad>] populate_rootfs+0x34/0x38
[    1.962403]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
[    1.968063]  [<ffffffff81d0af9d>] do_basic_setup+0x96/0xb4
[    1.973550]  [<ffffffff81d0a80d>] ? loglevel+0x31/0x31
[    1.978689]  [<ffffffff81d2763a>] ? sched_init_smp+0x121/0x123
[    1.984522]  [<ffffffff81d0b073>] kernel_init_freeable+0xb8/0x132
[    1.990617]  [<ffffffff816d64b0>] ? rest_init+0x80/0x80
[    1.995840]  [<ffffffff816d64be>] kernel_init+0xe/0xf0
[    2.000980]  [<ffffffff8170d42c>] ret_from_fork+0x7c/0xb0
[    2.006379]  [<ffffffff816d64b0>] ? rest_init+0x80/0x80
[    2.011602] Code: 1e 44 88 1f c3 90 90 90 90 90 90 90 49 89 f9 48 89 d1 83 e2 07 48 c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 <f3> 48 ab 89 d1 f3 aa 4c 89 c8 c3 66 66 66 90 66 66 66 90 66 66 
[    2.031553] RIP  [<ffffffff813661df>] memset+0x1f/0xb0
[    2.036709]  RSP <ffff880060af59c0>
[    2.040194] CR2: ffff88006e3fd000
[    2.043527] ---[ end trace a792646153894071 ]---
[    2.048145] note: swapper/0[1] exited with preempt_count 1
[    2.053676] BUG: scheduling while atomic: swapper/0/1/0x10000001
[    2.059695] Modules linked in:
[    2.062790] Pid: 1, comm: swapper/0 Tainted: G      D      3.9.0-030900-generic #201304291257
[    2.071319] Call Trace:
[    2.073774]  [<ffffffff816ec84e>] __schedule_bug+0x4d/0x5b
[    2.079270]  [<ffffffff81702b08>] __schedule+0x638/0x6c0
[    2.084590]  [<ffffffff8108fa7a>] __cond_resched+0x2a/0x40
[    2.090086]  [<ffffffff81702c12>] _cond_resched+0x32/0x40
[    2.095494]  [<ffffffff811bacff>] put_files_struct.part.12+0x7f/0xd0
[    2.101853]  [<ffffffff811bb288>] put_files_struct+0x18/0x20
[    2.107522]  [<ffffffff811bb354>] exit_files+0x54/0x70
[    2.112670]  [<ffffffff81060be9>] do_exit+0x189/0x480
[    2.117731]  [<ffffffff817059a9>] oops_end+0xb9/0x100
[    2.122790]  [<ffffffff816eb273>] no_context+0x1ab/0x1ba
[    2.128110]  [<ffffffff816eb455>] __bad_area_nosemaphore+0x1d3/0x1f2
[    2.134472]  [<ffffffff816eaaae>] ? pmd_offset+0x1a/0x20
[    2.139794]  [<ffffffff816eb487>] bad_area_nosemaphore+0x13/0x15
[    2.145809]  [<ffffffff81708912>] __do_page_fault+0x3c2/0x560
[    2.151562]  [<ffffffff81143479>] ? release_pages+0x1e9/0x220
[    2.157318]  [<ffffffff81153c99>] ? __mod_zone_page_state+0x49/0x50
[    2.163593]  [<ffffffff81143209>] ? __pagevec_lru_add_fn+0xb9/0xf0
[    2.169781]  [<ffffffff8114359d>] ? pagevec_lru_move_fn+0xed/0x110
[    2.175969]  [<ffffffff81708abe>] do_page_fault+0xe/0x10
[    2.181289]  [<ffffffff81704dd8>] page_fault+0x28/0x30
[    2.186439]  [<ffffffff813661df>] ? memset+0x1f/0xb0
[    2.191411]  [<ffffffff811c4566>] ? simple_write_end+0xf6/0x100
[    2.197340]  [<ffffffff811365ea>] generic_perform_write+0x13a/0x210
[    2.203616]  [<ffffffff812e0026>] ? security_inode_need_killpriv+0x16/0x20
[    2.210497]  [<ffffffff812e0026>] ? security_inode_need_killpriv+0x16/0x20
[    2.217377]  [<ffffffff8113671d>] generic_file_buffered_write+0x5d/0x90
[    2.223998]  [<ffffffff81138196>] __generic_file_aio_write+0x1b6/0x3b0
[    2.230535]  [<ffffffff8113840f>] generic_file_aio_write+0x7f/0x100
[    2.236806]  [<ffffffff8119df53>] do_sync_write+0xa3/0xe0
[    2.242216]  [<ffffffff8119e613>] vfs_write+0xb3/0x180
[    2.247363]  [<ffffffff8119eab2>] sys_write+0x52/0xa0
[    2.252428]  [<ffffffff81d0d5c0>] ? do_name.part.5+0xc9/0x234
[    2.258180]  [<ffffffff81d3810a>] ? bunzip2+0x1b1/0x1b1
[    2.263415]  [<ffffffff81d0d494>] do_copy+0x73/0x8e
[    2.268302]  [<ffffffff81d0ca5e>] flush_buffer+0x82/0xb2
[    2.273624]  [<ffffffff81d0c9dc>] ? eat+0x1c/0x1c
[    2.278338]  [<ffffffff81d0c9dc>] ? eat+0x1c/0x1c
[    2.283052]  [<ffffffff81d3839a>] gunzip+0x287/0x32f
[    2.288028]  [<ffffffff81d0cefa>] unpack_to_rootfs+0x172/0x2a5
[    2.293870]  [<ffffffff81d0c9a9>] ? md_run_setup+0x8b/0x8b
[    2.299366]  [<ffffffff81d0d979>] ? populate_rootfs.part.7+0xa5/0xa5
[    2.305726]  [<ffffffff81d0d8fe>] populate_rootfs.part.7+0x2a/0xa5
[    2.311913]  [<ffffffff81d0d9ad>] populate_rootfs+0x34/0x38
[    2.317495]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
[    2.323164]  [<ffffffff81d0af9d>] do_basic_setup+0x96/0xb4
[    2.328658]  [<ffffffff81d0a80d>] ? loglevel+0x31/0x31
[    2.333804]  [<ffffffff81d2763a>] ? sched_init_smp+0x121/0x123
[    2.339648]  [<ffffffff81d0b073>] kernel_init_freeable+0xb8/0x132
[    2.345750]  [<ffffffff816d64b0>] ? rest_init+0x80/0x80
[    2.350982]  [<ffffffff816d64be>] kernel_init+0xe/0xf0
[    2.356130]  [<ffffffff8170d42c>] ret_from_fork+0x7c/0xb0
[    2.361539]  [<ffffffff816d64b0>] ? rest_init+0x80/0x80
[    2.366826] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    2.366826] 
[    2.375979] ------------[ cut here ]------------
[    2.380603] WARNING: at /home/apw/COD/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
[    2.390414] Hardware name: To Be Filled By O.E.M.
[    2.395111] Modules linked in:
[    2.398181] Pid: 1, comm: swapper/0 Tainted: G      D W    3.9.0-030900-generic #201304291257
[    2.406699] Call Trace:
[    2.409153]  <IRQ>  [<ffffffff8105a8cf>] warn_slowpath_common+0x7f/0xc0
[    2.415801]  [<ffffffff8105a92a>] warn_slowpath_null+0x1a/0x20
[    2.421632]  [<ffffffff81038a4b>] native_smp_send_reschedule+0x5b/0x60
[    2.428161]  [<ffffffff8109cbc0>] trigger_load_balance+0x190/0x210
[    2.434339]  [<ffffffff81090dde>] scheduler_tick+0x10e/0x140
[    2.439999]  [<ffffffff8106ce19>] update_process_times+0x69/0x80
[    2.446004]  [<ffffffff810b7233>] tick_sched_handle.isra.8+0x33/0x70
[    2.452356]  [<ffffffff810b735c>] tick_sched_timer+0x4c/0x80
[    2.458015]  [<ffffffff81083c28>] __run_hrtimer+0x78/0x1f0
[    2.463501]  [<ffffffff810b7310>] ? tick_nohz_handler+0xa0/0xa0
[    2.469422]  [<ffffffff810b05cc>] ? ktime_get_update_offsets+0x4c/0xd0
[    2.475946]  [<ffffffff810844b7>] hrtimer_interrupt+0xf7/0x230
[    2.481781]  [<ffffffff8170f349>] smp_apic_timer_interrupt+0x69/0x99
[    2.488134]  [<ffffffff8170e21d>] apic_timer_interrupt+0x6d/0x80
[    2.494136]  <EOI>  [<ffffffff8105cf9a>] ? console_unlock.part.9+0x22a/0x270
[    2.501204]  [<ffffffff816ec023>] ? panic+0x17b/0x1be
[    2.506255]  [<ffffffff816ebf85>] ? panic+0xdd/0x1be
[    2.511222]  [<ffffffff81127490>] ? perf_adjust_period+0xb0/0xb0
[    2.517228]  [<ffffffff8105eff2>] find_new_reaper+0x132/0x140
[    2.522974]  [<ffffffff81060345>] forget_original_parent+0x45/0x1a0
[    2.529237]  [<ffffffff810604b7>] exit_notify+0x17/0x110
[    2.534552]  [<ffffffff81060c4c>] do_exit+0x1ec/0x480
[    2.539604]  [<ffffffff817059a9>] oops_end+0xb9/0x100
[    2.544656]  [<ffffffff816eb273>] no_context+0x1ab/0x1ba
[    2.549970]  [<ffffffff816eb455>] __bad_area_nosemaphore+0x1d3/0x1f2
[    2.556322]  [<ffffffff816eaaae>] ? pmd_offset+0x1a/0x20
[    2.561634]  [<ffffffff816eb487>] bad_area_nosemaphore+0x13/0x15
[    2.567642]  [<ffffffff81708912>] __do_page_fault+0x3c2/0x560
[    2.573388]  [<ffffffff81143479>] ? release_pages+0x1e9/0x220
[    2.579132]  [<ffffffff81153c99>] ? __mod_zone_page_state+0x49/0x50
[    2.585397]  [<ffffffff81143209>] ? __pagevec_lru_add_fn+0xb9/0xf0
[    2.591578]  [<ffffffff8114359d>] ? pagevec_lru_move_fn+0xed/0x110
[    2.597757]  [<ffffffff81708abe>] do_page_fault+0xe/0x10
[    2.603070]  [<ffffffff81704dd8>] page_fault+0x28/0x30
[    2.608211]  [<ffffffff813661df>] ? memset+0x1f/0xb0
[    2.613176]  [<ffffffff811c4566>] ? simple_write_end+0xf6/0x100
[    2.619096]  [<ffffffff811365ea>] generic_perform_write+0x13a/0x210
[    2.625364]  [<ffffffff812e0026>] ? security_inode_need_killpriv+0x16/0x20
[    2.632235]  [<ffffffff812e0026>] ? security_inode_need_killpriv+0x16/0x20
[    2.639106]  [<ffffffff8113671d>] generic_file_buffered_write+0x5d/0x90
[    2.645720]  [<ffffffff81138196>] __generic_file_aio_write+0x1b6/0x3b0
[    2.652245]  [<ffffffff8113840f>] generic_file_aio_write+0x7f/0x100
[    2.658511]  [<ffffffff8119df53>] do_sync_write+0xa3/0xe0
[    2.663911]  [<ffffffff8119e613>] vfs_write+0xb3/0x180
[    2.669049]  [<ffffffff8119eab2>] sys_write+0x52/0xa0
[    2.674103]  [<ffffffff81d0d5c0>] ? do_name.part.5+0xc9/0x234
[    2.679849]  [<ffffffff81d3810a>] ? bunzip2+0x1b1/0x1b1
[    2.685075]  [<ffffffff81d0d494>] do_copy+0x73/0x8e
[    2.689953]  [<ffffffff81d0ca5e>] flush_buffer+0x82/0xb2
[    2.695266]  [<ffffffff81d0c9dc>] ? eat+0x1c/0x1c
[    2.699971]  [<ffffffff81d0c9dc>] ? eat+0x1c/0x1c
[    2.704676]  [<ffffffff81d3839a>] gunzip+0x287/0x32f
[    2.709644]  [<ffffffff81d0cefa>] unpack_to_rootfs+0x172/0x2a5
[    2.715477]  [<ffffffff81d0c9a9>] ? md_run_setup+0x8b/0x8b
[    2.720963]  [<ffffffff81d0d979>] ? populate_rootfs.part.7+0xa5/0xa5
[    2.727315]  [<ffffffff81d0d8fe>] populate_rootfs.part.7+0x2a/0xa5
[    2.733494]  [<ffffffff81d0d9ad>] populate_rootfs+0x34/0x38
[    2.739069]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
[    2.744728]  [<ffffffff81d0af9d>] do_basic_setup+0x96/0xb4
[    2.750213]  [<ffffffff81d0a80d>] ? loglevel+0x31/0x31
[    2.755352]  [<ffffffff81d2763a>] ? sched_init_smp+0x121/0x123
[    2.761185]  [<ffffffff81d0b073>] kernel_init_freeable+0xb8/0x132
[    2.767278]  [<ffffffff816d64b0>] ? rest_init+0x80/0x80
[    2.772503]  [<ffffffff816d64be>] kernel_init+0xe/0xf0
[    2.777642]  [<ffffffff8170d42c>] ret_from_fork+0x7c/0xb0
[    2.783042]  [<ffffffff816d64b0>] ? rest_init+0x80/0x80
[    2.788266] ---[ end trace a792646153894072 ]---

--------------030704090009060508060202--
