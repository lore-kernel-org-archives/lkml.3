Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaDPS6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:58:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbaDPS6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:58:07 -0400
Date: Wed, 16 Apr 2014 14:57:46 -0400
From: Jeff Layton <jlayton@redhat.com>
To: libc-alpha <libc-alpha@sourceware.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Carlos O'Donell" <carlos@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        samba-technical@lists.samba.org,
        nfs-ganesha-devel@lists.sourceforge.net
Subject: should we change the name/macros of file-private locks?
Message-ID: <20140416145746.66b7441c@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to spam so many lists, but I think this needs widespread
distribution and consensus.

File-private locks have been merged into Linux for v3.15, and *now*
people are commenting that the name and macro definitions for the new
file-private locks suck.

...and I can't even disagree. They do suck.

We're going to have to live with these for a long time, so it's
important that we be happy with the names before we're stuck with them.

Michael Kerrisk suggested several names but I think the only one that
doesn't have other issues is "file-associated locks", which can be
distinguished against "process-associated" locks (aka classic POSIX
locks).

At the same time, he suggested that we rename the command macros since
the 'P' suffix would no longer be relevant. He suggested something like
this:

    F_FA_GETLK
    F_FA_SETLK
    F_FA_SETLKW

That would also make them more visually distinguishable from the
classic F_GETLK/F_SETLK/F_SETLKW commands. I like that change in
particular, as the original macros names would be easy to typo.

I think we'd also need to rename how these are reported in /proc/locks.
Currently they have a type label of "FLPVT". I'd suggest that we
change that to "FASSOC". For v3.15, this is the only part we'd
absolutely have to change before it ships. The rest I can fix up in
v3.16.

Does this sound like a reasonable set of changes to make? Does anyone
else have a better set of names they can suggest? Speak now, or forever
hold your peace!

-- 
Jeff Layton <jlayton@redhat.com>
