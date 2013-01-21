Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3AUGkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:40:32 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:64175 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3AUGkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <87ip6rxfd6.fsf@devron.myhome.or.jp>
References: <1358561990-8216-1-git-send-email-linkinjeon@gmail.com>
	<87vcasxgre.fsf@devron.myhome.or.jp>
	<CAKYAXd_DH+O4PKUsfQKVVXoi84Sm2f64A3+aESOgQb9JvX_e+w@mail.gmail.com>
	<87ip6rxfd6.fsf@devron.myhome.or.jp>
Date: Mon, 21 Jan 2013 15:40:30 +0900
Message-ID: <CAKYAXd-bjbKfyB_S3nEGA5s9HfZ-MzJurk6WtDFoHkfDhyfQOw@mail.gmail.com>
Subject: Re: [PATCH] fat: eliminate iterations in fat_search_long in case of EOD
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/21, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> 2013/1/20, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>>
>>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>>
>>>> When searching a directory for names, we can stop checking for further
>>>> entries if we detect End of Directory, i.e. if (de->name[0] ==
>>>> 0x00).The
>>>> current code traverses the cluster chain of a directory until a hit is
>>>> found or till the last cluster for that directory, ignoring the EOD
>>>> mark.
>>>> Fix this.
>>>
>>> f_pos still works fine after this change?
>> Hi OGAWA.
>> I can not find f_pos usage in fat_search_long function.
>> Maybe, Have you seen other function such as __fat_readdir ?
>> Let me know your opinion.
>
> Ah, I see. Only ->lookup. So, this makes behavior more strange.
> I.e. readdir() returns beyond 0, but lookup() can't find it?
Yes, Good point. I will check other places included readdir.
Thanks for review!
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
