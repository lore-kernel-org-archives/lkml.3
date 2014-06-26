Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaFZJax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:30:53 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:55677 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbaFZJaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <1403703728.20275.33.camel@sauron.fi.intel.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	<alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	<1403677528.7903.103.camel@sauron.fi.intel.com>
	<CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
	<1403690184.20275.11.camel@sauron.fi.intel.com>
	<CABhLV02COaH=qP=Snd7YJtcVOvm9NTmY58QuiTQoPZxH3NemPQ@mail.gmail.com>
	<1403703728.20275.33.camel@sauron.fi.intel.com>
Date: Thu, 26 Jun 2014 11:30:34 +0200
Message-ID: <CAM3PqV6NFkjfBEm25V6WScxCvAvTFNkhCYJv+GAvFJ5pZ_E-Zw@mail.gmail.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: dedekind1@gmail.com
Cc: Thomas Knauth <thomas.knauth@gmx.de>, David Rientjes <rientjes@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With a binary interface like an ioctl I can see how you could have extra
> unused fields which you can ignore now and let people start adding extra
> options like the range in the future.

Yes, ioctl is another possibility. But I would argue that sysctl is
more convenient interface, because idea of sdrop_caches is similar to
drop_caches's one and it is convenient to have these interfaces in the
same place. But if sdrop_caches uses procfs it seems that there is no
easy way to pass parameters of different types in one write operation.

> Other questions I'd ask would be - how about the access control model?
> Will only root be able to drop caches? Why can't I drop caches for my
> own file?

Access control model is the same as for drop_caches. This means that
only root can write to this file. But it is easy to add a feature that
allows any user to clean page cache of inodes that this user owns.

2014-06-25 15:42 GMT+02:00 Artem Bityutskiy <dedekind1@gmail.com>:
> On Wed, 2014-06-25 at 15:23 +0200, Thomas Knauth wrote:
>> On Wed, Jun 25, 2014 at 11:56 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>> > Thanks for the answer, although you forgot to comment on the question
>> > about possibly extending the new interface to work with file ranges in
>> > the future. For example, I have a 2 TiB file, and I am only interested
>> > in dropping caches for the first couple of gigabytes. Would I extend
>> > your interface, or would I come up with another one?
>>
>> Ah, didn't quite understand what was meant with file ranges. Again, we
>> had not considered this so far. I guess you could make a distinction
>> between directories and files here. If the path points to a file, you
>> can have an optional argument indicating the range of bytes you would
>> like to drop. Something like
>>
>> echo "my-file 0-1000,8000-1000" > /proc/sys/vm/sdrop_cache
>>
>> If this is desirable, we can add it to the patch.
>
> With a binary interface like an ioctl I can see how you could have extra
> unused fields which you can ignore now and let people start adding extra
> options like the range in the future.
>
> With this kind of interface I am not sure how to do this.
>
> Other questions I'd ask would be - how about the access control model?
> Will only root be able to drop caches? Why can't I drop caches for my
> own file?
>
> I did not put much thinking into this, but it looks like ioctl could be
> a better interface for the task you are trying to solve...
>
> Sorry if I am a bit vague, I am mostly trying to make you guys give this
> more thoughts, and come up with a deeper analysis. Interfaces are very
> important to get right, or as right as possible...
>
> --
> Best Regards,
> Artem Bityutskiy
>



-- 
Regards,
Maksym Planeta.
