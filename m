Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3KBPml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:42:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3KBPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:42:39 -0400
Date: Sat, 2 Nov 2013 08:44:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
Message-ID: <20131102154446.GB23938@kroah.com>
References: <5271C5E5.6080606@asianux.com>
 <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com>
 <20131031190608.GH13318@ZenIV.linux.org.uk>
 <CAGXu5jJkXj975rbpJo8pTLakPLLpVVse+ecxwQ7Ds2x-ARAOxQ@mail.gmail.com>
 <20131031204558.GA30290@kroah.com>
 <527314D5.7090004@asianux.com>
 <52750237.5060409@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52750237.5060409@asianux.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 02, 2013 at 09:46:31PM +0800, Chen Gang wrote:
> On 11/01/2013 10:41 AM, Chen Gang wrote:
> > On 11/01/2013 04:45 AM, Greg KH wrote:
> >> On Thu, Oct 31, 2013 at 12:08:33PM -0700, Kees Cook wrote:
> >>> On Thu, Oct 31, 2013 at 12:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >>>> On Thu, Oct 31, 2013 at 09:53:59AM -0700, Kees Cook wrote:
> >>>>
> >>>>> If block (type sector_t) is unsigned, we shouldn't cast it signed.
> >>>>> This entire code path should be removed. What is BEFS's expected
> >>>>> maximum block size? (Looks like even befs_blocknr_t is u64, so nothing
> >>>>> seems trivially in danger of wrapping.) I would also note that all the
> >>>>> format strings are wrong too (%ld instead of %lu).
> >>>>
> >>>> FWIW, this
> >>>>         res = befs_fblock2brun(sb, ds, block, &run);
> >>>>         if (res != BEFS_OK) {
> >>>>                 befs_error(sb,
> >>>>                            "<--- befs_get_block() for inode %lu, block "
> >>>>                            "%ld ERROR", inode->i_ino, block);
> >>>>                 return -EFBIG;
> >>>>         }
> >>>> also looks wrong - ioctl(..., FIBMAP, ...) shouldn't be able to spew
> >>>> printks on a valid fs and hitting it with block number greater than
> >>>> file length will, AFAICS, trigger that.
> >>>>
> >>>> I agree that this code needs fixing, but just making gcc STFU about the
> >>>> comparison would only serve to hide the problem.  Anybody familiar with
> >>>> befs or willing to learn it?
> >>>
> >>> Agreed. MAINTAINERS shows it as orphaned. Perhaps it should be moved
> >>> into staging?
> >>
> >> Only if we want to delete the thing.  I'll be glad to take it there, and
> >> remove it in 2 releases and then if anyone complains, we can add it back
> >> easily.  Just let me know.
> >>
> > 
> > Excuse me, I am not quite familiar with BEFS, I guess your meaning is:
> > 
> >   "if it is no further more discussion (e.g. within 1 week, no members reply), you will remove it (take it to "drivers/staging" sub-directory)".
> > 
> 
> Oh, for me, it is not suitable to move a file system sub-directory to
> "drivers/*/" sub-directory. And I can not find any sub-directory like
> 'staging' under "fs" sub-directory, either.
> 
> Do we have any sub-directory like "staging" in "fs" sub-directory? if
> no, do we have to create it or have to use another ways instead of?

Just move the filesystem to drivers/staging/befs.

