Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3JGDWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 23:22:35 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64711 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3JGDWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 23:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130510102754.184cd90d@corrin.poochiereds.net>
References: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
	<20130510102754.184cd90d@corrin.poochiereds.net>
Date: Sun, 6 Oct 2013 22:22:31 -0500
Message-ID: <CADT32eJz0v-ChdfeuLuRaPER-4_vgMy7Q1Z5PQXy0MY67aSuxg@mail.gmail.com>
Subject: Re: Mount failure due to restricted access to a point along the mount path
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Jayaraman <sjayaraman@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So instead of breaking superblock sharing and fscache functionality
with 2), it may be better off to explore 1).  Will spend some time doing so.

Regards,

Shirish

On Fri, May 10, 2013 at 9:27 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Fri, 10 May 2013 16:13:30 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Hi,
>>
>> A while ago this was discussed:
>>
>>   http://thread.gmane.org/gmane.linux.kernel.cifs/7779
>>
>> This is essentially a regression introduced by the shared superblock
>> changes in 3.0 and several SUSE customers are complaining about it.
>> I've created a temporary fix which reverts 29 commits related to the
>> shared superblock changes.  It works, but it's obviously not a
>> permanent fix, especially since we definitely don't want to diverge
>> from mainline.
>>
>> Is this issue being worked on?  Don't other distros have similar reports?
>>
>> Thanks,
>> Miklos
>
> I don't know of anyone currently working on it. There are a couple of
> possible approaches to fixing it, I think:
>
> 1) if the dentries to get down to the root of the mount don't already
> exist, then attach some sort of "placeholder" inode that can be fleshed
> out later if and when the dentry is accessed via other means.
>
> 2) do something like what NFS does (see commit 54ceac45). This becomes
> a bit more complicated due to the fact that the server may not hand out
> real inode numbers and we sometimes have to fake them up.
>
> #1 is probably simpler to implement, but I'll confess that I haven't
> thought through all of the potential problems with it.
>
> --
> Jeff Layton <jlayton@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
