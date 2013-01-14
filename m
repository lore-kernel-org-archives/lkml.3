Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab3ANSSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:18:42 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49609 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab3ANSSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:18:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130114154354.GA27740@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-28-git-send-email-yinghai@kernel.org>
	<20130114154354.GA27740@liondog.tnic>
Date: Mon, 14 Jan 2013 10:18:39 -0800
X-Google-Sender-Auth: T3Ko1S2XWd7cyJdtTJWOTTWYEpk
Message-ID: <CAE9FiQWo2LfGuGpZdWYapU-VxHuwDkGbAdqfBKif9XzH59QBkw@mail.gmail.com>
Subject: Re: [PATCH v7u1 27/31] x86, kdump: remove crashkernel range find
 limit for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 7:43 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 03, 2013 at 04:48:47PM -0800, Yinghai Lu wrote:
>> Now kexeced kernel/ramdisk could be above 4g, so remove 896 limit for
>> 64bit.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/kernel/setup.c |    4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index c58497e..6adbc45 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -501,13 +501,11 @@ static void __init memblock_x86_reserve_range_setup_data(void)
>>  /*
>>   * Keep the crash kernel below this limit.  On 32 bits earlier kernels
>>   * would limit the kernel to the low 512 MiB due to mapping restrictions.
>> - * On 64 bits, kexec-tools currently limits us to 896 MiB; increase this
>> - * limit once kexec-tools are fixed.
>
> Does this mean that kexec-tools has been fixed too?

with the patcheset that i sent to kexec-tools mailing list.
