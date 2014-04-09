Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbaDIOZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:25:38 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36330 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaDIOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:25:34 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.27]
In-Reply-To: <534555E2.6030506@suse.cz>
References: <1397027753-15444-1-git-send-email-yamada.m@jp.panasonic.com> <534555E2.6030506@suse.cz>
From: Peter Foley <pefoley2@pefoley.com>
Date: Wed, 9 Apr 2014 10:25:13 -0400
Message-ID: <CAOFdcFN6+KB-3Am0q9Pd6EYY1U4ckWSDrUDC7WgYz3RH6T81xg@mail.gmail.com>
Subject: Re: [PATCH] x86: suppress "Nothing to be done for ..." messages
To: Michal Marek <mmarek@suse.cz>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 10:14 AM, Michal Marek <mmarek@suse.cz> wrote:
> ccing x86 maintainers
>
> On 2014-04-09 09:15, Masahiro Yamada wrote:
>> When we compiled again, arch/x86/syscalls/Makefile and
>> arch/x86/tools/Makefile emitted "Nothing to be done for ..." messages.
>>
>> Here is the command log:
>>
>>   $ make defconfig
>>      [ snip ]
>>   $ make
>>      [ snip ]
>>   $ make
>>   make[1]: Nothing to be done for `all'.            <-----
>>   make[1]: Nothing to be done for `relocs'.         <-----
>>     CHK     include/config/kernel.release
>>     CHK     include/generated/uapi/linux/version.h
>>
>> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
>> ---
>>  arch/x86/syscalls/Makefile | 1 +
>>  arch/x86/tools/Makefile    | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
>> index f325af2..b6c923a 100644
>> --- a/arch/x86/syscalls/Makefile
>> +++ b/arch/x86/syscalls/Makefile
>> @@ -56,3 +56,4 @@ targets     += $(uapisyshdr-y) $(syshdr-y)
>>
>>  all: $(addprefix $(uapi)/,$(uapisyshdr-y))
>>  all: $(addprefix $(out)/,$(syshdr-y))
>> +     @:
>
> The "all" target should also be added to the PHONY variable.

relocs should be PHONY too.
