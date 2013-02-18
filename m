Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3BROiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:38:13 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37793 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3BROiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:38:12 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v6 4/7] fat: restructure export_operations
References: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com>
	<87fw0t3mq0.fsf@devron.myhome.or.jp>
	<CAKYAXd9cxUJwObHUfh0Rf9jVLzmvpfnYx4AKw6tsSAX-jzDusA@mail.gmail.com>
Date: Mon, 18 Feb 2013 23:38:07 +0900
In-Reply-To: <CAKYAXd9cxUJwObHUfh0Rf9jVLzmvpfnYx4AKw6tsSAX-jzDusA@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 18 Feb 2013 23:03:45 +0900")
Message-ID: <87d2vxznzk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> +     if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
>>> +             *lenp = FAT_FID_SIZE_WITH_PARENT;
>>> +             return 255;
>>> +     } else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
>>> +             *lenp = FAT_FID_SIZE_WITHOUT_PARENT;
>>> +             return 255;
>>> +     }
>>
>> This check strange. "parent && len == FAT_FID_SIZE_WITHOUT_PARENT" will
>> overwrite over limit of fh size?
> I need to check more. because I followed the logic in
> export_encode_fh() function.

Ah, my fault, it doesn't have real problem. But code is quite strange.

If input is "parent && len >= FAT_FID_SIZE_WITHOUT_PARENT", "else if
(len < FAT_FID_SIZE_WITHOUT_PARENT)" check is entirely useless, but this
code itself checks "len".

if (parent) {
	if (len < FAT_FID_SIZE_WITH_PARENT)
		/* error */
} else {
	if (len < FAT_FID_SIZE_WITHOUT_PARENT)
		/* error */
}

I think this would readable, and I guess this will generates faster/simpler
code (at least, this doesn't depends an optimization of gcc).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
