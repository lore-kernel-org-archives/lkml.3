Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab3JTKkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 06:40:05 -0400
Received: from outbound-ss-330.hostmonster.com ([74.220.205.49]:42172 "HELO
	outbound-ss-330.hostmonster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751024Ab3JTKkD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 06:40:03 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Oct 2013 06:40:03 EDT
Subject: Re: [RFC] Rollback FS
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
Date: Sun, 20 Oct 2013 14:43:15 +0400
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 20, 2013, at 11:06 AM, jiaweiwei wrote:

> Hi all,
> 
> Recently, I just do some stupid stuffs as follows.
> 
> # mv /lib/x86_64-linux-gnu/libc.so.6  /tmp
> 
> After move "/lib/x86_64-linux-gnu/libc.so.6" away, you could not run lots
> of commands, which show you some errors like this.
> 
> # ls
> ls: error while loading shared libraries: libc.so.6: cannot open
> shared object file: No such file or directory
> # mv
> mv: error while loading shared libraries: libc.so.6: cannot open
> shared object file: No such file or directory
> ...
> 
> Because they all depend on libc.so.
> 
> You could also happen to above boring stuffs when you remove some key
> files in Linux OS. Now, I have a good idea to solve above problems.
> 
> We could implement a File System to record all the operations which
> send to VFS. Then when you think you have done a mistake command, you
> could rollback from this File System.
> 
> This is just a RFC, I would give detail implementations. Would anyone
> please give me some suggestions? Thanks very much.

Anyway, you need to use Copy-On-Write (COW) approach for such file system.
But there are file systems that implements snapshot approach yet: NILFS2, ext3cow,
Next3, and so on.

Do you really want to implement something likewise snapshot feature in a file system
from the scratch?

With the best regards,
Vyacheslav Dubeyko.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

