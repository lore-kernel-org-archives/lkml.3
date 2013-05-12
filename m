Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3ELCuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 22:50:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51681 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3ELCuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 22:50:21 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130511191051.GE18614@n2100.arm.linux.org.uk>
References: <1368273447-11958-1-git-send-email-holt@sgi.com> <1368273447-11958-10-git-send-email-holt@sgi.com> <20130511130457.GD18614@n2100.arm.linux.org.uk> <588ed084-fed7-4bd9-bcd7-a32f40bd404a@email.android.com> <20130511191051.GE18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v10 09/11] arm, prepare reboot_mode for moving to	generic kernel code.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 11 May 2013 19:49:20 -0700
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Russ Anderson <rja@sgi.com>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Message-ID: <6ea66d50-a577-4e08-b315-c7a332144f1d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry.  Yoga programming meaning reversing the arguments to ==.

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

>Please, stop this idiotic incomprehensible jargon.
>
>On Sat, May 11, 2013 at 08:47:28AM -0700, H. Peter Anvin wrote:
>> By the way, do we really need Yoda programming here?
>> 
>> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> 
>> >On Sat, May 11, 2013 at 06:57:25AM -0500, Robin Holt wrote:
>> >> This patch prepares for the moving the parsing of reboot= to the
>> >generic
>> >> kernel code by making reboot_mode into a more generic form.
>> >> 
>> >> Signed-off-by: Robin Holt <holt@sgi.com>
>> >> To: Andrew Morton <akpm@linux-foundation.org>
>> >> To: Russell King <linux@arm.linux.org.uk>
>> >> Cc: Russ Anderson <rja@sgi.com>
>> >> Cc: Robin Holt <holt@sgi.com>
>> >> Cc: H. Peter Anvin <hpa@zytor.com>
>> >> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
>> >> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
>> >> Cc: the arch/x86 maintainers <x86@kernel.org>
>> >> Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
>> >
>> >Almost-but-not-quite-Acked-by: Russell King
>> ><rmk+kernel@arm.linux.org.uk> :)
>> >
>> >> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
>> >> index f219703..92b47df 100644
>> >> --- a/arch/arm/kernel/process.c
>> >> +++ b/arch/arm/kernel/process.c
>> >> @@ -174,14 +174,14 @@ void arch_cpu_idle(void)
>> >>  		default_idle();
>> >>  }
>> >>  
>> >> -static char reboot_mode = 'h';
>> >> +enum reboot_mode reboot_mode = REBOOT_HARD;
>> >>  
>> >> -int __init reboot_setup(char *str)
>> >> +static int __init reboot_setup(char *str)
>> >>  {
>> >> -	reboot_mode = str[0];
>> >> +	if ('s' == str[0])
>> >> +		reboot_mode = REBOOT_SOFT;
>> >
>> >Remember we talked about the 'gpio' mode as well, so you also need
>here
>> >+	if ('g' == str[0])
>> >		reboot_mode = REBOOT_GPIO;
>> 
>> -- 
>> Sent from my mobile phone. Please excuse brevity and lack of
>formatting.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
