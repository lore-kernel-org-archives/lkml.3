Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3J0Idw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 04:33:52 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:43783 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3J0Idu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 04:33:50 -0400
MIME-Version: 1.0
In-Reply-To: <20131027013402.GA7146@leaf>
References: <20131024122255.GI9378@mwanda> <20131024122512.GB9534@mwanda>
 <20131026181709.GB10488@kroah.com> <20131027013402.GA7146@leaf>
From: Duy Nguyen <pclouds@gmail.com>
Date: Sun, 27 Oct 2013 15:33:19 +0700
Message-ID: <CACsJy8CKUygqbMKK_mkOY2C5whqHN=d+6ME_jkXpPebxeSd3Tw@mail.gmail.com>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
To: Josh Triplett <josh@joshtriplett.org>
Cc: Git Mailing List <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 8:34 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> Add a command line option for git commit to automatically construct the
> "Fixes:" line for a commit.  This avoids the need to manually construct
> that line by copy-pasting the commit hash and subject.

But you still have to copy/paste the hash in command line. I wonder if
we should approach it differently: the user writes "Fixes: <hash>" in
the commit message, then git detects these lines and expands them
using a user-configured format. For the kernel circle, the format
would be "%h ('%s')" (I'll need to think how to let the user say
"minimum 12 chars").

Other projects need to refer to old commits sometimes in commit
messages too and this could be extended further to expand inline
abbrev sha-1s, but to not break the text alignment badly, maybe
footnotes will be created to store subjects and stuff, rather than do
inline expansion. For example,

  commit 1232343 breaks something.....

becomes

  comit 1232343 [1] breaks something....

  [1] 123234332131 (do something wrong - at this date)
-- 
Duy
