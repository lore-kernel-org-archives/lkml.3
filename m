Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3H2Xei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:34:38 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:45399 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3H2Xeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:34:36 -0400
Message-ID: <521FDA75.4070506@gmail.com>
Date: Fri, 30 Aug 2013 01:34:13 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.9: Oops at elf_core_dump()
References: <521FC12A.9060302@gmail.com> <20130829220550.GA4486@kroah.com> <521FC971.7060206@gmail.com>
In-Reply-To: <521FC971.7060206@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it happened again:

$ export LD_PRELOAD=/usr/lib64/libduma.so.0.0.0
$ python  memory-corruption-test.py
DUMA 2.5.15 (shared library, NO_LEAKDETECTION)
Copyright (C) 2006 Michael Eddington <meddington@gmail.com>
Copyright (C) 2002-2008 Hayati Ayguen <h_ayguen@web.de>, Procitec GmbH
Copyright (C) 1987-1999 Bruce Perens <bruce@perens.com>

DUMA 2.5.15 (shared library, NO_LEAKDETECTION)
Copyright (C) 2006 Michael Eddington <meddington@gmail.com>
Copyright (C) 2002-2008 Hayati Ayguen <h_ayguen@web.de>, Procitec GmbH
Copyright (C) 1987-1999 Bruce Perens <bruce@perens.com>

Finished one record
Finished one record
Finished one record
Finished one record
Finished one record
[cut]


DUMA Aborting: mprotect() failed: Cannot allocate memory.
Check README section 'MEMORY USAGE AND EXECUTION SPEED'
  if your (Linux) system may limit the number of different page mappings per process
Fatal Python error: Illegal instruction

Current thread 0x00007fc9c4803740:
  File "/usr/lib64/python2.7/site-packages/Bio/Blast/NCBIXML.py", line 106 in endElement
  File "/mnt/1TB/var/tmp/portage/dev-lang/python-2.7.5-r2/work/Python-2.7.5/Modules/pyexpat.c", line 618 in EndElement
  File "/usr/lib64/python2.7/site-packages/Bio/Blast/NCBIXML.py", line 654 in parse
  File "memory-corruption-test.py", line 55 in doparse
  File "memory-corruption-test.py", line 104 in main
  File "memory-corruption-test.py", line 109 in <module>



The stacktrace is little different but ... I think I need to find what resource to so that
duma can keep running watching the python binary.


[112567.987073] BUG: unable to handle kernel NULL pointer dereference at           (null)
[112567.987684] IP: [<ffffffff812f7b42>] strlen+0x2/0x20
[112567.988282] PGD 28be2c067 PUD 3a7744067 PMD 0 
[112567.988879] Oops: 0000 [#2] SMP 
[112567.989468] Modules linked in: iwldvm iwlwifi
[112567.990057] CPU: 0 PID: 8822 Comm: python2.7 Tainted: G      D      3.10.9-default-pciehp #8
[112567.990655] Hardware name: Dell Inc. Vostro 3550/, BIOS A11 08/03/2012
[112567.991249] task: ffff8803b5eb0fd0 ti: ffff8803b36d4000 task.ti: ffff8803b36d4000
[112567.991845] RIP: 0010:[<ffffffff812f7b42>]  [<ffffffff812f7b42>] strlen+0x2/0x20
[112567.992443] RSP: 0018:ffff8803b36d59f0  EFLAGS: 00010246
[112567.993039] RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffff8803b5eb0fd0
[112567.993643] RDX: 00000000016e3610 RSI: 0000000000000000 RDI: 0000000000000000
[112567.994249] RBP: ffff8803b36d5a08 R08: 00000000fffffffa R09: 0000000000000000
[112567.994854] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8803b36d5b00
[112567.995459] R13: 00007ffffffff000 R14: 0000000000000004 R15: 0000000000000000
[112567.996060] FS:  00007fc9c4803740(0000) GS:ffff88041d800000(0000) knlGS:0000000000000000
[112567.996664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[112567.997268] CR2: 0000000000000000 CR3: 00000003a3b84000 CR4: 00000000000407f0
[112567.997884] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[112567.998495] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[112567.999100] Stack:
[112567.999698]  ffffffff811bb0a3 ffff8803b36d5e60 00000000000003d8 ffff8803b36d5c08
[112568.000315]  ffffffff811bbcbd ffffffff811bb913 0000000000000002 0000000000000000
[112568.000931]  ffff8803b5eb0fd0 ffff8803b36dffff 0000000000000246 000f424200000000
[112568.001548] Call Trace:
[112568.002156]  [<ffffffff811bb0a3>] ? notesize.isra.11+0x13/0x30
[112568.002774]  [<ffffffff811bbcbd>] elf_core_dump+0xbfd/0x1570
[112568.003392]  [<ffffffff811bb913>] ? elf_core_dump+0x853/0x1570
[112568.004012]  [<ffffffff81097209>] ? unshare_files+0x29/0xa0
[112568.004629]  [<ffffffff811c289c>] do_coredump+0xafc/0xff0
[112568.005247]  [<ffffffff810a63c8>] ? __sigqueue_free+0x38/0x40
[112568.005865]  [<ffffffff810a9961>] get_signal_to_deliver+0x1c1/0x5c0
[112568.006488]  [<ffffffff810b5d90>] ? pid_vnr+0x30/0x30
[112568.007108]  [<ffffffff81002303>] do_signal+0x53/0x8e0
[112568.007725]  [<ffffffff81002bef>] do_notify_resume+0x5f/0x70
[112568.008342]  [<ffffffff812fc71e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[112568.008965]  [<ffffffff817999e2>] int_signal+0x12/0x17
[112568.009583] Code: 48 89 e5 f6 82 40 c6 84 81 20 74 15 0f 1f 44 00 00 48 83 c0 01 0f b6 10 f6 82 40 c6 84 81 20 75 f0 5d c3 66 0f 1f 44 00 00 31 c0 <80> 3f 00 55 48 89 e5 74 11 48 89 f8 66 90 48 83 c0 01 80 38 00 
[112568.011042] RIP  [<ffffffff812f7b42>] strlen+0x2/0x20
[112568.011748]  RSP <ffff8803b36d59f0>
[112568.012445] CR2: 0000000000000000
[112568.013155] ---[ end trace 9d67aee555e92d76 ]---


Martin MOKREJŠ wrote:
> Got it for the first time. Actually, am doing something really unusual
> (http://bugs.python.org/issue18843).
> 
> Am looking for an answer why I suffer memory corruption in python applicatuons.
> So I installed DUMA from http://duma.sourceforge.net and tried to recompile&reinstall
> failing python. In previous attempt it exited and per README instructions
> I increased the vm.max_map_count value.
> 
> 
> # export LD_PRELOAD=/usr/lib64/libduma.so.0.0.0
> # sysctl -w vm.max_map_count=1000000
> # emerge dev-lang/python:2.7 
> DUMA 2.5.15 (shared library, NO_LEAKDETECTION)
> Copyright (C) 2006 Michael Eddington <meddington@gmail.com>
> Copyright (C) 2002-2008 Hayati Ayguen <h_ayguen@web.de>, Procitec GmbH
> Copyright (C) 1987-1999 Bruce Perens <bruce@perens.com>
> 
> 
>  * IMPORTANT: 11 news items need reading for repository 'gentoo'.
>  * Use eselect news to read news items.
> 
> 
>  * IMPORTANT: config file '5 (shared library, NO_LEAKDETECTION)
> Copyright (C) 2006 Michael Eddington <meddington@gmail.com>
> Copyright (C) 2002-2008 Hayati Ayguen <h_ayguen@web.de>, Procitec GmbH
> Copyright (C) 1987-1999 Bruce Perens <bruce@perens.com>
> 
> ' needs updating.
>  * See the CONFIGURATION FILES section of the emerge
>  * man page to learn how to update config files.
> Calculating dependencies |
> DUMA Aborting: mprotect() failed: Cannot allocate memory.
> Check README section 'MEMORY USAGE AND EXECUTION SPEED'
>   if your (Linux) system may limit the number of different page mappings per process
> 
> 
> [and it crashed, no ctrl+c working]
> 
> 
> 
> Sorry do not know what to say more. I just crashed teh kernel but except
> the Ooops it works so far. The core filesize is zero.
> Martin
> 
> 
> Greg KH wrote:
>> On Thu, Aug 29, 2013 at 11:46:18PM +0200, Martin MOKREJŠ wrote:
>>> Hi,
>>>   I just got this stacktrace. Not sure whom to send it, poking throu MAINTAINERS
>>> file and looking for ELF gave me nothing. ;-)
>>>
>>> [105670.434336] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>> [105670.434366] IP: [<ffffffff812f7b42>] strlen+0x2/0x20
>>> [105670.434385] PGD 18c8e5067 PUD 2b547e067 PMD 0 
>>> [105670.434401] Oops: 0000 [#1] SMP 
>>> [105670.434413] Modules linked in: iwldvm iwlwifi
>>> [105670.434432] CPU: 0 PID: 7497 Comm: emerge Not tainted 3.10.9-default-pciehp #8
>>
>> Is this reproducable?
>>
>> thanks,
>>
>> greg k-h
>>
> 

-- 
Martin Mokrejs, Ph.D.
Bioinformatics
Donovalska 1658
149 00 Prague
Czech Republic
http://www.iresite.org
http://www.iresite.org/~mmokrejs
