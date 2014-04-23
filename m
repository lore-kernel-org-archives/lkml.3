Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbaDWTAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:00:30 -0400
Received: from fencepost.gnu.org ([208.118.235.10]:55082 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbaDWTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:00:27 -0400
Date: Wed, 23 Apr 2014 15:00:06 -0400
Message-Id: <E1Wd2Os-00061e-GU@fencepost.gnu.org>
From: ams@gnu.org (Alfred M. Szmidt)
To: Jeff Layton <jlayton@redhat.com>
CC: libc-alpha@sourceware.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, dalias@libc.org,
        mtk.manpages@gmail.com, samba-technical@lists.samba.org,
        nfs-ganesha-devel@lists.sourceforge.net, carlos@redhat.com,
        metze@samba.org, hch@infradead.org, bharrosh@panasas.com
In-reply-to: <20140423112843.77889d16@tlielax.poochiereds.net> (message from
	Jeff Layton on Wed, 23 Apr 2014 11:28:43 -0400)
Subject: Re: [RFC][glibc PATCH] fcntl-linux.h: add new definitions and
 manual updates for open file description locks
Reply-to: ams@gnu.org
References: <1398253172-9221-1-git-send-email-jlayton@redhat.com>
	<E1Wcyo3-0000Eg-UC@fencepost.gnu.org> <20140423112843.77889d16@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   > Likewise.  You infact write that it does get the lock information
   > later in the document wrt. F_OFD_GETLK.

   Sorry, I disagree here...GETLK is really a misnomer, IMO. TESTLK
   would have been a better name.

   GETLK are used is to "get the first lock".

   It's a way to test whether a particular lock can be applied, and to
   return information about a conflicting lock if it can't. If, for
   instance there is no conflicting lock, then you don't "get" any
   lock information back (l_type just gets reset to F_UNLCK).

While I kinda see your point, it isn't what GETLK does; it really does
get you information about the first lock -- you're not testing
anything.  It is also the terminology used in the POSIX standard.
