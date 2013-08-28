Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3H1PHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:07:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab3H1PHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:07:33 -0400
Message-ID: <521E1232.6010501@suse.cz>
Date: Wed, 28 Aug 2013 17:07:30 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yang, Fei" <fei.yang@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Re: Can anyone suggest a better fix? Not sure if I understand the
 problem, but the patch fixed it
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com> <20130826201035.GA21141@merkur.ravnborg.org> <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.8.2013 21:05, Yang, Fei wrote:
>>> From: Fei Yang <fei.yang@intel.com>
>>> Date: Mon, 26 Aug 2013 11:21:48 -0700
>>> Subject: [PATCH] FIXDEP: error opening depfile
>>>  
>>> Met a kernel build issue where fixdep fails to open a depfile,
>>> fixdep: error opening depfile: drivers/driver-name/.driver-code.o.d: 
>>> No such file or directory
>>> make[4]: *** [drivers/driver-name/driver-code.o] Error 2
>>> make[3]: *** [drivers/driver-name] Error 2 Don't know why the expected 
>>> file was not created, but the assumption that the file had been 
>>> created might not be true, so simply return for such failure.
> 
>> I tried to grep:
>> git grep "driver-name"
>>
>> No hits.
>>
>> Are you trying to fix a build issue with something out-of-tree - or is this only in linux-next?
> 
> Oh, I changed the driver and file name in the error message to avoid
> unnecessary confusion

You achieved quite the opposite :-).


> as the driver is not an upstream one. But this issue happens randomly, not 100%
> reproducible. And it happens on different driver sometimes.

Are you able to reproduce this with the vanilla kernel? If so, details
please. If not, then this can be something with your module's build
system. Are you using anything fancier than

$ cat Makefile
obj-m += my-module.o
$ make -C <kernel build tree> M=$PWD

?

Michal
