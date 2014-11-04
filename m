Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaKDUQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:16:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41855 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaKDUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:16:28 -0500
Date: Tue, 4 Nov 2014 20:16:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
Message-ID: <20141104201620.GL7996@ZenIV.linux.org.uk>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
 <20141104153940.GH7996@ZenIV.linux.org.uk>
 <54592D49.4070704@amacapital.net>
 <CALCETrViY8biMs=D9XKAJx-9m5iEEUCbpzmOR2QFVyxcdoczxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrViY8biMs=D9XKAJx-9m5iEEUCbpzmOR2QFVyxcdoczxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:52:22AM -0800, Andy Lutomirski wrote:

> Let me try again, though: what if a chardev inode replaced i_cdev with
> NULL and dropped its kobj reference in iput_final?  This would add a
> bit over overhead to things that repeatedly open and close the same
> device node, but I doubt this matters much.

How is it different from what Jan proposed?  The whole problem is that
iput_final() is too late.  We could clean the reference on close, all
right, and have it looked up again on every open, but I'm not at all sure
that situation with opening/closing cdev is never a hot path, especially with
udev playing silly buggers, etc.
