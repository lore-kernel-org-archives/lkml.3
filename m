Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3END3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:29:48 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:34158 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3END3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130513214216.GA23743@kroah.com>
References: <1367416573-5430-1-git-send-email-rlove@google.com>
	<20130513214216.GA23743@kroah.com>
Date: Tue, 14 May 2013 11:29:46 +0800
Message-ID: <CA+2_TiZ3dECAW8LV-Es=BjHCwgWw69zbWkr73at+0_c-EaDHmA@mail.gmail.com>
Subject: Re: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
From: Neil Zhang <glacier1980@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: raulxiong@gmail.com, Robert Love <rlove@google.com>,
        Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>, Dad <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/14 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Wed, May 01, 2013 at 09:56:13AM -0400, Robert Love wrote:
>> Don't acquire ashmem_mutex in ashmem_shrink if we've somehow recursed
>> into the
>> shrinker code from within ashmem. Just bail out, avoiding a deadlock.
>> This is
>> fine, as ashmem cache pruning is advisory anyhow.
>>
>> Signed-off-by: Robert Love <rlove@google.com>
>> ---
>>  drivers/staging/android/ashmem.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Based on Andrew's review comments, I'll drop this from my queue and wait
> for a "better" fix for this.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

We found the similar issue these days.
Add RaulXiong to paste the call stack.

Best Regards,
Neil Zhang
