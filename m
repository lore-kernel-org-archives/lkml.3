Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaFMRaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:30:09 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:54264 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaFMRaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <539AC82B.4070505@suse.cz>
References: <CALCETrWSX1nVqyfe0Ee2rUvpHosTRyW8GSJfr52UCpT566-eWA@mail.gmail.com>
 <1402652395-28779-1-git-send-email-mmarek@suse.cz> <539AC82B.4070505@suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jun 2014 10:29:46 -0700
Message-ID: <CALCETrVbq3kQtq0jOsE0fBAkrSB=UxbB2P9F9iVd1896wO+f-g@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Do not run modules_install and install in paralel
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 2:45 AM, Michal Marek <mmarek@suse.cz> wrote:
> Dne 13.6.2014 11:39, Michal Marek napsal(a):
>> Based on a x86-only patch by Andy Lutomirski <luto@amacapital.net>
>>
>> With modular kernels, 'make install' is going to need the installed
>> modules at some point to generate the initramfs.
>>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> ---
>>  Makefile | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index 7680d7c..7e5e483 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -503,6 +503,12 @@ ifeq ($(KBUILD_EXTMOD),)
>>                  endif
>>          endif
>>  endif
>> +# install and module_install need also be processed one by one
>> +ifneq ($(filter install,$(MAKECMDGOALS)),)
>> +        ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
>> +             mixed-targets := 1
>> +        endif
>> +endif
>
> Note that this version does not enforce the ordering, it just avoids the
> interleaved execution. It can be added if desired.

Hmm.  This will fix 'make modules_install install' but will not fix
'make install modules_install'.  I don't know how many people would
type the latter.

--Andy
