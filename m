Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaAOSfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:35:08 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48990 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaAOSfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:35:06 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20140115181955.GA5715@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-6-git-send-email-miklos@szeredi.hu>
	<20140115181955.GA5715@fieldses.org>
Date: Wed, 15 Jan 2014 19:35:04 +0100
Message-ID: <CAJfpeguPj-P3tYx8w7-Sqma0K8SSbRxEQdGhTGMs=FtVRC8QSg@mail.gmail.com>
Subject: Re: [PATCH 05/11] vfs: add RENAME_NOREPLACE flag
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 7:19 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Wed, Jan 08, 2014 at 11:10:09PM +0100, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> If this flag is specified and the target of the rename exists then the
>> rename syscall fails with EEXIST.
>
> Why is this useful?
>
> (I'm sure it is, it'd just be useful to have the reasons recorded
> someplace.)
>
>> The VFS does the existence checking, so it is trivial to enable for most
>> local filesystems.  This patch only enables it in ext4.
>>
>> For network filesystems the VFS check is not enough as there may be a race
>> between a remote create and the rename, so these filesystems need to handle
>> this flag in their ->rename() implementations to ensure atomicity.
>
> Till that's done this should probably result in -EOPNOTSUPP on those
> filesystems?
>
> I think this would need new protocol in the NFS case.

Yes, it needs to be enabled on a case-by-case basis.  Only enabled for
ext4 now, but trivial to do for most fs.

Thanks,
Miklos
