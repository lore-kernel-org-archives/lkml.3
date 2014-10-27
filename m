Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaJ0Sni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:43:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35144 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaJ0Sng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:43:36 -0400
From: Richard Yao <ryao@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mateusz Guzik <mguzik@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@gentoo.org, Matthew Thode <mthode@mthode.org>,
        =?UTF-8?q?Michael=20M=C3=BCller?= <michael@fds-team.de>,
        Daniel Robbins <drobbins@funtoo.org>, Richard Yao <ryao@gentoo.org>
Subject: [PATCH v4 0/1] vfs: Respect MS_RDONLY at bind mount creation
Date: Mon, 27 Oct 2014 14:43:25 -0400
Message-Id: <1414435406-59678-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus,

Here is the patch that we discussed at LinuxCon Europe. My plan was to send it
the week after LinuxCon Europe (last week) as you had asked. However, I caught
somethng at the conference and was sick last week, so that was delayed.

The history of the patch is that the v1 was done in July. I sent v2 shortly
afterward upon realizing that v1 did not take the opportunity atomically close
the race with respect to bind mounting and marking readonly. v3 and v4 followed
with feedback from Mateusz Guzik, but aside from him, no one else replied.

Then at LinuxCon Europe, I spoke briefly to Mauro Carvalho Chehab, Ted T'so and
yourself about it. Mauro thought it looked okay, but he told me not to include
his ACKed by because he is not involved in this subsystem. Ted was surprised
that this was even a bug. The two of us spoke about so many filesystem things
that I neglected to ask if including him as ACKed by was okay. I have CCed
Mateusz, Ted, Mauro, the usual people from get_maintainers.pl and other
interested parties.

Yours truly,
Richard Yao

Richard Yao (1):
  vfs: Respect MS_RDONLY at bind mount creation

 fs/namespace.c | 20 ++++++++++++++++----
 fs/pnode.h     | 17 +++++++++--------
 2 files changed, 25 insertions(+), 12 deletions(-)

-- 
2.0.4

