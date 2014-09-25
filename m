Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaIYPEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:04:07 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:33097 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaIYPEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:04:05 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <87y4t9ndw5.fsf@x220.int.ebiederm.org>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
	<20140910123525.GA29064@ubuntu-hedt>
	<20140910162155.GA7748@mail.hallyn.com>
	<20140910164212.GA32587@ubuntu-hedt>
	<20140911181034.GA58733@ubuntu-hedt>
	<87d2am3r8a.fsf@x220.int.ebiederm.org>
	<20140924132925.GA48721@ubuntu-hedt>
	<87y4t9ndw5.fsf@x220.int.ebiederm.org>
Date: Thu, 25 Sep 2014 17:04:04 +0200
Message-ID: <CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 7:10 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:


> So in summary I see:
> - Low utility in being able to manipulate files with bad uids.
> - Bad uids are mostly likely malicious action.
> - make_bad_inode is trivial to analyze.
> - No impediments to change if I am wrong.
>
> So unless there is a compelling case, right now I would recommend
> returning -EIO initially.   That allows us to concentrate on the easier
> parts of this and it leaves the changes only in fuse.

The problem with marking the inode bad is that it will mark it bad for
all instances of this filesystem.  Including ones which are in a
namespace where the UIDs make perfect sense.

So that really doesn't look like a good solution.

Doing the check in inode_permission() might be too heavyweight, but
it's still the only one that looks sane.

Thanks,
Miklos
