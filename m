Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422830Ab3FUHaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:30:18 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34546 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3FUHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <1371789772.14296.9.camel@lcm>
References: <1370694303-2738-1-git-send-email-linkinjeon@gmail.com>
	<1370824712.22405.18.camel@lcm>
	<CAKYAXd-V9iF0o5nvFyFPgJX0waDLh4c_eNJ7V_o-tbbrtX1JLQ@mail.gmail.com>
	<1370929716.14857.8.camel@lcm>
	<CAKYAXd98cgBU_JzL3zx2qT87H-XdqntdKYbCdOsx9gCeDwUO4Q@mail.gmail.com>
	<CAKYAXd_44td8BDbnuGR-ChHXjmhTnoVNq4vgujgAyAtbO6vayw@mail.gmail.com>
	<1371789772.14296.9.camel@lcm>
Date: Fri, 21 Jun 2013 16:30:16 +0900
Message-ID: <CAKYAXd8RQvY+-xRam2yymERAAf8oUEJ0Rznaev_ixy+xR=Ecrg@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH 1/4] f2fs: reorganize the f2fs_setattr() function.
From: Namjae Jeon <linkinjeon@gmail.com>
To: Changman Lee <cm224.lee@samsung.com>
Cc: jaegeuk.kim@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Sorry for late. I was very busy.
>
> Could you tell me if it happens difference between xattr and i_mode,
> what will you do?
First of all, I want to know which case make mismatching permission
between xattr and i_mode.
And when we call chmod, inode is locked in sys_chmod. If so,
inode->i_mode can be changed by any updated inode during chmod
although inode is locked ?

> The purpose of i_acl_mode is used to update i_mode and xattr together in
> same lock region.
Could you please tell me what is same lock region ? (inode->i_mutex or
mutex_lock_op(sbi))

Thanks.
>
>>
>> >
>> > ----------------------------------------------------------------------------------------------------------------
>> > Subject: [PATCH v2] f2fs: reorganize the f2fs_setattr(), f2fs_set_acl,
>> > f2fs_setxattr()
>> > From: Namjae Jeon <namjae.jeon@samsung.com>
>> >
