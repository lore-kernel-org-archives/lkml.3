Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaCKWWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:22:37 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:47154 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbaCKWWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:22:36 -0400
MIME-Version: 1.0
In-Reply-To: <1394306073.32104.4.camel@x220>
References: <cover.1394304585.git.luto@amacapital.net> <16072d10240583debb7d303136c507c32c4d4b5d.1394304585.git.luto@amacapital.net>
 <1394306073.32104.4.camel@x220>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Mar 2014 15:22:14 -0700
Message-ID: <CALCETrVmz-UkZ2p6nou7Twapb_Rcdf7M6JwGeisvpZ4rZmUvxg@mail.gmail.com>
Subject: Re: [PATCH 4/4] raid6: Add severity levels to raid6 initialization messages
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ken Steele <ken@tilera.com>, Nicolas Pitre <nico@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 11:14 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sat, 2014-03-08 at 10:58 -0800, Andy Lutomirski wrote:
>> Some of them are errors; some are not.  Annotate them accordingly.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  lib/raid6/algos.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
>> [...]
>> @@ -194,7 +195,7 @@ int __init raid6_select_algo(void)
>>       syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
>>
>>       if (!syndromes) {
>> -             printk("raid6: Yikes!  No memory available.\n");
>> +             printk(KERN_ERR "raid6: Yikes!  No memory available.\n");
>>               return -ENOMEM;
>>       }
>>
>
> Does __get_free_pages() print and error (or similar) when it fails? If
> so, this printk() could be dropped, couldn't it?

I think it does in warn_alloc_failed in mm/page_alloc.c.  It might not
be clear what the impact of that error is, but, empirically, if
there's too little memory during boot, everything is thoroughly broken
anyway.

>
>
> Paul Bolle
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
