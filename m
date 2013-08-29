Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3H2WWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:22:01 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:45323 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3H2WWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:22:00 -0400
Message-ID: <521FC971.7060206@gmail.com>
Date: Fri, 30 Aug 2013 00:21:37 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.9: Oops at elf_core_dump()
References: <521FC12A.9060302@gmail.com> <20130829220550.GA4486@kroah.com>
In-Reply-To: <20130829220550.GA4486@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got it for the first time. Actually, am doing something really unusual
(http://bugs.python.org/issue18843).

Am looking for an answer why I suffer memory corruption in python applicatuons.
So I installed DUMA from http://duma.sourceforge.net and tried to recompile&reinstall
failing python. In previous attempt it exited and per README instructions
I increased the vm.max_map_count value.


# export LD_PRELOAD=/usr/lib64/libduma.so.0.0.0
# sysctl -w vm.max_map_count=1000000
# emerge dev-lang/python:2.7 
DUMA 2.5.15 (shared library, NO_LEAKDETECTION)
Copyright (C) 2006 Michael Eddington <meddington@gmail.com>
Copyright (C) 2002-2008 Hayati Ayguen <h_ayguen@web.de>, Procitec GmbH
Copyright (C) 1987-1999 Bruce Perens <bruce@perens.com>


 * IMPORTANT: 11 news items need reading for repository 'gentoo'.
 * Use eselect news to read news items.


 * IMPORTANT: config file '5 (shared library, NO_LEAKDETECTION)
Copyright (C) 2006 Michael Eddington <meddington@gmail.com>
Copyright (C) 2002-2008 Hayati Ayguen <h_ayguen@web.de>, Procitec GmbH
Copyright (C) 1987-1999 Bruce Perens <bruce@perens.com>

' needs updating.
 * See the CONFIGURATION FILES section of the emerge
 * man page to learn how to update config files.
Calculating dependencies |
DUMA Aborting: mprotect() failed: Cannot allocate memory.
Check README section 'MEMORY USAGE AND EXECUTION SPEED'
  if your (Linux) system may limit the number of different page mappings per process


[and it crashed, no ctrl+c working]



Sorry do not know what to say more. I just crashed teh kernel but except
the Ooops it works so far. The core filesize is zero.
Martin


Greg KH wrote:
> On Thu, Aug 29, 2013 at 11:46:18PM +0200, Martin MOKREJŠ wrote:
>> Hi,
>>   I just got this stacktrace. Not sure whom to send it, poking throu MAINTAINERS
>> file and looking for ELF gave me nothing. ;-)
>>
>> [105670.434336] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [105670.434366] IP: [<ffffffff812f7b42>] strlen+0x2/0x20
>> [105670.434385] PGD 18c8e5067 PUD 2b547e067 PMD 0 
>> [105670.434401] Oops: 0000 [#1] SMP 
>> [105670.434413] Modules linked in: iwldvm iwlwifi
>> [105670.434432] CPU: 0 PID: 7497 Comm: emerge Not tainted 3.10.9-default-pciehp #8
> 
> Is this reproducable?
> 
> thanks,
> 
> greg k-h
> 

-- 
Martin Mokrejs, Ph.D.
Bioinformatics
Donovalska 1658
149 00 Prague
Czech Republic
http://www.iresite.org
http://www.iresite.org/~mmokrejs
