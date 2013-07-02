Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3GBRSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:18:36 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46526 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GBRSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <nsxbo6mxu38.fsf@lambda.thunk.org>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
Date: Tue, 2 Jul 2013 10:18:32 -0700
X-Google-Sender-Auth: jTRr2zKLeC9mvJzOqicZf3lcIWo
Message-ID: <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm I'm getting this compiler warning:

  fs/ext4/inode.c: In function ‘ext4_writepages’:
  fs/ext4/inode.c:2219:6: warning: ‘err’ may be used uninitialized in
this function [-Wmaybe-uninitialized]

and I think the compiler is right to warn. The 'err' variable is set
inside a whilte() and an if() statement, and it is not at all obvious
that those codepaths are always taken.

Maybe that "map->m_len" is always guaranteed to be nonzero, and the
"while()" statement could be a "do { } while()" one. But if so, make
it so, don't write code as if it might never be executed, when the
return value seems to *depend* on it being executed.

Or just initialize the variable correctly.

This warning may not be new to this pull, I just happened to notice it now.

                Linus
