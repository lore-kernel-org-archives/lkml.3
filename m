Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaGACWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:22:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58416 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaGACWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:22:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53B21B50.2010207@roeck-us.net>
Date: Mon, 30 Jun 2014 19:22:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
References: <1404153930-26568-1-git-send-email-linux@roeck-us.net> <20140701105510.75718b47@canb.auug.org.au>
In-Reply-To: <20140701105510.75718b47@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 05:55 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Mon, 30 Jun 2014 11:45:30 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> powerpc:allmodconfig has been failing for some time with the following
>> error.
>>
>> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>> arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards
>> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
>>
>> A number of attempts to fix the problem by moving around code have been
>> unsuccessful and resulted in failed builds for some configurations and
>> the discovery of toolchain bugs.
>>
>> Fix the problem by disabling RELOCATABLE for COMPILE_TEST builds instead.

s/Fix/Work around/

would probably be a better here.

>> While this is less than perfect, it avoids substantial code changes
>> which would otherwise be necessary just to make COMPILE_TEST builds
>> happy and might have undesired side effects.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> I'll dump this in my "fixes" tree today and see how it goes.
>

Would be great. Note that allyescconfig still fails with relocation errors
after this patch has been applied.

Thanks,
Guenter

