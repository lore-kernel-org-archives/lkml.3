Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaESO2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:28:11 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50785 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaESO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:28:07 -0400
Date: Mon, 19 May 2014 10:28:02 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: OFD locks and deadlock detection
Message-ID: <20140519102802.16dee141@tlielax.poochiereds.net>
In-Reply-To: <537A0495.60107@gmail.com>
References: <537A0495.60107@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 15:18:13 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> Hi Jeff,
> 
> I just happened to notice :
> 
>     commit 57b65325fe34ec4c917bc4e555144b4a94d9e1f7
>     Author: Jeff Layton <jlayton@redhat.com>
>     Date:   Mon Feb 3 12:13:09 2014 -0500
> 
>         locks: skip deadlock detection on FL_FILE_PVT locks
> 
> And then this thread:
> 
>     http://thread.gmane.org/gmane.linux.file-systems/81318/focus=81327
>     From: Jeff Layton <jlayton <at> redhat.com>
>     Subject: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
>     Date: 2014-01-09 14:19:46 GMT
> 
> I think it's pretty important to document that. All implementations
> of traditional process-associated (.k.a. "POSIX") locks that I've ever 
> come across do detect deadlocks, so it's important to note that OFD locks 
> do not.
> 
> I plan to add the following text to the fcntl(2) page:
> 
> [[
> In the current implementation,
> no deadlock detection is performed for open file description locks.
> (This contrasts with process-associated record locks,
> for which the kernel does perform deadlock detection.)
> ]]
> 
> Okay?
> 
> cheers,
> 
> Michael
> 
> 

(note: I'm no longer with Red Hat, so jlayton@redhat.com no longer works)

Sounds fine to me.

FWIW, the deadlock detection for process-associated record locks is
pretty worthless except in certain narrow circumstances.

At some point, we probably should have a discussion as to whether
deadlock detection is really something we want to keep. The current
implementation requires a global spinlock which has obvious
consequences for scalability.

Thanks,
-- 
Jeff Layton <jlayton@poochiereds.net>
