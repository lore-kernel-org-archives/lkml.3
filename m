Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966973Ab3HJQrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:47:46 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:54177 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966547Ab3HJQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:47:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAMyfujeC_p-2cJteayPnA82wPRvoL2ekDNB6bd38d76v7Gb+6w@mail.gmail.com>
References: <CAMyfujfZayb8_673vkb2hdE9J_w+wPTD4aQ6TsY+aWxb9EzY8A@mail.gmail.com>
 <1376080406-4r7r3uye-mutt-n-horiguchi@ah.jp.nec.com> <CAMyfujeC_p-2cJteayPnA82wPRvoL2ekDNB6bd38d76v7Gb+6w@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 10 Aug 2013 12:47:24 -0400
Message-ID: <CAHGf_=odM+yTTLvqwEw8MztkFEf_kjxvixDqn3g4hpCed4fEzQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] pagemap: fix buffer overflow in add_page_map()
To: yonghua zheng <younghua.zheng@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 8:49 PM, yonghua zheng <younghua.zheng@gmail.com> wrote:
> Update the patch according to Naoya's comment, I also run
> ./scripts/checkpatch.pl, and it passed ;D.
>
> From 96826b0fdf9ec6d6e16c2c595f371dbb841250f7 Mon Sep 17 00:00:00 2001
> From: Yonghua Zheng <younghua.zheng@gmail.com>
> Date: Mon, 5 Aug 2013 12:12:24 +0800
> Subject: [PATCH 1/1] pagemap: fix buffer overflow in add_to_pagemap()
>
> In struc pagemapread:
>
> struct pagemapread {
>     int pos, len;
>     pagemap_entry_t *buffer;
>     bool v2;
> };
>
> pos is number of PM_ENTRY_BYTES in buffer, but len is the size of buffer,
> it is a mistake to compare pos and len in add_to_pagemap() for checking
> buffer is full or not, and this can lead to buffer overflow and random
> kernel panic issue.
>
> Correct len to be total number of PM_ENTRY_BYTES in buffer.
>
> Signed-off-by: Yonghua Zheng <younghua.zheng@gmail.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
