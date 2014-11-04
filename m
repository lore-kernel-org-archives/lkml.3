Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaKDU0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:26:12 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:53982 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaKDU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:26:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141104202018.GM7996@ZenIV.linux.org.uk>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
 <20141104153940.GH7996@ZenIV.linux.org.uk> <54592D49.4070704@amacapital.net>
 <20141104195514.GA28531@quack.suse.cz> <CALCETrV3DauoM0x9aiEdKtZLxXqfeEapsWD-t3n_norkX5To7Q@mail.gmail.com>
 <20141104202018.GM7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Nov 2014 12:25:47 -0800
Message-ID: <CALCETrX4ZZcokwMGP6SQbSG5+3vZ8K3ZVU9ZX6Kjj1qdTqr_8w@mail.gmail.com>
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 12:20 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Nov 04, 2014 at 12:14:26PM -0800, Andy Lutomirski wrote:
>
>> Yeah, this idea clearly doesn't work.  But I wonder whether the
>> revised variant (which may be just moving cd_forget and bd_forget from
>> evict to iput_final) would work.
>
> How the hell is it better?  Neither of those will happen as long as dentry
> is retained.  And with /dev on tmpfs (which is bloody common) _that_ won't
> happen until device node is unlinked...

It's by my misunderstanding of how inode refcounting works.  The idea
would be to drop the cdev reference when there are no non-VFS-internal
references to the inode left.
