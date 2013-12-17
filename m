Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3LQEGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 23:06:22 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42092 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3LQEGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 23:06:21 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 23:06:21 EST
Date: Mon, 16 Dec 2013 20:58:48 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Li Wang <liwang@ubuntukylin.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 0/5] VFS: Directory level cache cleaning
Message-ID: <20131217035847.GA10392@parisc-linux.org>
References: <cover.1387205337.git.liwang@ubuntukylin.com> <CAM_iQpUSX1yX9SMvUnbwZ7UkaBMUheOEiZNaSb4m8gWBQzzGDQ@mail.gmail.com> <52AFC020.10403@ubuntukylin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AFC020.10403@ubuntukylin.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:08:16AM +0800, Li Wang wrote:
> As far as we know, fadvise(DONTNEED) does not support metadata
> cache cleaning. We think that is desirable under massive small files
> situations. Another thing is that do people accept the behavior
> of feeding a directory fd to fadvise will recusively clean all
> page caches of files inside that directory?

I think there's a really good permissions-related question here.
If that's an acceptable interface, should one have to be CAP_SYS_ADMIN
to issue the request?  What if some of the files below this directory
are not owned by the user issuing the request?

> On 2013/12/17 1:45, Cong Wang wrote:
>> On Mon, Dec 16, 2013 at 7:00 AM, Li Wang <liwang@ubuntukylin.com> wrote:
>>> This patch extend the 'drop_caches' interface to
>>> support directory level cache cleaning and has a complete
>>> backward compatibility. '{1,2,3}' keeps the same semantics
>>> as before. Besides, "{1,2,3}:DIRECTORY_PATH_NAME" is allowed
>>> to recursively clean the caches under DIRECTORY_PATH_NAME.
>>> For example, 'echo 1:/home/foo/jpg > /proc/sys/vm/drop_caches'
>>> will clean the page caches of the files inside 'home/foo/jpg'.
>>>
>>
>> This interface is ugly...
>>
>> And we already have a file-level drop cache, that is,
>> fadvise(DONTNEED). Can you extend it if it can't
>> handle a directory fd?
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
