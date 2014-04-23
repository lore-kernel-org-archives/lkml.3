Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaDWP3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaDWP33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:29:29 -0400
Date: Wed, 23 Apr 2014 11:28:43 -0400
From: Jeff Layton <jlayton@redhat.com>
To: ams@gnu.org
Cc: libc-alpha@sourceware.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, dalias@libc.org,
        mtk.manpages@gmail.com, samba-technical@lists.samba.org,
        nfs-ganesha-devel@lists.sourceforge.net, carlos@redhat.com,
        metze@samba.org, hch@infradead.org, bharrosh@panasas.com
Subject: Re: [RFC][glibc PATCH] fcntl-linux.h: add new definitions and
 manual updates for open file description locks
Message-ID: <20140423112843.77889d16@tlielax.poochiereds.net>
In-Reply-To: <E1Wcyo3-0000Eg-UC@fencepost.gnu.org>
References: <1398253172-9221-1-git-send-email-jlayton@redhat.com>
	<E1Wcyo3-0000Eg-UC@fencepost.gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 11:09:51 -0400
ams@gnu.org (Alfred M. Szmidt) wrote:

>    @@ -2890,7 +2894,7 @@ Get flags associated with the open file.  @xref{File Status Flags}.
>     Set flags associated with the open file.  @xref{File Status Flags}.
> 
>     @item F_GETLK
>    -Get a file lock.  @xref{File Locks}.
>    +Test a file lock.  @xref{File Locks}.
> 
> F_GETLK does get the (first) lock which blocks; it doesn't test for
> it.  "Retrieves information about the first blocking lock ..." or
> something might be better than the original
> 
>    @@ -2898,6 +2902,18 @@ Set or clear a file lock.  @xref{File Locks}.
>     @item F_SETLKW
>     Like @code{F_SETLK}, but wait for completion.  @xref{File Locks}.
> 
>    +@item F_OFD_GETLK
>    +Test a open file description lock.  @xref{Open File Description Locks}.
>    +Specific to Linux.
> 
> Likewise.  You infact write that it does get the lock information
> later in the document wrt. F_OFD_GETLK.

Sorry, I disagree here...GETLK is really a misnomer, IMO. TESTLK would
have been a better name.

It's a way to test whether a particular lock can be applied, and to
return information about a conflicting lock if it can't. If, for
instance there is no conflicting lock, then you don't "get" any lock
information back (l_type just gets reset to F_UNLCK).

-- 
Jeff Layton <jlayton@redhat.com>
