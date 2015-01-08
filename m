Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbbAHNuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:50:18 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:63303 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbbAHNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:50:16 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <54AD4B1B.1030801@gmail.com>
References: <1420219609-2568-1-git-send-email-waydi1@gmail.com>
	<54A8AC74.2060106@huawei.com>
	<54ABEB06.2010008@gmail.com>
	<54ACA052.8010800@huawei.com>
	<54AD4B1B.1030801@gmail.com>
Date: Thu, 8 Jan 2015 14:50:15 +0100
Message-ID: <CAJfpegsLg2UL06kR=0njvo9Lgdu20BsxxrHw0TyfokLNUg30dg@mail.gmail.com>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
From: Miklos Szeredi <miklos@szeredi.hu>
To: Seunghun Lee <waydi1@gmail.com>
Cc: hujianyang <hujianyang@huawei.com>, Sedat Dilek <sedat.dilek@gmail.com>,
        richard.weinberger@gmail.com,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 4:04 PM, Seunghun Lee <waydi1@gmail.com> wrote:
>> On 2015/1/6 22:02, Seunghun Lee wrote:
>>> After patch:
>>> root@qemux86:~# mount -t overlay overlay -olowerdir=lower:lower2 merged
>>> mount: warning: merged seems to be mounted read-only.
>>> root@qemux86:~# mount | grep overlay
>>> overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
>>> root@qemux86:~# mount -o remount,rw merged
>>> mount: warning: /home/root/merged seems to be mounted read-only.
>>> root@qemux86:~# mount | grep overlay
>>> overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
>>> root@qemux86:~# echo hi > merged/hi
>>> -sh: merged/hi: Read-only file system
>>> root@qemux86:~#
>>>
>> If users want a rw mount, can we give them a ro mount? I think it's
>> wrong, .remount_fs should refuse this request.

Yeah.  Applied fixed patch.

Thanks,
Mikos
