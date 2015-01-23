Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbbAWNZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:25:39 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:40968 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbbAWNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:25:37 -0500
MIME-Version: 1.0
In-Reply-To: <20150122172501.GE40116@unpythonic.net>
References: <aksgarg1989@gmai.com>
	<1421934850-77446-1-git-send-email-aksgarg1989@gmail.com>
	<20150122172501.GE40116@unpythonic.net>
Date: Fri, 23 Jan 2015 18:55:36 +0530
Message-ID: <CA+HOOsiP-uLJPJzn=24XiodaK89-y7Fy8oj+ALnbw4iHdtGR5A@mail.gmail.com>
Subject: Re: [PATCH] lib/kstrtox.c clean kstrtoll function
From: Anshul Garg <aksgarg1989@gmail.com>
To: Jeff Epler <jepler@unpythonic.net>
Cc: akpm@linux-foundation.org, Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org,
        "anshul.g@samsung.com" <anshul.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Jeff,

Thanks for the comments.

Yes i think overflow check logic is wrong.

So i think we can change the overflow logic -

>From --

if ((long long)tmp < 0)
+ return -ERANGE;

to -

if (((long long)tmp < LLONG_MIN) || ((long long)tmp > LLONG_MAX) )
+ return -ERANGE;

Please give your views on this change..
If this change seems correct i will update overflow logic
in my sent patch.


Hope to hear from you soon.

Thanks
Anshul Garg


On Thu, Jan 22, 2015 at 10:55 PM, Jeff Epler <jepler@unpythonic.net> wrote:
> On Thu, Jan 22, 2015 at 05:54:10AM -0800, Anshul Garg wrote:
>> -             if ((long long)(-tmp) >= 0)
>> -                     return -ERANGE;
>> -             *res = -tmp;
> ...
>> +     if ((long long)tmp < 0)
>> +             return -ERANGE;
>> +     *res = sign * tmp;
>
> I don't believe overflow handling is correct anymore with this patch.
> Did you try with the input as the most negative possible unsigned long?
>
> Jeff
