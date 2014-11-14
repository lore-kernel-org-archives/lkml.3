Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422701AbaKNVgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:36:18 -0500
Received: from mout.gmx.net ([212.227.15.19]:61004 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161872AbaKNVgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:36:17 -0500
Message-ID: <54667480.2040703@gmx.de>
Date: Fri, 14 Nov 2014 22:30:40 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@parisplace.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ftruncate, truncate: create fanotify events
References: <20141007192330.GE30038@quack.suse.cz> <1414100107-3750-1-git-send-email-xypron.glpk@gmx.de> <20141110203029.GA8125@quack.suse.cz> <20141111073415.GA21776@infradead.org> <20141111110943.GD10456@quack.suse.cz> <546269AE.4050200@gmx.de> <20141114100135.GB17262@quack.suse.cz>
In-Reply-To: <20141114100135.GB17262@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:eNMzAWIHzPlwaSnkIJshIHs7epYObC3imSVo8LiclhHhskYyhW0
 gLIwj8SgcUGFvg1Z3rgHzVEUVl5jkokbLXhPNe1U/hO7bqqVN7XCBvVUZz75W0dYwQkC+BH
 G4L/i9YhbXztCYyVc7MqW2QxawwyLHSTREvfgMxY5NKp+IYksAnSHtqm0ThsJ/d+2qrve77
 +YRrahDV9JYJdQhBF3vbg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

thank you for the review.

On 14.11.2014 11:01, Jan Kara wrote:
>>
>> We only want to create FAN_MODIFY events for ATTR_SIZE. So only for
>> these events we need a path.
>>
>> To my knowledge notify_change is called with ATTR_SIZE from
>> do_truncate(), ecryptfs_truncate() and will be called with ATTR_SIZE
>> from ovl_setattr() for a truncation.
>    There's also a call in fs/cachefiles/interface.c: cachefiles_attr_changed()
> and fs/hpfs/namei.c: hpfs_unlink() and nfs plays with ATTR_SIZE although I
> wasn't able to track down whether it actually passes it to notify_change().

cachefiles_attr_changed() contains two calls to notify_change(). Both 
calls pass ATTR_SIZE as sole attribute.

In cachefiles_attr_changed() we can create a path object with
path.dentry = object->backer;
path.mnt = cache->mnt;

In hpfs_unlink() a truncation occurs only if deletion fails.
I do not see how to access a path here.

notify_change() is not called in directory fs/nfs.
grep -GHrn notify_change fs/nfs/
This does not test for any indirect call.

Best regards

Heinrich Schuchardt


