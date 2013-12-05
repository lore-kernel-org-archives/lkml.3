Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3LEOI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:08:29 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:40133 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3LEOI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <87a9gkeopt.fsf@devron.myhome.or.jp>
References: <1384688277-2901-1-git-send-email-linkinjeon@gmail.com>
	<87a9gkeopt.fsf@devron.myhome.or.jp>
Date: Thu, 5 Dec 2013 23:08:27 +0900
Message-ID: <CAKYAXd8-zrte4xMT8PdYXkEAwrXHk3H8=4imb4Qt3bk8iUKoWA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] fat: add fat_fallocate operation
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/1, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +			err = fat_get_cluster(inode, FAT_ENT_EOF,
>> +					&fclus, &dclus);
>> +			if (err < 0) {
>> +				fat_msg(sb, KERN_ERR,
>> +					"fat_fallocate(): fat_get_cluster() error");
>> +				goto error;
>> +			}
>> +			free_bytes = ((fclus + 1) << sbi->cluster_bits) -
>> +				inode->i_size;
>
> What is wrong if we just used ->mmu_private here, instead of fclus?
It is not wrong. We can make it more simpler if we use mmu_private here.
I will change it.
Thanks for review.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
