Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaFSNO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:14:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbaFSNOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:14:25 -0400
Message-ID: <53A2E22F.6060100@suse.cz>
Date: Thu, 19 Jun 2014 15:14:23 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kbuild: support of new KBUILD_FULL_PATH
References: <53A1D3A1.70202@gmail.com> <53A2B7A9.7080605@gmail.com> <53A2BE65.2070501@suse.cz> <53A2D0FC.7040309@plexistor.com>
In-Reply-To: <53A2D0FC.7040309@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 19.6.2014 14:01, Boaz Harrosh napsal(a):
> On 06/19/2014 01:41 PM, Michal Marek wrote:
>>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
>>> -        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
>>> +        # if KBUILD_FULL_PATH is not empty then condition will fail
>>> +        ifeq ($(KBUILD_FULL_PATH)$(KBUILD_SRC)/,$(dir $(CURDIR)))
>>
>> This is an ugly way to express the logic.
>>
> 
> I kind of agree. My Makefile foo is not very strong any other way I
> know would duplicate code. What would you suggest?
> 
> [ Best I can think of is:
> 
>         srctree := $(KBUILD_SRC)
> 
>         # if KBUILD_FULL_PATH=1 then do not use relative path
> 	ifneq ($(KBUILD_FULL_PATH), 1)
>                 ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
>                         # building in a subdirectory of the source tree
>                         srctree := ..
>                 endif
>         endif
> 
> 
> Is this better?

Definitely.


>> How about generated sources like asm-offsets.s or the lexer and parser
>> in scripts/kconfig, does kdevelop figure out where the files live? If
>> not, you might need to add
>>
>> -objtree                := .
>> +ifeq ($(KBUILD_FULL_PATH),1)
>> +       objtree := $(CURDIR)
>> +else
>> +        objtree        := .
>> +endif
>>
>> to use the full path also for the O= directory.
>>
> 
> I would not care for those at all. The important is those files that
> you need to point and edit to fix stuff. The generated files I better
> not edit usually. The edit is in some other place, right?

Fair enough.


> I saw that this patch caused other breakage as well. Will you be
> fixing those? Do you want to own this or you still need a ver2
> of this patch?

I already sent three fixes to Linus:
https://lkml.org/lkml/2014/6/18/664. There is one more brekage that
Alexei is seeing with deb-pkg, but this needs further investigation.
Anyway, either send a v2 or tell me and I will fold the above change to
the first version of your patch.

Michal
