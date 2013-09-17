Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3IQPgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:36:52 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39923 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3IQPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:36:50 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130917114404.GI13318@ZenIV.linux.org.uk>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
	<1379335925-30858-3-git-send-email-miklos@szeredi.hu>
	<20130916181938.GD13318@ZenIV.linux.org.uk>
	<CAJfpegt3mAKVE7ToZbvPpFQCY1EAZ3tKfn__kfpGz4HeXWr8fw@mail.gmail.com>
	<20130916195003.GE13318@ZenIV.linux.org.uk>
	<CAJfpegsLeuw55Diw0yDmiFR+7qkSkOrW2fUbjmzFC9OxVsrAkQ@mail.gmail.com>
	<20130916220241.GF13318@ZenIV.linux.org.uk>
	<20130916232810.GG13318@ZenIV.linux.org.uk>
	<CAJfpegtJwgFNNQQB3AX9umsK+RacpQFSoakAMs++w6TT9x0yGw@mail.gmail.com>
	<20130917114404.GI13318@ZenIV.linux.org.uk>
Date: Tue, 17 Sep 2013 17:36:49 +0200
Message-ID: <CAJfpegtSVYStQQuJvd6CWAy-ZM6v8tmTcL5uz=iA1aHM72TeQQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] 9p: fix dentry leak in v9fs_vfs_atomic_open_dotl()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "M. Mohan Kumar" <mohan@in.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 1:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Sep 17, 2013 at 12:16:56PM +0200, Miklos Szeredi wrote:
>
>> Just one. This needs to be removed, since this condition is now
>> explicitly allowed and later checked for:
>>
>>     if (WARN_ON(excl && !(*opened & FILE_CREATED)))
>>         *opened |= FILE_CREATED;
>
> D'oh...  Fixed and pushed.

Okay, but moving the fsnotify_create()  to after the no-open section
is wrong, I think,  It's needed for the case of ->atomic_open() doing
lookup/create/no_open too.

Thanks,
Miklos
