Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3KBQ15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 12:27:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39467 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3KBQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 12:27:53 -0400
Date: Sat, 2 Nov 2013 16:27:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chen Gang <gang.chen@asianux.com>, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
Message-ID: <20131102162744.GJ13318@ZenIV.linux.org.uk>
References: <5271C5E5.6080606@asianux.com>
 <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com>
 <20131031190608.GH13318@ZenIV.linux.org.uk>
 <CAGXu5jJkXj975rbpJo8pTLakPLLpVVse+ecxwQ7Ds2x-ARAOxQ@mail.gmail.com>
 <20131031204558.GA30290@kroah.com>
 <527314D5.7090004@asianux.com>
 <52750237.5060409@asianux.com>
 <20131102154446.GB23938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131102154446.GB23938@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 02, 2013 at 08:44:46AM -0700, Greg KH wrote:

> > Oh, for me, it is not suitable to move a file system sub-directory to
> > "drivers/*/" sub-directory. And I can not find any sub-directory like
> > 'staging' under "fs" sub-directory, either.
> > 
> > Do we have any sub-directory like "staging" in "fs" sub-directory? if
> > no, do we have to create it or have to use another ways instead of?
> 
> Just move the filesystem to drivers/staging/befs.

Actually, having read through that code...  It's not too scary; r/w
support would've been much more hairy, but this is just r/o.  We
probably don't need to move that sucker at all.

As for befs_get_block(), I'd suggest
	* taking the range checks for block number into its ->bmap()
(just check against the file size and return 0 if it doesn't fit)
	* turning the check for create != 0 into BUG_ON(create)
	* making the befs_fblock2brun() failure quiet - the sucker
will complain itself, just return that -EFBIG and be done with that.
