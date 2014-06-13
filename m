Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaFMB2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 21:28:51 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:62489 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaFMB2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 21:28:50 -0400
MIME-Version: 1.0
In-Reply-To: <539965EE.6050001@suse.cz>
References: <37910a32e3d223a688a2743376bdde8fbdc8ef5c.1402515662.git.luto@amacapital.net>
 <539965EE.6050001@suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 18:28:29 -0700
Message-ID: <CALCETrWSX1nVqyfe0Ee2rUvpHosTRyW8GSJfr52UCpT566-eWA@mail.gmail.com>
Subject: Re: [PATCH] x86,build: Fix make -jN modules_install install
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 1:33 AM, Michal Marek <mmarek@suse.cz> wrote:
> Dne 11.6.2014 21:41, Andy Lutomirski napsal(a):
>> Every few months, I forget why I type:
>>
>> $ sudo make -j12 modules_install && sudo make -j12 install
>>
>> instead of just:
>>
>> $ sudo make -j12 modules_install install
>>
>> I try the latter, it appears to work, and then my machine won't boot
>> because dracut got confused.  This fixes it once and for all: if you
>> ask make to install modules and a kernel, you almost certainly want
>> the modules installed *first* so that your initramfs scripts can
>> find the modules.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/Makefile | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>> index 33f71b0..7280d28 100644
>> --- a/arch/x86/Makefile
>> +++ b/arch/x86/Makefile
>> @@ -240,6 +240,15 @@ PHONY += install
>>  install:
>>       $(Q)$(MAKE) $(build)=$(boot) $@
>>
>> +# If installing modules and a kernel, it's very likely that some initramfs
>> +# script associated with installing the kernel will reference the modules,
>> +# so make sure that modules are installed first.
>> +ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
>> +  ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
>
> The two conditions are identical. Did you mean to check for "install" in
> one of them?

Yes, although I think that the check for "install" is actually unnecessary.

Is there some way to do this in the core kbuild?

--Andy

>
> Thanks,
> Michal



-- 
Andy Lutomirski
AMA Capital Management, LLC
