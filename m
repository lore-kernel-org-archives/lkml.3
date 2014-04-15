Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaDOOFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:05:19 -0400
Received: from mano-163-56-shared.jabatus.fr ([109.234.163.56]:33948 "EHLO
	mano-163-56-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbaDOOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:05:13 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 91E9D8F62279.A0C5D
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3765.4090403@manux.info>
Date: Tue, 15 Apr 2014 15:43:01 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][6/11][MANUX] Kernel compatibility : directory hardlinks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now for something that has to do both with syscalls and filesystems...

My operating system relies heavily upon hardlinks, and, amongst others,
directory hardlinks. (Yes, that's what my ext2l partitions are for. Not
only, but this is part of it).

To allow distinguishing them from true directories, I've introduced a
value S_IFDHL equal to 0130000, both for the file mode in stat(2) and
for the type_entry field in the dirent structure, in getdents64(2).
(However, it's not visible to normal applications, because seeing this
value in getdents() requires asking for it with a new syscall and having
the privileges to do so, while seeing the value in stat(2) is impossible
for them because their call gets routed towards the target directory -
my directory hardlinks are implemented somewhat like symlinks, but with
inode numbers. Thus, the userspace requires no modifications).

Is this value acceptable? And, if it is, could you mark it as reserved
(or otherwise avoid reusing it), so that there's no collision with it in
the future?

Thank you,

Emmanuel
