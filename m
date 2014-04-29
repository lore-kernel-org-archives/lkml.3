Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbaD2IjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:39:01 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55209 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbaD2Ii6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:38:58 -0400
Message-ID: <535F651E.6090204@gmail.com>
Date: Tue, 29 Apr 2014 10:38:54 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: mtk.manpages@gmail.com,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        samba-technical@lists.samba.org,
        "Michael Kerrisk (gmail)" <mtk.manpages@gmail.com>
Subject: OFD ("file private") locks and NFS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I've been looking a bit at the fcntl() documentation of traditional 
(F_SETLK) record locking, and a question just jumped out at me. Is 
it worth considering some future-proofing in the design of OFD locks
("open file description locks", formerly known as "file-private locks")?

What I am thinking of here is that on some systems, the traditional
'struct flock' has a nonstandard field, l_sysid, that is used on F_GETLK 
to identify the remote system on which a lock is held. Should the design
of OFD locks allow for such a field (now, or in the future), which might 
be useful in the context of locking on network file systems such as NFS.

Put more simply, should the new OFD locking system be using a new
structure for describing locks, rather than the traditional 'struct
flock'? Defining a new structure, might be useful to allow for
future extensions to the API.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
