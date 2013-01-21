Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3AUFlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:41:16 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:55201 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3AUFlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:41:14 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: Re: [PATCH] fat: eliminate iterations in fat_search_long in case of EOD
References: <1358561990-8216-1-git-send-email-linkinjeon@gmail.com>
	<87vcasxgre.fsf@devron.myhome.or.jp>
	<CAKYAXd_DH+O4PKUsfQKVVXoi84Sm2f64A3+aESOgQb9JvX_e+w@mail.gmail.com>
Date: Mon, 21 Jan 2013 14:41:09 +0900
In-Reply-To: <CAKYAXd_DH+O4PKUsfQKVVXoi84Sm2f64A3+aESOgQb9JvX_e+w@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 21 Jan 2013 13:15:17 +0900")
Message-ID: <87ip6rxfd6.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2013/1/20, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>
>>> When searching a directory for names, we can stop checking for further
>>> entries if we detect End of Directory, i.e. if (de->name[0] == 0x00).The
>>> current code traverses the cluster chain of a directory until a hit is
>>> found or till the last cluster for that directory, ignoring the EOD mark.
>>> Fix this.
>>
>> f_pos still works fine after this change?
> Hi OGAWA.
> I can not find f_pos usage in fat_search_long function.
> Maybe, Have you seen other function such as __fat_readdir ?
> Let me know your opinion.

Ah, I see. Only ->lookup. So, this makes behavior more strange.
I.e. readdir() returns beyond 0, but lookup() can't find it?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
