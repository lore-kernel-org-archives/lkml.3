Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaKDUUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:20:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41868 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKDUU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:20:28 -0500
Date: Tue, 4 Nov 2014 20:20:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
Message-ID: <20141104202018.GM7996@ZenIV.linux.org.uk>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
 <20141104153940.GH7996@ZenIV.linux.org.uk>
 <54592D49.4070704@amacapital.net>
 <20141104195514.GA28531@quack.suse.cz>
 <CALCETrV3DauoM0x9aiEdKtZLxXqfeEapsWD-t3n_norkX5To7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV3DauoM0x9aiEdKtZLxXqfeEapsWD-t3n_norkX5To7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:14:26PM -0800, Andy Lutomirski wrote:

> Yeah, this idea clearly doesn't work.  But I wonder whether the
> revised variant (which may be just moving cd_forget and bd_forget from
> evict to iput_final) would work.

How the hell is it better?  Neither of those will happen as long as dentry
is retained.  And with /dev on tmpfs (which is bloody common) _that_ won't
happen until device node is unlinked...
