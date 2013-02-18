Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3BROtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:49:40 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62481 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3BROtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <87d2vxznzk.fsf@devron.myhome.or.jp>
References: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com>
	<87fw0t3mq0.fsf@devron.myhome.or.jp>
	<CAKYAXd9cxUJwObHUfh0Rf9jVLzmvpfnYx4AKw6tsSAX-jzDusA@mail.gmail.com>
	<87d2vxznzk.fsf@devron.myhome.or.jp>
Date: Mon, 18 Feb 2013 23:49:38 +0900
Message-ID: <CAKYAXd-DZ+bXNve22ei2RXT1atH0nKp6=qbE_e+5j8+oZAg2pQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] fat: restructure export_operations
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> +     if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
>>>> +             *lenp = FAT_FID_SIZE_WITH_PARENT;
>>>> +             return 255;
>>>> +     } else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
>>>> +             *lenp = FAT_FID_SIZE_WITHOUT_PARENT;
>>>> +             return 255;
>>>> +     }
>>>
>>> This check strange. "parent && len == FAT_FID_SIZE_WITHOUT_PARENT" will
>>> overwrite over limit of fh size?
>> I need to check more. because I followed the logic in
>> export_encode_fh() function.
>
> Ah, my fault, it doesn't have real problem. But code is quite strange.
>
> If input is "parent && len >= FAT_FID_SIZE_WITHOUT_PARENT", "else if
> (len < FAT_FID_SIZE_WITHOUT_PARENT)" check is entirely useless, but this
> code itself checks "len".
>
> if (parent) {
>         if (len < FAT_FID_SIZE_WITH_PARENT)
>                 /* error */
> } else {
>         if (len < FAT_FID_SIZE_WITHOUT_PARENT)
>                 /* error */
> }
>
> I think this would readable, and I guess this will generates faster/simpler
> code (at least, this doesn't depends an optimization of gcc).
I agree. I will change it as your opinion.
Thanks a lot, OGAWA!.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
