Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3JBHvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 03:51:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60530 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3JBHv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <524B7179.7040104@jp.fujitsu.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
	<1380656245-29975-7-git-send-email-keescook@chromium.org>
	<524B6AEE.90301@jp.fujitsu.com>
	<524B7179.7040104@jp.fujitsu.com>
Date: Wed, 2 Oct 2013 00:51:28 -0700
X-Google-Sender-Auth: 7YhhMozOazFLy1vxD7_lSIeZbsw
Message-ID: <CAGXu5jLZw-D7vnsKV8U27o+XWL7gfqbF0AUSmBvjV6JBLJk85w@mail.gmail.com>
Subject: Re: [PATCH 6/7] x86, kaslr: report kernel offset on panic
From: Kees Cook <keescook@chromium.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Aaron Durbin <adurbin@google.com>,
        Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>,
        Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 6:06 PM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> (2013/10/02 9:38), HATAYAMA Daisuke wrote:
>> (2013/10/02 4:37), Kees Cook wrote:
> <cut>
>>> @@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
>>>    }
>>>
>>>    #endif /* CONFIG_X86_32 */
>>> +
>>> +static struct notifier_block kernel_offset_notifier = {
>>> +    .notifier_call = dump_kernel_offset
>>> +};
>>> +
>>> +static int __init register_kernel_offset_dumper(void)
>>> +{
>>> +    atomic_notifier_chain_register(&panic_notifier_list,
>>> +                                    &kernel_offset_notifier);
>>> +    return 0;
>>> +}
>>> +__initcall(register_kernel_offset_dumper);
>>>
>>
>> Panic notifier is not executed if kdump is enabled. Maybe, Chrome OS doesn't use
>> kdump? Anyway, kdump related tools now calculate phys_base from memory map
>> information passed as ELF PT_LOAD entries like below.
>
> Another simpler way is to print this information at boot time, not at panic.

No, since a dump may happen temporally far enough away from boot time
that the offset would not be contained in the dmesg buffers any more.
The offset report needs to be part of the panic message, especially
for those using pstore (e.g. Chrome OS0 for crash reporting (which
includes only the panic log contents).

-Kees

-- 
Kees Cook
Chrome OS Security
