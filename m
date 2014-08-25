Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbaHYW4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:56:25 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:65124 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaHYW4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:56:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140825172204.769ab4e6@gandalf.local.home>
References: <CA+r1ZhiMSLq1jOr0OmTvB5Qwww_azDbNpQB2=R43+3Fti7b83w@mail.gmail.com>
	<20140825172204.769ab4e6@gandalf.local.home>
Date: Mon, 25 Aug 2014 15:56:21 -0700
Message-ID: <CA+r1ZhhfBL=qS1oNkehwtAXm++AXt6V9T7TsU2SzQ6c=vgy-aQ@mail.gmail.com>
Subject: Re: randconfig build error with next-20140825, in include/linux/tracepoint.h
From: Jim Davis <jim.epost@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 2:22 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 25 Aug 2014 09:30:14 -0700
> Jim Davis <jim.epost@gmail.com> wrote:
>
>> Building with the attached random configuration file,
>>
>> In file included from include/linux/linkage.h:6:0,
>>                  from include/linux/preempt.h:9,
>>                  from include/linux/preempt_mask.h:4,
>>                  from include/linux/hardirq.h:4,
>>                  from include/linux/kvm_host.h:10,
>>                  from arch/x86/kvm/x86.c:22:
>> include/linux/tracepoint.h:214:20: error:
>> ‘__tracepoint_kvm_ple_window’ undeclared here (not in a function)
>>   EXPORT_SYMBOL_GPL(__tracepoint_##name)
>>                     ^
>> include/linux/export.h:57:16: note: in definition of macro ‘__EXPORT_SYMBOL’
>>   extern typeof(sym) sym;     \
>>                 ^
>> include/linux/tracepoint.h:214:2: note: in expansion of macro ‘EXPORT_SYMBOL_GPL
>> ’
>>   EXPORT_SYMBOL_GPL(__tracepoint_##name)
>>   ^
>> arch/x86/kvm/x86.c:7676:1: note: in expansion of macro ‘EXPORT_TRACEPOINT_SYMBOL
>> _GPL’
>>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
>>  ^
>>   LD      fs/affs/built-in.o
>>   CC [M]  fs/affs/super.o
>> make[2]: *** [arch/x86/kvm/x86.o] Error 1
>> make[1]: *** [arch/x86/kvm] Error 2
>
> Does this fix it for you?
>
> -- Steve
>
> From e754b26d0d2d5671780f418a0b3acaa8edce4276 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Mon, 25 Aug 2014 17:19:02 -0400
> Subject: [PATCH] KVM: Only export kvm_ple_window for x86_64
>
> Commit 7b46268d2954 "KVM: trace kvm_ple_window grow/shrink"
> Added the tracepoint kvm_ple_window under a #ifdef CONFIG_X86_64 but
> left the export for that tracepoint unprotected, which would cause it
> to fail to compile when X86_32 is set.
>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c10408ef9ab1..3da45a3ecaa4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7673,4 +7673,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
> +#ifdef CONFIG_X86_64
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
> +#endif
> --
> 1.8.1.4
>

Yes, looks good.  Thanks!

Tested-by: Jim Davis <jim.epost@gmail.com>
