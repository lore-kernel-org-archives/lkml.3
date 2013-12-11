Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3LKSyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:54:09 -0500
Received: from alt-proxy1.mail.unifiedlayer.com ([70.40.203.67]:50047 "HELO
	alt-proxy1.mail.unifiedlayer.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750911Ab3LKSyG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:54:06 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 13:54:06 EST
Subject: Re: [PATCH] hfsplus: Remove hfsplus_file_lookup
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <1386780980.9524.10.camel@ultrabook>
Date: Wed, 11 Dec 2013 22:49:29 +0300
Cc: <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Szabolcs Szakacsits <szaka@tuxera.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <AE333CDA-DD74-42B8-92F4-551ACCAD8AFA@dubeyko.com>
References: <1386780980.9524.10.camel@ultrabook>
To: <sougata@tuxera.com>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 11, 2013, at 7:56 PM, Sougata Santra wrote:

[snip]
> In OSX, we can open "file/rsrc" to get the resource fork of "file".
> This behavior is emulated inside hfsplus on Linux, which means that
> to some degree every file acts like a directory. That is the reason
> lookup() inode operations is supported for files, and it is possible
> to do a lookup on this specific name. As a result of this open succeeds
> without returning  ENOTDIR for HFS+
> "
> Please see the LKML discussion thread on this issue:
> http://marc.info/?l=linux-fsdevel&m=122823343730412&w=2 
> 
> I tried to test file/rsrc lookup in HFS+ driver and the feature does not work.
> From OSX:
> $ touch test
> $ echo "1234" > test/..namedfork/rsrc
> $ ls -l test..namedfork/rsrc
> --rw-r--r-- 1 tuxera staff 5 10 dec 12:59 test/..namedfork/rsrc
> 
> [sougata@ultrabook tmp]$ id
> uid=1000(sougata) gid=1000(sougata) groups=1000(sougata),5(tty),18(dialout),1001(vboxusers)
> 
> [sougata@ultrabook tmp]$ mount
> /dev/sdb1 on /mnt/tmp type hfsplus (rw,relatime,umask=0,uid=1000,gid=1000,nls=utf8)
> 
> [sougata@ultrabook tmp]$ ls -l test/rsrc
> ls: cannot access test/rsrc: Permission denied
> 
> According to this LKML thread it is expected behavior.
> http://marc.info/?t=121139033800008&r=1&w=4
> I guess now that permission checking happens in vfs generic_permission() ?
> So it turns out that even though the lookup() inode_operation exists for HFS+ files.
> It cannot really get invoked ?. So if we can disable this feature to make opendir()
> work for HFS+.
> 

This feature worked earlier under Linux. So, I suppose that some changes in HFS+ driver
or in VFS broke it. And it needs to investigate and fix the reported issue. Thank you for the
report.

But I think that this patch can't be the solution of the issue. So, if you want then
you can investigate and fix the issue. Could you do it?

Thanks,
Vyacheslav Dubeyko.

