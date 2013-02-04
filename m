Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3BDUkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:40:49 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:57775 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3BDUks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:40:48 -0500
MIME-Version: 1.0
In-Reply-To: <1359834211.2831.5.camel@joe-AO722>
References: <CALF0-+XX27u4rmpe8RHiy5DsbHvoYP9DWQts+rTRfEvPQG4s8Q@mail.gmail.com>
	<CALF0-+V-8m1TwnM0MUbNCncnECF_r_FVcyu_Duu0tqcsPoFR5A@mail.gmail.com>
	<1359834211.2831.5.camel@joe-AO722>
Date: Mon, 4 Feb 2013 17:40:47 -0300
Message-ID: <CALF0-+X_L-wJs9TSsotEDrJ-jbQ9+JBLxqyRDWBdNqgXujthOA@mail.gmail.com>
Subject: Re: Question about printking
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        kernel-janitors@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sat, Feb 2, 2013 at 4:43 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2013-02-02 at 16:30 -0300, Ezequiel Garcia wrote:
>> ptr = kmalloc(sizeof(foo));
>> if (!ptr) {
>>         pr_err("Cannot allocate memory for foo\n");
>>         return -ENOMEM;
>> }
>> His argue against it was that kmalloc already takes care of reporting/printking
>> a good deal of interesting information when this happens.
>
>> Can someone expand a bit on this whole idea? (of abuse of printing,
>> or futility of printing).
>
> k.alloc() takes a GFP_ flag as an arg.
>
> One of those GFP flags is __GFP_NOWARN.
>
> For all failed allocs without GFP_NOWARN
> a message is emitted and a dump_stack is
> done.
>
> (see: mm/page_alloc.c warn_alloc_failed())
>
> So, most all of these printks after
> k.alloc()'s are not necessary.
>
>

Thanks for the explanation.

BTW, I see you've made some patches to fix exactly this.
Nice job.

Regards,

-- 
    Ezequiel
