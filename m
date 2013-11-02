Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3KBV1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 17:27:45 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33862 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3KBV1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 17:27:43 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Pax Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/2] IPC DoS fix
Date: Sat,  2 Nov 2013 22:26:37 +0100
Message-Id: <1383427599-1980-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this series fixes a bug in the IPC code that allows root to instantly crash
the system. The first patch fixes the bug, the second one prevents msgmax
from getting negative in the first place. As that *might* break existing
userspace (for good?!) it's a separate patch.

The cc list is quite randomly choosen as there seem to be no maintainer for
ipc/. :/

Please apply!


Mathias Krause (2):
  ipc, msg: fix message length check for negative values
  ipc, msg: forbid negative values for "msgmax"

 ipc/ipc_sysctl.c |    6 +++---
 ipc/msg.c        |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.10.4

