Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaGTKsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 06:48:06 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58562 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaGTKsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 06:48:04 -0400
MIME-Version: 1.0
In-Reply-To: <53CB708B.7010508@parallels.com>
References: <53CB708B.7010508@parallels.com>
Date: Sun, 20 Jul 2014 12:48:02 +0200
Message-ID: <CAFLxGvxf_bsLNKRtt05zgkdHy+7ALWMz29QUG=f9UwTcqXetfg@mail.gmail.com>
Subject: Re: [patch v2] fs: umount on symlinlk leaks mnt count
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Vasily Averin <vvs@parallels.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 9:32 AM, Vasily Averin <vvs@parallels.com> wrote:
> v2: mntget(path->mnt) should not be called if mountpoint_last() returns 1.
>
> Currently umount on symlink blocks following umount:
>
> /vz is separate mount
>
> # ls /vz/ -al | grep test
> drwxr-xr-x.  2 root root       4096 Jul 19 01:14 testdir
> lrwxrwxrwx.  1 root root         11 Jul 19 01:16 testlink -> /vz/testdir
>
> # umount -l /vz/testlink
> umount: /vz/testlink: not mounted (expected)
>
> # lsof /vz
> # umount /vz
> umount: /vz: device is busy. (unexpected)
>
> In this case mountpoint_last() gets an extra refcount on path->mnt
>
> Signed-off-by:  Vasily Averin <vvs@openvz.org>

Sounds reasonable to me.
Can you please send the patch inline and not as attachment?

-- 
Thanks,
//richard
