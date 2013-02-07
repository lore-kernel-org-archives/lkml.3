Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3BGLpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:45:24 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:33578 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3BGLpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:45:21 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: Re: [PATCH v2] fat: eliminate iterations in fat_search_long and __fat_readdir in case of EOD
References: <1359989028-7457-1-git-send-email-linkinjeon@gmail.com>
Date: Thu, 07 Feb 2013 20:45:14 +0900
In-Reply-To: <1359989028-7457-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Mon, 4 Feb 2013 23:43:47 +0900")
Message-ID: <87bobw4ab9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> When doing lookups via fat_search_long(), we can stop checking for
> further entries if we detect End of Directory, i.e. if (de->name[0] ==
> 0x00).The current code traverses the cluster chain of a directory until a hit
> is found or till the last cluster for that directory, ignoring the EOD
> mark. Fix this.
>
> Likewise,when readdir(3) is called, we can stop checking for further
> entries in __fat_readdir() when we hit EOD.

Don't we need to change fat_get_short_entry()? And did this work
correctly about f_pos for readdir?

I'm not thinking about f_pos deeply though, it may have something
wrong. Because it stops at middle of cluster.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
