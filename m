Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3LNLoE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 06:44:04 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60433 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3LNLoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 06:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <52AC3EF1.6090106@oracle.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-2-git-send-email-zwu.kernel@gmail.com>
	<20131213163211.GD20803@infradead.org>
	<52AC3EF1.6090106@oracle.com>
Date: Sat, 14 Dec 2013 19:43:59 +0800
Message-ID: <CAEH94LiiFjDM9GT6ncGYuQmC+T-6w-r1_svuqGZ43Bsd9Zt64w@mail.gmail.com>
Subject: Re: [PATCH 1/5] xfs: factor prid related codes into xfs_get_initial_prid()
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 7:20 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 12/14 2013 00:32 AM, Christoph Hellwig wrote:
>>> +static inline prid_t xfs_get_initial_prid(struct xfs_inode *dp)
>>> +{
>>> +    if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
>>> +            return xfs_get_projid(dp);
>>> +    else
>>> +            return XFS_PROJID_DEFAULT;
>>> +}
>>
>> You could skip the else here.
> Except that, I'd suggest we move this helper to proper header file with
> further refactoring in xfs_symlink(), and it could be a separate patch.
Good point, will apply it, thanks.

>
> Thanks,
> -Jeff



-- 
Regards,

Zhi Yong Wu
