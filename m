Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3CJTF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 15:05:27 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59392 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3CJTF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 15:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGD1fXsGMCQbP8aAMDsRiwPD2hHcfWfupO4jy5=JCM=NA@mail.gmail.com>
References: <1362920779-25925-1-git-send-email-alex.grad@gmail.com>
	<CAOJsxLGD1fXsGMCQbP8aAMDsRiwPD2hHcfWfupO4jy5=JCM=NA@mail.gmail.com>
Date: Sun, 10 Mar 2013 21:05:25 +0200
Message-ID: <CAEnQRZB3MGgmDwY8+bHc60f6vts5TgyhBycvhSwn9s6O4px5ow@mail.gmail.com>
Subject: Re: [PATCH] kgdb: Removed kmalloc returned value cast
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Alex Grad <alex.grad@gmail.com>, benh@kernel.crashing.org,
        paulus@samba.org, mikey@neuling.org, tiejun.chen@windriver.com,
        jason.wessel@windriver.com, fr@canb.auug.org.au,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 4:10 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sun, Mar 10, 2013 at 3:06 PM, Alex Grad <alex.grad@gmail.com> wrote:
>> Signed-off-by: Alex Grad <alex.grad@gmail.com>
>> ---
>>  arch/powerpc/kernel/kgdb.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
>> index 5ca82cd..c1eef24 100644
>> --- a/arch/powerpc/kernel/kgdb.c
>> +++ b/arch/powerpc/kernel/kgdb.c
>> @@ -159,7 +159,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
>>         if (user_mode(regs))
>>                 return 0;
>>
>> -       backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>> +       backup_current_thread_info = kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>
> Looks good to me.
>
> There's two additional problems in the kgdb_singlestep() function: it
> doesn't check if the kmalloc() call fails nor does it kfree() the
> allocated memory.

Hi Pekka,

Indeed there is no check if kmalloc() fails. This should be fixed.

Anyhow, commit fefd9e6f powerpc: kernel/kgdb.c: Fix memory leakage
fixed the problem with kfree.

thanks,
Daniel.
