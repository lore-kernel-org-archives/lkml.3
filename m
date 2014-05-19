Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaESNSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:18:30 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57445 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaESNS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:18:28 -0400
Message-ID: <537A0495.60107@gmail.com>
Date: Mon, 19 May 2014 15:18:13 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: mtk.manpages@gmail.com
Subject: OFD locks and deadlock detection
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I just happened to notice :

    commit 57b65325fe34ec4c917bc4e555144b4a94d9e1f7
    Author: Jeff Layton <jlayton@redhat.com>
    Date:   Mon Feb 3 12:13:09 2014 -0500

        locks: skip deadlock detection on FL_FILE_PVT locks

And then this thread:

    http://thread.gmane.org/gmane.linux.file-systems/81318/focus=81327
    From: Jeff Layton <jlayton <at> redhat.com>
    Subject: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
    Date: 2014-01-09 14:19:46 GMT

I think it's pretty important to document that. All implementations
of traditional process-associated (.k.a. "POSIX") locks that I've ever 
come across do detect deadlocks, so it's important to note that OFD locks 
do not.

I plan to add the following text to the fcntl(2) page:

[[
In the current implementation,
no deadlock detection is performed for open file description locks.
(This contrasts with process-associated record locks,
for which the kernel does perform deadlock detection.)
]]

Okay?

cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
